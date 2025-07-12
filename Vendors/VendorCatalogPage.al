pageextension 50146 ItemVendorListExt extends "Vendor Item Catalog"
{
    layout
    {
        modify("Vendor No.")
        { Visible = true; }
        addafter("Item No.")
        {
            field(ItemDescription; Rec.ItemDescription)
            {
                Description = 'Item description';
                Caption = 'Item description';
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter("Lead Time Calculation")
        {
            field(QtyInStock; QtyInStock)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Qty in Stock';
                StyleExpr = ReorderStatus;
                Width = 6;
                DecimalPlaces = 0 : 2;

                trigger OnDrillDown()
                var
                    ItemLedgerEntryRec: Record "Item Ledger Entry";
                    ItemLedgerEntryPageID: Integer;
                begin
                    ItemLedgerEntryPageID := Page::"Item Ledger Entries";
                    ItemLedgerEntryRec.SetRange("Item No.", Rec."Item No.");
                    PAGE.Run(ItemLedgerEntryPageID, ItemLedgerEntryRec);
                end;
            }
            field(LowStockThreshold; LowStockThreshold)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Low Stock';
                Tooltip = 'The quantity of stock that triggers repurchasing.';
                Style = StandardAccent;
                BlankZero = true;
                Width = 5;
            }
            field(OrderQty; OrderQty)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Order Qty';
                Tooltip = 'The quantity of stock to order once the low stock threshold is reached.';
                Style = StandardAccent;
                BlankZero = true;
                Width = 5;
            }
        }
    }
    actions
    {
        addlast(navigation)
        {
            group(Item)
            {
                Caption = 'Item';
                Enabled = true;
                Image = Item;
                Description = 'Item related links';
                action(ItemCardLink)
                {
                    ApplicationArea = All;
                    Image = Item;
                    Caption = 'Item Card';
                    RunObject = page "Item Card";
                    RunPageLink = "No." = field("Item No.");
                    Description = 'Go to the Item Card';
                    ToolTip = 'Opens the item card for this line';
                    Visible = true;
                    Enabled = true;
                    Scope = Repeater;
                }
            }
        }
        addlast(Promoted)
        {
            actionref(ItemCard_Promoted; ItemCardLink)
            { Visible = true; }
        }
    }
    views
    { }

    var
        QtyInStock: Decimal;
        LowStockThreshold: Decimal;
        ReorderStatus: Text;

    // trigger OnOpenPage()
    // var
    //     Items: Record Item;
    // begin
    //     Items.CalcFields(Inventory);
    //     QtyInStock := Item.Inventory;
    // end;
    trigger OnAfterGetRecord()
    var
        Item: Record Item;
    begin
        if Item.Get(Rec."Item No.") then begin
            Rec.ItemDescription := Item.Description;
            Item.CalcFields(Inventory, "Reserved Qty. on Inventory");
            QtyInStock := Item.Inventory - Item."Reserved Qty. on Inventory";
            LowStockThreshold := Item."Reorder Point";
        end;
    end;

    local procedure OrderQty(): Decimal
    var
        Item: Record Item;
    begin
        if Item.Get(Rec."Item No.") then begin
            if Item."Replenishment System" = Item."Replenishment System"::Purchase then begin
                if Item."Reordering Policy" = Item."Reordering Policy"::"Fixed Reorder Qty." then
                    exit(Item."Reorder Quantity")
                else
                    if Item."Reordering Policy" = Item."Reordering Policy"::"Maximum Qty." then
                        exit(Item."Maximum Inventory")
                    else
                        exit(0);
            end;
            ReorderStatus := SetReorderStatus();

        end;
    end;

    procedure SetReorderStatus(): Text
    begin
        if QtyInStock <= LowStockThreshold then
            exit('Unfavorable')
        else
            if (QtyInStock >= ((OrderQty + LowStockThreshold) / 2)) then
                exit('StandardAccent')
            else
                exit('Attention');
        exit('');
    end;
}