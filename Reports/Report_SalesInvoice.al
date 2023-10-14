reportextension 50103 OmicronSalesInvoiceExt extends "Standard Sales - Invoice"
{
    dataset
    {
        add(Line)
        {
            column(WorkDone_Line; "Work Done")
            { }
        }
    }

    rendering
    {
        layout("./OmicronSalesInvoice.docx")
        {
            Type = Word;
            LayoutFile = './OmicronSalesInvoice.docx';
            Caption = 'Omicron Sales Invoice';
            Summary = 'Omicron Standard Sales Invoice';
        }
        layout("./OmicronJobSalesInvoice.docx")
        {
            Type = Word;
            LayoutFile = './OmicronJobSalesInvoice.docx';
            Caption = 'Omicron Job Sales Invoice';
            Summary = 'Omicron Job Sales Invoice';
        }
    }
}
