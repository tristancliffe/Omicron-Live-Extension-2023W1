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
                ToolTip = 'Item description from the item card record';
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
            {
                Visible = true;
            }
        }
    }
    views
    {
        // addfirst
        // {
        //     view(ItemsFromVendor)
        //     {
        //         Caption = 'Items from Vendor';
        //         OrderBy = ascending("Vendor No.", "Item No.");
        //         Filters = where("Vendor No." = field("No."))
        //     }
        // }
    }

    var
        QtyInStock: Decimal;
        LowStockThreshold: Decimal;
        OrderQty: Decimal;
        ReorderStatus: Text;

    // trigger OnOpenPage()
    // var
    //     Items: Record Item;
    // begin
    //     Items.CalcFields(Inventory);
    //     QtyInStock := Items.Inventory;
    // end;

    trigger OnAfterGetRecord()
    var
        Item: Record Item;
    begin
        OrderQty := 0;
        if Item.Get(Rec."Item No.") then begin
            Rec.ItemDescription := Item.Description;
            Item.CalcFields(Inventory);
            QtyInStock := Item.Inventory;
            LowStockThreshold := Item."Reorder Point";
            if Item."Replenishment System" = Item."Replenishment System"::Purchase then begin
                if Item."Reordering Policy" = Item."Reordering Policy"::"Fixed Reorder Qty." then
                    OrderQty := Item."Reorder Quantity"
                else
                    if Item."Reordering Policy" = Item."Reordering Policy"::"Maximum Qty." then
                        OrderQty := Item."Reorder Quantity"
                    else
                        OrderQty := 0;
            end;
            SetReorderStatus();

        end;
    end;

    procedure SetReorderStatus()
    begin
        ReorderStatus := 'StandardAccent';
        if QtyInStock <= LowStockThreshold then
            ReorderStatus := 'Unfavorable'
        else
            if (QtyInStock >= ((OrderQty + LowStockThreshold) / 2)) then
                ReorderStatus := 'StandardAccent'
            else
                ReorderStatus := 'Attention';
    end;
}