pageextension 50135 PurchInvoiceExt extends "Purchase Invoice"
{
    layout
    {
        movebefore("Buy-from Contact"; "Buy-from Contact No.")
        addafter("Buy-from Vendor Name")
        {
            field("Your Reference"; Rec."Your Reference") { ApplicationArea = All; QuickEntry = true; InstructionalText = 'What the order is for...'; ShowMandatory = true; }
        }
        addafter("Buy-from")
        {
            field("Order Vendor Notes"; VendorNotes)
            {
                Caption = 'Vendor Notes';
                MultiLine = true;
                ApplicationArea = All;
                Importance = Standard;
                ToolTip = 'This SHOULD be the vendor notes brought across to the orders';
                QuickEntry = false;
                Editable = true;

                trigger OnValidate()
                begin
                    RecVendor."Vendor Notes" := VendorNotes;
                    RecVendor.Modify();
                    Commit();
                end;
            }
            field("Preferred Payment Method"; PaymentMethod)
            {
                ApplicationArea = All;
                Caption = 'Preferred Payment Method';
                ToolTip = 'Pulled from Vendor card on creation of order';
                Editable = false;
                Style = Strong;
            }
        }
        addafter("Your Reference")
        {
            field("Order Notes"; Rec."Order Notes")
            {
                ApplicationArea = All;
                QuickEntry = false;
                Importance = Standard;
                MultiLine = true;
                InstructionalText = 'Notes about this order...';
            }
        }
        moveafter("Your Reference"; Status, "Vendor Invoice No.", "Payment Method Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")
        modify("Buy-from Contact") { QuickEntry = false; }
        modify("Document Date") { Visible = true; Importance = Standard; }
        moveafter("VAT Reporting Date"; "Document Date")
        modify("Due Date") { Visible = true; Importance = Standard; }
        modify("Posting Date") { Visible = true; Importance = Standard; }
        modify("VAT Reporting Date") { Visible = true; Importance = Standard; }
        modify("Purchaser Code") { Visible = false; }
        modify("Campaign No.") { Visible = false; }
        modify("Buy-from Vendor No.") { Importance = Standard; }
        modify("Assigned User ID") { Importance = Standard; }
        modify("Payment Method Code") { Importance = Standard; ShowMandatory = true; }
        modify(BuyFromContactMobilePhoneNo) { Importance = Standard; }
        modify(BuyFromContactPhoneNo) { Importance = Standard; }
        modify(BuyFromContactEmail) { Importance = Standard; }
        modify("Payment Reference") { Importance = Standard; }
        modify("Currency Code") { Importance = Standard; }
        addafter("On Hold")
        {
            field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
            {
                ApplicationArea = All;
                ToolTip = 'Assign to a document type...';
                Importance = Additional;
            }
            field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
            {
                ApplicationArea = All;
                ToolTip = 'Choose a document/payment to assign this record against.';
                Importance = Additional;
            }
            field("Applies-to ID"; Rec."Applies-to ID")
            {
                ApplicationArea = All;
                ToolTip = 'ID or Code for the applies to fields.';
                Importance = Additional;
            }
        }
        modify("Foreign Trade") { Visible = false; }
    }
    actions
    {
        addlast("F&unctions")
        {
            action(PostedInvoices)
            {
                ApplicationArea = All;
                Image = PurchaseInvoice;
                Caption = 'Posted Invoices';
                RunObject = page "Posted Purchase Invoices";
                RunPageLink = "Buy-from Vendor No." = field("Buy-from Vendor No.");
                Description = 'Open list of posted purchase invoices.';
                ToolTip = 'Opens the list of posted purchase invoices.';
                Visible = true;
                Enabled = true;
            }
            action(VendorLedgerEntries)
            {
                ApplicationArea = All;
                Image = LedgerEntries;
                Caption = 'Vendor Ledger';
                RunObject = page "Vendor Ledger Entries";
                RunPageLink = "Vendor No." = field("Buy-from Vendor No.");
                Description = 'Open vendor ledger entries list for this vendor.';
                ToolTip = 'Opens the list of vendor ledger entries for this vendor.';
                Visible = true;
                Enabled = true;
            }
        }
        addafter(Category_Category10)
        {
            actionref(CopyDocument2; CopyDocument) { }
        }
        addlast(Category_Process)
        {
            actionref(RecurringLines; GetRecurringPurchaseLines) { }
            actionref(VendorCard; Vendor) { }
            actionref(PostedInvoices_Promoted; PostedInvoices) { }
            actionref(VendorLedger_Promoted; VendorLedgerEntries) { }
            actionref(Statistics3; PurchaseStatistics) { Visible = true; }
        }
        modify(PurchaseStatistics) { Visible = true; }
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    Rec.Validate(Rec."Posting Date", Today);
                    Rec.Modify();
                end;
            end;
        }
        modify(PostAndPrint)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    Rec.Validate(Rec."Posting Date", Today);
                    Rec.Modify();
                end;
            end;
        }
        modify(PostAndNew)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    Rec.Validate(Rec."Posting Date", Today);
                    Rec.Modify();
                end;
            end;
        }
        // modify(Preview)
        // {
        //     trigger OnBeforeAction()
        //     begin
        //         if rec."Posting Date" = 0D then begin
        //             Rec.Validate("Posting Date", Today);
        //             Rec.Modify();
        //         end;
        //     end;
        // }
        modify("Re&lease") { Enabled = ReleaseControllerStatus; }
        modify(Reopen) { Enabled = ReopenControllerStatus; }
    }

    var
        RecVendor: Record Vendor;
        ReleaseControllerStatus: Boolean;
        ReopenControllerStatus: Boolean;
        PaymentMethod: Text[50];
        VendorNotes: Text[1000];

    trigger OnInsertRecord(BelowXRec: Boolean): Boolean
    begin
        Rec."Assigned User ID" := USERID;
        RecVendor.SetRange("No.", Rec."Buy-from Vendor No.");
        if RecVendor.FindSet() then begin
            VendorNotes := RecVendor."Vendor Notes";
            PaymentMethod := RecVendor."Preferred Payment Method";
            //Rec.Modify()
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec.Validate(Rec."Your Reference", UpperCase(Rec."Your Reference"));
    end;

    trigger OnOpenPage()
    begin
        InitPageControllers();
        RecVendor.SetRange("No.", Rec."Buy-from Vendor No.");
        if RecVendor.FindSet() then begin
            VendorNotes := RecVendor."Vendor Notes";
            PaymentMethod := RecVendor."Preferred Payment Method";
            //Rec.Modify()
        end;
        // if () and (Rec."Posting Date" <> Today) then begin
        //     Rec.Validate(Rec."Posting Date", Today);
        //     Rec.Modify();
        // end;
    end;

    trigger OnAfterGetRecord()
    begin
        InitPageControllers();
        Rec.CalcFields("Amount Including VAT");
        RecVendor.SetRange("No.", Rec."Buy-from Vendor No.");
        if RecVendor.FindSet() then begin
            VendorNotes := RecVendor."Vendor Notes";
            PaymentMethod := RecVendor."Preferred Payment Method";
            //Rec.Modify()
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        InitPageControllers();
        RecVendor.SetRange("No.", Rec."Buy-from Vendor No.");
        if RecVendor.FindSet() then begin
            VendorNotes := RecVendor."Vendor Notes";
            PaymentMethod := RecVendor."Preferred Payment Method";
            //Rec.Modify()
        end;
    end;

    local procedure InitPageControllers()
    begin
        ReleaseControllerStatus := Rec.Status = Rec.Status::Open;
        ReopenControllerStatus := Rec.Status = Rec.Status::Released;
    end;
}
