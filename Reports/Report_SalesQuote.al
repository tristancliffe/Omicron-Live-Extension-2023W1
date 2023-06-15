reportextension 50109 OmicronSalesQuoteExt extends "Standard Sales - Quote"
{
    dataset
    {
        add(Line)
        {
            column(ShelfNo_SalesLine; Line.ShelfNo_SalesLine)
            { }
            column(Instock_SalesLine; Line.Instock_SalesLine)
            { }
        }
    }

    rendering
    {
        layout("./OmicronSalesQuote.docx")
        {
            Type = Word;
            LayoutFile = './OmicronSalesQuote.docx';
            Caption = 'Omicron Sales Estimate';
            Summary = 'Sales Estimate';
        }
    }
}