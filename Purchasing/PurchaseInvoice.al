pageextension 50135 PurchInvoiceExt extends "Purchase Invoice"
{
    layout
    {
        moveafter("Buy-from Vendor Name"; Status, "Vendor Invoice No.")
        movebefore("Buy-from Contact"; "Buy-from Contact No.")
        addafter("Buy-from Vendor Name")
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = All;
                QuickEntry = true;
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
            field("Preferred Payment Method"; PaymentMethod)
            {
                ApplicationArea = All;
                Caption = 'Preferred Payment Method';
                ToolTip = 'Pulled from Vendor card on creation of order';
                Editable = false;
                Style = Strong;
            }
            field("Order Notes"; Rec."Order Notes")
            {
                ApplicationArea = All;
                QuickEntry = false;
                Importance = Standard;
                MultiLine = true;
            }
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
        modify("Campaign No.")
        { Visible = false; }
        modify("Buy-from Vendor No.")
        { Importance = Standard; }
        modify("Assigned User ID")
        { Importance = Standard; }
        modify("Payment Method Code")
        { Importance = Standard; }
        modify(BuyFromContactMobilePhoneNo)
        { Importance = Standard; }
        modify(BuyFromContactPhoneNo)
        { Importance = Standard; }
        modify(BuyFromContactEmail)
        { Importance = Standard; }
        modify("Payment Reference")
        { Importance = Standard; }
    }
    actions
    {
        addlast(Category_Process)
        {
            actionref(RecurringLines; GetRecurringPurchaseLines)
            { }
            actionref(VendorCard; Vendor)
            { }
            actionref(Statistics2; Statistics)
            { }
        }
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    rec."Posting Date" := Today;
                    Rec.Modify();
                end;
            end;
        }
        modify(PostAndPrint)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    rec."Posting Date" := Today;
                    Rec.Modify();
                end;
            end;
        }
        modify(PostAndNew)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    rec."Posting Date" := Today;
                    Rec.Modify();
                end;
            end;
        }
    }

    var
        RecVendor: Record Vendor;
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
        Rec."Your Reference" := UpperCase(Rec."Your Reference");
    end;

    trigger OnOpenPage()
    begin
        RecVendor.SetRange("No.", Rec."Buy-from Vendor No.");
        if RecVendor.FindSet() then begin
            VendorNotes := RecVendor."Vendor Notes";
            PaymentMethod := RecVendor."Preferred Payment Method";
            //Rec.Modify()
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        RecVendor.SetRange("No.", Rec."Buy-from Vendor No.");
        if RecVendor.FindSet() then begin
            VendorNotes := RecVendor."Vendor Notes";
            PaymentMethod := RecVendor."Preferred Payment Method";
            //Rec.Modify()
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        RecVendor.SetRange("No.", Rec."Buy-from Vendor No.");
        if RecVendor.FindSet() then begin
            VendorNotes := RecVendor."Vendor Notes";
            PaymentMethod := RecVendor."Preferred Payment Method";
            //Rec.Modify()
        end;
    end;
}
