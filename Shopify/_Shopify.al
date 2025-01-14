codeunit 50102 "Shpfy Order External Doc. No"
{
    // Adds Shopify order number to the Sales Order when created.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Shpfy Order Events", 'OnAfterCreateSalesHeader', '', false, false)]
    procedure OnAfterCreateSalesHeader(OrderHeader: Record "Shpfy Order Header"; var SalesHeader: Record "Sales Header")
    var
        MyInStream: InStream;
        Enum: enum "Shpfy Financial Status";
        OrdinalValue: Integer;
        Index: Integer;
        Status: Text;
    begin
        SalesHeader."Your Reference" := CopyStr('£' + format(OrderHeader."Total Amount") + ' SHOPIFY ' + OrderHeader."Shopify Order No." + ', ' + format(OrderHeader."Financial Status", 0, 1), 1, MaxStrLen(SalesHeader."Your Reference"));
        SalesHeader."Shortcut Dimension 1 Code" := 'ONLINE';
        OrderHeader.CalcFields("Work Description");
        If OrderHeader."Work Description".HasValue() then begin
            OrderHeader."Work Description".CreateInStream(MyInStream);
            MyInStream.Read(SalesHeader."Order Notes")
        end;
        // SalesHeader."Order Notes" := CopyStr(OrderHeader."Work Description", 1, MaxStrLen(SalesHeader."Order Notes"));
        SalesHeader.Modify();
    end;
}

enumextension 50101 "Extended Stock Calculations" extends "Shpfy Stock Calculation"
{
    // Adds the option "Inventory on hand" to the Shopify stock calulation system rather than future availability
    value(50101; "Omicron Non-Reserved Inventory")
    {
        Caption = 'Omicron - Available Inventory (not reserved)';
        Implementation = "Shpfy Stock Calculation" = "Shpfy Stock Calc. Inventory",
                         "Shpfy IStock Available" = "Shpfy Can Have Stock";
    }
    value(50102; "Omicron Non-Reserved and Assemblies")
    {
        Caption = 'Omicron - Unreserved Inventory and Assemblies';
        Implementation = "Shpfy Stock Calculation" = "Shpfy Stock Calc. Invtry & BOM",
                         "Shpfy IStock Available" = "Shpfy Can Have Stock";
    }
}
codeunit 50103 "Shpfy Stock Calc. Inventory" implements "Shpfy Stock Calculation"
{
    // Calulates the current 'on-hand' stock level of items in conjunction with the enumextension 50101 above
    procedure GetStock(var Item: Record Item): decimal;
    begin
        Item.Calcfields(Inventory, "Reserved Qty. on Inventory");
        exit(Item.Inventory - Item."Reserved Qty. on Inventory");
    end;
}

codeunit 50105 "Shpfy Stock Calc. Invtry & BOM" implements "Shpfy Stock Calculation"
{
    // Calulates the current 'on-hand' stock level of items in conjunction with the enumextension 50101 above
    procedure GetStock(var Item: Record Item): decimal;
    var
        AvailableBOMQty: Decimal;
        CalcBOMTree: Codeunit "Calculate BOM Tree";
        BOMBuffer: Record "BOM Buffer" temporary;
        AvailableQuantity: Decimal;
    begin
        Item.Calcfields(Inventory, "Reserved Qty. on Inventory");
        if Item."Replenishment System" = Item."Replenishment System"::Assembly then begin
            AvailableQuantity := 99999;
            Item.SetRange("No.", Item."No.");
            CalcBOMTree.GenerateTreeForItems(Item, BOMBuffer, 1);
            if BOMBuffer.FindSet() then
                repeat
                    if BOMBuffer."Able to Make Parent" < AvailableQuantity then
                        AvailableQuantity := BOMBuffer."Able to Make Parent";
                until BOMBuffer.Next() = 0;
            if AvailableQuantity = 99999 then
                AvailableBOMQty := 0
            else
                AvailableBOMQty := AvailableQuantity;
        end
        else
            AvailableBOMQty := 0;
        exit(Item.Inventory + AvailableBOMQty - Item."Reserved Qty. on Inventory");
    end;
}
codeunit 50104 "Shpfy Order Line Dim"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Shpfy Order Events", 'OnAfterCreateItemSalesLine', '', false, false)]

    procedure OnAfterCreateItemSalesLine(ShopifyOrderHeader: Record "Shpfy Order Header"; ShopifyOrderLine: Record "Shpfy Order Line"; SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
        SalesLine.Validate("Shortcut Dimension 1 Code", 'ONLINE');
        SalesLine.Modify();
    end;
}

codeunit 50106 "Shpfy Product Export Omicron"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Shpfy Product Events", OnAfterFillInShopifyProductFields, '', false, false)]
    procedure OnAfterFillInShopifyProductFields(Item: Record Item; var ShopifyProduct: Record "Shpfy Product")
    begin
        ShopifyProduct.Vendor := 'Omicron Engineering Ltd';
        if not ShopifyProduct.IsTemporary() then
            ShopifyProduct.Modify();
    end;
}