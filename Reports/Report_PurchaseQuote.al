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
        }
    }
}
