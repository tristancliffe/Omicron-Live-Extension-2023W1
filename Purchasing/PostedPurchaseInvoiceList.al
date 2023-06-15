pageextension 50179 PostedPurchInvoiceListExt extends "Posted Purchase Invoices"
{
    layout
    {
        movebefore("Buy-from Vendor No."; "Posting Date")
        modify("Posting Date")
        {
            ApplicationArea = All;
            Caption = 'Posted Date';
            ToolTip = 'The date that the invoice was posted.';
        }
        moveafter("Amount Including VAT"; "Vendor Invoice No.")
    }
}