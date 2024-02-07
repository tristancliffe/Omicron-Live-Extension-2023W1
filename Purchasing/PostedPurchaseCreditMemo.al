pageextension 50214 PostedPurchCreditMemoExt extends "Posted Purchase Credit Memo"
{
    layout
    {
        movebefore("Buy-from Contact"; "Buy-from Contact No.")
        addafter("Buy-from Vendor Name")
        {
            field("Your Reference"; Rec."Your Reference")
            { ApplicationArea = All; QuickEntry = true; Editable = false; }
        }
        moveafter("Your Reference"; "Vendor Cr. Memo No.")
        modify("Vendor Cr. Memo No.")
        { Visible = true; Importance = Standard; }
        modify("Document Date")
        { Visible = true; Importance = Standard; }
        modify("Posting Date")
        { Visible = true; Importance = Standard; }
        modify("VAT Reporting Date")
        { Visible = true; Importance = Standard; }
        modify("Purchaser Code")
        { Visible = false; }
        modify(BuyFromContactMobilePhoneNo)
        { Importance = Standard; }
        modify(BuyFromContactPhoneNo)
        { Importance = Standard; }
        modify(BuyFromContactEmail)
        { Importance = Standard; }
        modify("Currency Code")
        { Importance = Standard; }
        addafter("Your Reference")
        {
            field("Order Notes"; Rec."Order Vendor Notes") //* changed to order vendor notes due to mistake in table field numbering
            { ApplicationArea = All; }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Amount Including VAT");
    end;
}

