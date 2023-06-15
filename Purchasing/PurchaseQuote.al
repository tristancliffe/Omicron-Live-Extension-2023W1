pageextension 50134 PurchQuoteExt extends "Purchase Quote"
{
    layout
    {
        moveafter("Buy-from Vendor Name"; Status)
        movebefore("Buy-from Contact"; "Buy-from Contact No.")
        addafter("Buy-from Vendor Name")
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = All;
                QuickEntry = true;
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
        addafter("Buy-from")
        {
            field("Order Vendor Notes"; Rec."Order Vendor Notes")
            {
                MultiLine = true;
                ApplicationArea = All;
                Importance = Standard;
                ToolTip = 'This SHOULD be the vendor notes brought across to the orders';
                QuickEntry = false;
                Editable = true;
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
        modify("Buy-from Vendor No.")
        { Importance = Standard; }
        modify("Assigned User ID")
        { Importance = Standard; }
        modify("Vendor Order No.")
        { Importance = Standard; }
        modify("Payment Method Code")
        { Importance = Promoted; }
        modify(BuyFromContactPhoneNo)
        { Importance = Standard; }
        modify(BuyFromContactMobilePhoneNo)
        { Importance = Standard; }
        modify(BuyFromContactEmail)
        { Importance = Standard; }
        movebefore(Control1904651607; Control5)
    }
    actions
    {
        addlast(Category_Process)
        {
            actionref(VendorCard; Vendor)
            { }
        }
    }
    trigger OnInsertRecord(BelowXRec: Boolean): Boolean
    begin
        Rec."Assigned User ID" := USERID;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec."Your Reference" := UpperCase(Rec."Your Reference");
    end;

    trigger OnOpenPage()
    var
        RecVendor: Record Vendor;

    begin
        RecVendor.SetRange("No.", Rec."Buy-from Vendor No.");
        if RecVendor.FindSet() then begin
            Rec."Order Vendor Notes" := RecVendor."Vendor Notes";
            //Rec.Modify()
        end;
    end;
}
