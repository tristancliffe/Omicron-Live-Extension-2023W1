pageextension 50178 PostedSalesInvoiceListExt extends "Posted Sales Invoices"
{
    layout
    {
        movebefore("Sell-to Customer No."; "Document Date", "Posting Date")
        modify("Posting Date")
        {
            ApplicationArea = All;
            Visible = true;
            Caption = 'Posted Date';
            ToolTip = 'The date that the invoice was posted.';
        }
        modify("Currency Code")
        { Visible = false; }
        addafter("Sell-to Customer Name")
        {
            field("Your Reference"; Rec."Your Reference")
            { ApplicationArea = All; }
        }
        modify("Location Code")
        { Visible = false; }
    }
}