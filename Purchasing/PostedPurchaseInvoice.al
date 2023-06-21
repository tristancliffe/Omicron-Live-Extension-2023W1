pageextension 50170 PostedPurchInvoiceExt extends "Posted Purchase Invoice"
{
    layout
    {
        movebefore("Buy-from Contact"; "Buy-from Contact No.")
        addafter("Buy-from Vendor Name")
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = All;
                QuickEntry = true;
            }
        }
        moveafter("Your Reference"; "Vendor Invoice No.")
        modify("Vendor Invoice No.")
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
        modify("Payment Method Code")
        { Importance = Standard; }
        modify(BuyFromContactMobilePhoneNo)
        { Importance = Standard; }
        modify(BuyFromContactPhoneNo)
        { Importance = Standard; }
        modify(BuyFromContactEmail)
        { Importance = Standard; }
        addafter("Your Reference")
        {
            field("Order Notes"; Rec."Order Notes")
            { ApplicationArea = All; }
        }
    }
}

