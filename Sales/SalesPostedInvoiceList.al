pageextension 50178 PostedSalesInvoiceListExt extends "Posted Sales Invoices"
{
    layout
    {
        movebefore("Sell-to Customer No."; "Posting Date")
        modify("Posting Date")
        {
            ApplicationArea = All;
            Visible = true;
            Caption = 'Posted Date';
            ToolTip = 'The date that the invoice was posted.';
        }
    }
}