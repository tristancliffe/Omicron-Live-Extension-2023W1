pageextension 50133 PurchOrderExt extends "Purchase Order"
{
    layout
    {
        moveafter("Buy-from Vendor Name"; "Your Reference", Status, "Vendor Invoice No.", "Payment Method Code", "Expected Receipt Date", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")

        movebefore("Buy-from Contact"; "Buy-from Contact No.")
        modify("Your Reference")
        {
            ApplicationArea = All;
            QuickEntry = true;
            Importance = Standard;
        }
        addafter("Vendor Invoice No.")
        {
            field("Order Notes"; Rec."Order Notes")
            {
                ApplicationArea = All;
                QuickEntry = false;
                Importance = Standard;
                MultiLine = true;
            }
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
                    RecVendor.Modify()
                end;
            }
            field("Preferred Payment Method"; PaymentMethod)
            {
                ApplicationArea = All;
                Caption = 'Preferred Payment Method';
                ToolTip = 'Pulled from Vendor card';
                Editable = false;
                Style = Strong;
            }
        }
        modify("Order Date")
        { Visible = true; Importance = Standard; }
        modify("Document Date")
        { Visible = true; Importance = Standard; }
        modify("Due Date")
        { Visible = true; Importance = Standard; }
        modify("Posting Date")
        { Visible = true; Importance = Standard; }
        modify("VAT Reporting Date")
        { Visible = true; Importance = Standard; }
        moveafter("VAT Reporting Date"; "Document Date")
        modify("Purchaser Code")
        { Visible = false; }
        modify("Assigned User ID")
        { Importance = Standard; }
        modify("Vendor Order No.")
        { Importance = Standard; }
        modify("Buy-from Vendor No.")
        { Importance = Standard; }
        modify("Payment Method Code")
        { Importance = Standard; ShowMandatory = true; }
        modify(BuyFromContactPhoneNo)
        { Importance = Standard; }
        modify(BuyFromContactMobilePhoneNo)
        { Importance = Standard; }
        modify(BuyFromContactEmail)
        { Importance = Standard; }
        modify("Payment Reference")
        { Importance = Standard; }
        modify("Currency Code")
        { Importance = Standard; }
        modify("Expected Receipt Date")
        { ShowMandatory = true; }
        addafter("Promised Receipt Date")
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
        movebefore("Document Date"; "Order Date")
        movebefore(Control1904651607; Control3)
        modify(Control1903326807)
        { Visible = true; }
    }
    actions
    {
        modify("Create &Whse. Receipt_Promoted")
        { Visible = false; }
        modify("Create Inventor&y Put-away/Pick_Promoted")
        { Visible = false; }
        modify("Send Intercompany Purchase Order_Promoted")
        { Visible = false; }
        addlast("F&unctions")
        {
            action(ReqWorksheet)
            {
                ApplicationArea = All;
                Image = MovementWorksheet;
                Caption = 'Requisition Worksheet';
                RunObject = page "Req. Worksheet";
                //RunPageLink = "No." = field("No.");
                Description = 'Go to the Requisition Worksheet to calculate orders';
                ToolTip = 'Opens the requisition worksheet. From there, orders can be calculated based on reordering policies and quantities.';
                Scope = Repeater;
                Visible = true;
                Enabled = true;
            }
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
        addlast(Category_Process)
        {
            actionref(RecurringLines; GetRecurringPurchaseLines)
            { }
            actionref(PostedReceipts_Promoted; Receipts)
            { }
            actionref(VendorCard; Vendor)
            { }
            actionref(PostedInvoices_Promoted; PostedInvoices)
            { }
            actionref(VendorLedger_Promoted; VendorLedgerEntries)
            { }
            actionref(Statistics2; Statistics)
            { }
            actionref(RecWorksheet_Promoted; ReqWorksheet)
            { }
        }
        addlast(Category_Category8)
        {
            actionref(TestPrepayment; "Prepayment Test &Report")
            { }
            actionref(PostPrepayment; PostPrepaymentInvoice)
            { }
            actionref(PostAndPrintPrepayment; "Post and Print Prepmt. Invoic&e")
            { }
        }
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    Rec.Validate(Rec."Posting Date", Today);
                    // Rec.Modify();
                end;
            end;
        }
        modify("Post and &Print")
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    Rec.Validate(Rec."Posting Date", Today);
                    // Rec.Modify();
                end;
            end;
        }
        modify(PostAndNew)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    Rec.Validate(Rec."Posting Date", Today);
                    // Rec.Modify();
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
        modify(Release)
        { Enabled = ReleaseControllerStatus; }
        modify(Reopen)
        { Enabled = ReopenControllerStatus; }
        addlast(Print)
        {
            action("Purchase Checklist")
            {
                ApplicationArea = Suite;
                Caption = 'Order Checklist';
                Image = "Report";
                ToolTip = 'Produce the purchase order checklist to check arrivals before ''recieving''';
                Ellipsis = true;

                trigger OnAction()
                var
                    Order: Record "Purchase Header";
                    Report: Report "Purchase Order Checklist";
                begin
                    Order.SetFilter("No.", Rec."No.");
                    Report.SetTableView(Order);
                    Report.RunModal();
                end;
            }
        }
        addlast(Category_Category10)
        {
            actionref(PrintCheckList; "Purchase Checklist")
            { }
        }
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
            // Rec.Modify()
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
            // Rec.Modify()
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        InitPageControllers();
        Rec.CalcFields("Amount Including VAT");
        RecVendor.SetRange("No.", Rec."Buy-from Vendor No.");
        if RecVendor.FindSet() then begin
            VendorNotes := RecVendor."Vendor Notes";
            PaymentMethod := RecVendor."Preferred Payment Method";
            // Rec.Modify()
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        InitPageControllers();
        RecVendor.SetRange("No.", Rec."Buy-from Vendor No.");
        if RecVendor.FindSet() then begin
            VendorNotes := RecVendor."Vendor Notes";
            PaymentMethod := RecVendor."Preferred Payment Method";
            // Rec.Modify()
        end;
    end;

    local procedure InitPageControllers()
    begin
        ReleaseControllerStatus := Rec.Status = Rec.Status::Open;
        ReopenControllerStatus := Rec.Status = Rec.Status::Released;
    end;
}