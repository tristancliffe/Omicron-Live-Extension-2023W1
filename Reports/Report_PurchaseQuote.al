reportextension 50108 OmicronPurchaseQuote extends "Purchase - Quote"
{
    dataset
    {
    }

    rendering
    {
        layout("./OmicronPurchaseQuote.rdlc")
        {
            Type = RDLC;
            LayoutFile = './OmicronPurchaseQuote.rdlc';
            Caption = 'Omicron Purchase Quote';
            Summary = 'Omicron Standard Purchase Quote';
        }
    }
}
