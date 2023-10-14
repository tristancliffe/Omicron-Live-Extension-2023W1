reportextension 50105 OmicronDraftSalesInvoice extends "Standard Sales - Draft Invoice"
{
    dataset
    {
        add(Line)
        {
            column(Work_Done_Line; Line."Work Done")
            {
            }
        }
    }

    rendering
    {
        layout("./OmicronSalesDraftInvoice.docx")
        {
            Type = Word;
            LayoutFile = './OmicronSalesDraftInvoice.docx';
            Caption = 'Omicron Draft Sales Invoice';
            Summary = 'Omicron Draft Sales Invoice';
        }
    }
}
