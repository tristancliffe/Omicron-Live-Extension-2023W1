pagecustomization "Teams Item Card" customizes "Item Card"
{
    layout
    {
        modify("Description 2") { Visible = false; }
        modify("Last Date Modified") { Visible = false; }
        modify(GTIN) { Visible = false; }
        modify("Item Category Code") { Visible = false; }
        modify("Automatic Ext. Texts") { Visible = false; }
        modify("Common Item No.") { Visible = false; }
        modify("Purchasing Code") { Visible = false; }
        modify(VariantMandatoryDefaultNo) { Visible = false; }
        modify(StockoutWarningDefaultNo) { Visible = false; }
        modify(PreventNegInventoryDefaultNo) { Visible = false; }
        modify(PreventNegInventoryDefaultYes) { Visible = false; }
        modify("Costs & Posting") { Visible = false; }
        modify("Prices & Sales") { Visible = false; }
        modify(Replenishment) { Visible = false; }
        modify(Planning) { Visible = false; }
        modify(ItemTracking) { Visible = false; }
        modify(Warehouse) { Visible = false; }
    }
}