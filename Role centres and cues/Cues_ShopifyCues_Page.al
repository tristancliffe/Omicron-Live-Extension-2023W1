pageextension 50242 ShopifyCuesExt extends "Shpfy Activities"
{
    layout
    {
        moveafter(UnprocessedOrderUpdates; UnmappedProducts)
        addlast(ShopInfo)
        {
            // field(ItemsOnShopify; Activities.ItemsOnShopify)
            // {
            //     ApplicationArea = All;
            //     DrillDownPageId = ShopifyAllVariants;
            //     Caption = 'Shopify Items';
            //     Visible = false;
            // }
            field(ItemsOnShopify; NoOfItemsOnShopify)
            {
                ApplicationArea = All;
                DrillDownPageId = ShopifyAllVariants;
                DecimalPlaces = 0 : 0;
                Caption = 'Shopify Items';
                Visible = true;
                trigger OnDrillDown()
                var
                    ShopifyVarients: Record "Shpfy Variant";
                begin
                    ShopifyVarients.Reset();
                    ShopifyVarients.SetFilter("Mapped By Item", 'true');
                    Page.Run(Page::ShopifyAllVariants, ShopifyVarients);
                end;
            }
        }
    }
    var
        Activities: Record "Activities Cue";
        NoOfItemsOnShopify: Decimal;

    trigger OnOpenPage()
    begin
        Activities.CalcFields(ItemsOnShopify);
        NoOfItemsOnShopify := Activities.ItemsOnShopify;
    end;
}