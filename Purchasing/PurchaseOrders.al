pageextension 50133 PurchOrderExt extends "Purchase Order"
{
    layout
    {
        moveafter("Buy-from Vendor Name"; "Your Reference", Status, "Vendor Invoice No.")
        movebefore("Buy-from Contact"; "Buy-from Contact No.")
        modify("Your Reference")
        {
            ApplicationArea = All;
            QuickEntry = true;
            Importance = Standard;
        }
        addafter("Your Reference")
        {
            field("Preferred Payment Method"; PaymentMethod)
            {
                ApplicationArea = All;
                Caption = 'Preferred Payment Method';
                ToolTip = 'Pulled from Vendor card';
                Editable = false;
                Style = Strong;
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
        }
        addafter("Your Reference")
        {
            field("Order Notes"; Rec."Order Notes")
            {
                ApplicationArea = All;
                QuickEntry = false;
                Importance = Standard;
                MultiLine = true;
            }
        }
        modify("Order Date")
        {
            Visible = true;
            Importance = Standard;
        }
        modify("Document Date")
        {
            Visible = true;
            Importance = Standard;
        }
        modify("Due Date")
        {
            Visible = true;
            Importance = Standard;
        }
        modify("Posting Date")
        {
            Visible = true;
            Importance = Standard;
        }
        modify("VAT Reporting Date")
        {
            Visible = true;
            Importance = Standard;
        }
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
        }
        addlast(Category_Process)
        {
            actionref(RecurringLines; GetRecurringPurchaseLines)
            { }
            actionref(PostedReceipts_Promoted; Receipts)
            { }
            actionref(VendorCard; Vendor)
            { }
            actionref(Statistics2; Statistics)
            { }
            actionref(RecWorksheet_Promoted; ReqWorksheet)
            { }
        }
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    Rec.Validate("Posting Date", Today);
                    Rec.Modify();
                end;
            end;
        }
        modify("Post and &Print")
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    Rec.Validate("Posting Date", Today);
                    Rec.Modify();
                end;
            end;
        }
        modify(PostAndNew)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    Rec.Validate("Posting Date", Today);
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
        modify(Release)
        { Enabled = ReleaseControllerStatus; }
        modify(Reopen)
        { Enabled = ReopenControllerStatus; }
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
        Rec."Your Reference" := UpperCase(Rec."Your Reference");
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