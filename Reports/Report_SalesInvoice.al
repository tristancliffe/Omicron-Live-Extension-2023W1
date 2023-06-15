reportextension 50103 OmicronSalesInvoiceExt extends "Standard Sales - Invoice"
{
    dataset
    {
        add(Line)
        {
            column(WorkDone_Line; "Work Done")
            {
            }
        }
    }

    rendering
    {
        layout("./OmicronSalesInvoice.docx")
        {
            Type = Word;
            LayoutFile = './OmicronSalesInvoice.docx';
        }
    }
}
