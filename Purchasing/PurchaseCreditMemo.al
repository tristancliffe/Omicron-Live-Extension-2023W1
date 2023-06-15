pageextension 50110 PurchaseCreditExt extends "Purchase Credit Memo"
{
    layout
    {
        modify("Document Date")
        {
            Visible = true;
            Importance = Standard;
        }
        modify("VAT Reporting Date")
        {
            Visible = true;
            Importance = Standard;
        }
        modify("Buy-from Vendor No.")
        { Importance = Standard; }
        modify("Payment Method Code")
        { Importance = Standard; }
    }
}