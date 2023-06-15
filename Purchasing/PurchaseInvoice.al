pageextension 50135 PurchInvoiceExt extends "Purchase Invoice"
{
    layout
    {
        moveafter("Buy-from Vendor Name"; Status)
        moveafter(Status; "Vendor Invoice No.")
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
