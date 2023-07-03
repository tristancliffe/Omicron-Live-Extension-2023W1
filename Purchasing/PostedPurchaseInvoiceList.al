pageextension 50179 PostedPurchInvoiceListExt extends "Posted Purchase Invoices"
{
    layout
    {
        movebefore("Buy-from Vendor No."; "Posting Date", "Document Date", Cancelled)
        modify("Posting Date")
        {
            ApplicationArea = All;
            Visible = true;
            Caption = 'Posted Date';
            ToolTip = 'The date that the invoice was posted.';
        }
        moveafter(Amount; "Amount Including VAT")
        modify("Amount Including VAT")
        {
            Caption = 'Amount incl. VAT';
            Visible = true;
        }
        modify("Document Date")
        { Visible = true; }
        modify(Cancelled)
        { Visible = true; }
        movebefore(Amount; "Vendor Invoice No.")
        modify("Currency Code")
        { Visible = false; }
    }
}