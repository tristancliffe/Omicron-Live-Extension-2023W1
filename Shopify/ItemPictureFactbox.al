page 50120 "Shopify Product Image Factbox"
{
    Caption = 'Item Picture';
    PageType = CardPart;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            field("Item Picture"; Rec.Picture)
            {
                ApplicationArea = All;
                ShowCaption = false;
                Caption = 'Picture';
                Visible = true;
            }
        }
    }
}