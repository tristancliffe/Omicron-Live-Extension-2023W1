// Create a new page to show items with low profit
page 50121 "Low Profit Items"
{
    PageType = List;
    SourceTableTemporary = true;
    AdditionalSearchTerms = 'Low Profit, Low Margin, Low Profitability, Profitability, Stock Profit';
    SourceTable = Item;
    ApplicationArea = All;
    Caption = 'Low Profit Stock Items';
    UsageCategory = Lists;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    CardPageId = "Item Card";

    layout
    {
        area(content)
        {
            repeater(Repeater1)
            {
                field("No."; Rec."No.") { }
                field(Description; Rec.Description) { }
                field("Unit Cost"; Rec."Unit Cost") { }
                field("Unit Price"; Rec."Unit Price") { }
                field("Profit £"; Rec."Unit Price" - Rec."Unit Cost") { }
                // field("Profit %"; CalcProfitPercent()) { }
                field("Profit %"; Rec."Profit %") { DecimalPlaces = 2 : 2; }
                field(InventoryField; Rec.Inventory)
                {
                    ApplicationArea = Invoicing, Basic, Suite;
                    HideValue = IsNonInventoriable;
                    DrillDown = false;
                    ToolTip = 'Specifies how many units, such as pieces, boxes, or cans, of the item are in inventory.';
                }
                field("Assembly BOM"; Rec."Assembly BOM")
                {
                    //AccessByPermission = TableData "BOM Component" = R;
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies if the item is an assembly BOM.';
                    DrillDown = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Refresh)
            {
                Caption = 'Refresh';
                trigger OnAction()
                begin
                    LoadLowProfitItems();
                end;
            }
        }
    }

    views
    {
        view(NonZeroPrice)
        {
            Caption = 'Non-Zero Price Items';
            Filters = where("Unit Price" = filter(' <> 0'));
        }
    }

    var
        IsNonInventoriable: Boolean;

    trigger OnOpenPage()
    begin
        LoadLowProfitItems();
        Rec.FindFirst();
    end;

    trigger OnAfterGetRecord()
    begin
        IsNonInventoriable := Rec.IsNonInventoriableType();
    end;

    local procedure LoadLowProfitItems()
    var
        Item: Record Item;
        UnitCost: Decimal;
        UnitPrice: Decimal;
        UnitProfit: Decimal;
        ProfitPercent: Decimal;
    begin
        Clear(Rec);
        Rec.DeleteAll();
        Item.Reset();
        if Item.FindSet() then
            repeat
                UnitCost := Item."Unit Cost";
                UnitPrice := Item."Unit Price";
                ProfitPercent := Item."Profit %";
                if UnitCost <> 0 then begin
                    UnitProfit := UnitPrice - UnitCost;
                    // ProfitPercent := 0;
                    // if UnitCost <> 0 then
                    //     ProfitPercent := UnitProfit / UnitCost;
                    // if (UnitProfit < 10) or ((UnitProfit < 10) and (ProfitPercent < 0.15)) then begin
                    if ((UnitProfit < 10) and (ProfitPercent < 15)) or (ProfitPercent < 15) then begin
                        Rec := Item;
                        Rec.Insert();
                    end;
                end;
            until Item.Next() = 0;
    end;

    // local procedure CalcProfitPercent(): Decimal
    // begin
    //     if Rec."Unit Cost" <> 0 then
    //         exit((Rec."Unit Price" - Rec."Unit Cost") / Rec."Unit Cost")
    //     else
    //         exit(0);
    // end;
}