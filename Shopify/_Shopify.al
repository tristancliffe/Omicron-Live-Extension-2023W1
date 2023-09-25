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
        SalesHeader."Your Reference" := 'Shopify ' + OrderHeader."Shopify Order No." + ' £' + format(OrderHeader."Total Amount");
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
    value(50101; "Inventory on hand")
    {
        Caption = 'Inventory on hand';
        Implementation = "Shpfy Stock Calculation" = "Shpfy Stock Calc. Inventory";
    }
}
codeunit 50103 "Shpfy Stock Calc. Inventory" implements "Shpfy Stock Calculation"
{
    // Calulates the current 'on-hand' stock level of items in conjunction with the enumextension 50101 above
    procedure GetStock(var Item: Record Item): decimal;
    begin
        Item.Calcfields(Inventory);
        exit(Item.Inventory);
    end;
}