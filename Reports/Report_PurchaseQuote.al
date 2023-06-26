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
            Caption = 'Standard Purchase Quote';
            Summary = 'Omicron Standard Purchase Quote';
        }
    }
}
