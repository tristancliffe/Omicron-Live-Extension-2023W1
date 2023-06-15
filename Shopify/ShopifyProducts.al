pageextension 50177 ShopifyProductsExt extends "Shpfy Products"
{
    layout
    { }
    actions
    {
        addlast(Processing)
        {
            group(Variants)
            {
                Caption = 'Variants';
                action(AllVariants)
                {
                    ApplicationArea = All;
                    Visible = true;
                    Caption = 'All Variants List';
                    Image = ItemVariant;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    //PromotedOnly = true;
                    ToolTip = 'Shows a list of all variants.';
                    RunObject = Page ShopifyAllVariants;
                }
            }
        }
    }
}