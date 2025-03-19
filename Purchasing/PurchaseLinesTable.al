tableextension 50116 PurchaseLineTableExt extends "Purchase Line"
{
    fields
    {
        field(50100; ItemNotes_PurchLine; Text[1000])
        {
            Caption = 'Item Notes';
            FieldClass = FlowField;
            Editable = False;
            CalcFormula = lookup(Item."Item Notes" where("No." = field("No.")));
        }
        field(50101; ItemType_PurchLine; Enum "Item Type")
        {
            Caption = 'Item Type';
            FieldClass = FlowField;
            Editable = False;
            CalcFormula = lookup(Item.Type where("No." = field("No.")));
        }
        field(50102; Image_PurchLine; MediaSet)
        {
            Caption = 'Item Image';
            FieldClass = FlowField;
            Editable = False;
            CalcFormula = lookup(Item.Picture where("No." = field("No.")));
        }
        field(50103; Instock_PurchLine; Decimal)
        {
            Caption = 'Stock level';
            DecimalPlaces = 0 : 2;
            Editable = false;
            DataClassification = CustomerContent;
            ToolTip = 'This column shows the quantity currently known to be in stock. Non-inventory and Service items show as 999';
        }
        field(50104; QtyOnSalesOrder_PurchLine; Decimal)
        {
            Caption = 'Qty. on Sales Orders';
            DecimalPlaces = 0 : 2;
            Editable = false;
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Replaced with Flowfield';
        }
        field(50105; ShelfNo_PurchLine; Code[10])
        {
            Caption = 'Shelf No.';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Item."Shelf No." where("No." = field("No.")));
        }
        field(50106; CalcQtyOnSalesOrder_PurchLine; Decimal)
        {
            Caption = 'Qty. on Sales Orders';
            DecimalPlaces = 0 : 2;
            Editable = false;
            // DataClassification = CustomerContent;
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Qty. to Ship" where("No." = field("No."),
                                                                "Document Type" = filter("Order"),
                                                                "Location Code" = field("Location Code")));
        }
        field(50107; CalcQtyOnSalesQuote_PurchLine; Decimal)
        {
            Caption = 'Qty. on Sales Quotes';
            DecimalPlaces = 0 : 2;
            Editable = false;
            // DataClassification = CustomerContent;
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Qty. to Ship" where("No." = field("No."),
                                                                "Document Type" = filter("Quote"),
                                                                "Location Code" = field("Location Code")));
        }
    }
}

