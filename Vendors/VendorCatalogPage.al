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
        LineItem: Record Item;
    begin
        if LineItem.Get(Rec."Item No.") then begin
            Rec.ItemDescription := LineItem.Description;
            LineItem.CalcFields(Inventory);
            QtyInStock := LineItem.Inventory;
            LowStockThreshold := LineItem."Reorder Point";
            if LineItem."Replenishment System" = LineItem."Replenishment System"::Purchase then begin
                if LineItem."Reordering Policy" = LineItem."Reordering Policy"::"Fixed Reorder Qty." then
                    OrderQty := LineItem."Reorder Quantity"
                else
                    if LineItem."Reordering Policy" = LineItem."Reordering Policy"::"Maximum Qty." then
                        OrderQty := LineItem."Reorder Quantity"
                    else
                        OrderQty := 0;
                ReorderStatus := 'StandardAccent';
                SetReorderStatus();
            end;
        end;
    end;

    procedure SetReorderStatus()
    begin
        if QtyInStock <= LowStockThreshold then
            ReorderStatus := 'Unfavorable'
        else
            if (QtyInStock >= ((OrderQty + LowStockThreshold) / 2)) then
                ReorderStatus := 'StandardAccent'
            else
                ReorderStatus := 'Attention';
    end;
}