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
            DecimalPlaces = 1 : 2;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50104; QtyOnSalesOrder_PurchLine; Decimal)
        {
            Caption = 'Qty. on Sales Orders';
            DecimalPlaces = 1 : 2;
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
}

