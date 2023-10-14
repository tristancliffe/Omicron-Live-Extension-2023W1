reportextension 50107 OmicronSalesCreditMemo extends "Standard Sales - Credit Memo"
{
    dataset
    {
    }

    rendering
    {
        layout("./OmicronSalesCreditMemo.docx")
        {
            Type = Word;
            LayoutFile = './OmicronSalesCreditMemo.docx';
            Caption = 'Omicron Sales Credit Memo';
            Summary = 'Omicron Sales Credit Memo';
        }
    }
}
