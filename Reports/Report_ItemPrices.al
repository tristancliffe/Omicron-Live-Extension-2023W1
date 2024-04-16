report 50110 "Item Prices"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = ItemPrices;
    Caption = 'Historic and Current Item Prices';
    ExcelLayoutMultipleDataSheets = true;


    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.") where(Blocked = filter(false));
            column(ItemNo; "No.")
            { }
            column(Description; Description)
            { }
            column(PRICE_NOW; "Unit Price")
            { }
            column(COST_NOW; "Unit Cost")
            { }
            trigger OnAfterGetRecord()
            begin
                if ("Unit Price" = 0) or ("Unit Cost" = 0) then
                    CurrReport.Skip();
            end;
        }
        dataitem(StockMovements; StockMovements)
        {
            DataItemTableView = sorting(SM_STOCK_CODE) where(SM_TYPE2 = filter('SALE'), SM_STATUS2 = filter('OUT'));
            column(STOCK_CODE; SM_STOCK_CODE)
            { }
            column(TYPE; SM_TYPE2)
            { }
            column(DETAIL; SM_DETAIL)
            { }
            column(NOTES; SM_DESCRIPTION)
            { }
            column(LINEPRICE; SM_VALUE)
            { }
            column(QTY; SM_QUANTITY)
            { }
            column(PRICE_THEN; SM_UNIT_PRICE)
            { }
            column(COST_THEN; SM_COSTPRICE)
            { }
            column(DATE; SM_DATE)
            { }
            trigger OnAfterGetRecord()
            begin
                if (SM_COSTPRICE = 0) or (SM_VALUE = 0) or (SM_QUANTITY = 0) then
                    CurrReport.Skip();
                SM_UNIT_PRICE := Abs(SM_VALUE / SM_QUANTITY);
            end;
        }
    }
    rendering
    {
        layout(ItemPrices)
        {
            Type = Excel;
            LayoutFile = 'OmicronItemPrices.xlsx';
            Caption = 'Omicron Item Prices';
            Summary = 'Excel Export of current and historic item costs and prices';
        }
    }
    var
        SM_UNIT_PRICE: Decimal;
}