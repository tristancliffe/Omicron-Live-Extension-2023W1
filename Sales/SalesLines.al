tableextension 50140 SalesLineExt extends "Sales Line"
{
    fields
    {
        field(50100; ShelfNo_SalesLine; Code[10])
        {
            Caption = 'Shelf No.';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Item."Shelf No." where("No." = field("No.")));
        }
        field(50101; CommodityCode_SalesLine; Code[20])
        {
            Caption = 'Commodity Code';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Item."Tariff No." where("No." = field("No.")));
        }
        field(50102; "Work Done"; Text[700])
        { CaptionML = ENG = 'Work Done', ENU = 'Work Done'; }
        field(50103; Instock_SalesLine; Decimal)
        {
            Caption = 'Stock level';
            DecimalPlaces = 0 : 2;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50104; ItemNotes_SalesLine; Text[1000])
        {
            Caption = 'Item Notes';
            FieldClass = FlowField;
            Editable = False;
            CalcFormula = lookup(Item."Item Notes" where("No." = field("No.")));
        }
        field(50105; ItemType_SalesLine; Enum "Item Type")
        {
            Caption = 'Item Type';
            FieldClass = FlowField;
            Editable = False;
            CalcFormula = lookup(Item.Type where("No." = field("No.")));
        }
        field(50106; Image_SalesLine; MediaSet)
        {
            Caption = 'Item Image';
            FieldClass = FlowField;
            Editable = False;
            CalcFormula = lookup(Item.Picture where("No." = field("No.")));
        }
        field(50107; ItemVendor_SalesLine; Code[20])
        {
            Caption = 'Supplier';
            FieldClass = FlowField;
            Editable = False;
            CalcFormula = lookup(Item."Vendor No." where("No." = field("No.")));
        }
        field(50108; ItemVendorNo_SalesLine; Text[50])
        {
            Caption = 'Supplier No.';
            FieldClass = FlowField;
            Editable = False;
            CalcFormula = lookup(Item."Vendor Item No." where("No." = field("No.")));
        }
        field(50109; ItemQtyOnOrder_SalesLine; Decimal)
        {
            Caption = 'Qty on order';
            DecimalPlaces = 0 : 2;
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
}
tableextension 50141 AssemblyLineExt extends "Assembly Line"
{
    fields
    {
        field(50100; ShelfNo_AssemblyLine; Code[10])
        {
            Caption = 'Shelf No.';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Item."Shelf No." where("No." = field("No.")));
        }
        field(50153; CommodityCode_AssemblyLine; Code[20])
        {
            Caption = 'Commodity Code';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Item."Tariff No." where("No." = field("No.")));
        }
        field(50101; Instock_AssemblyLine; Decimal)
        {
            Caption = 'Stock Level';
            DecimalPlaces = 0 : 2;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50102; ItemNotes_AssemblyLine; Text[1000])
        {
            Caption = 'Item Notes';
            FieldClass = FlowField;
            Editable = False;
            CalcFormula = lookup(Item."Item Notes" where("No." = field("No.")));
        }
        field(50103; ItemType_AssemblyLine; Enum "Item Type")
        {
            Caption = 'Item Type';
            FieldClass = FlowField;
            Editable = False;
            CalcFormula = lookup(Item.Type where("No." = field("No.")));
        }
        field(50104; Image_AssemblyLine; MediaSet)
        {
            Caption = 'Item Image';
            FieldClass = FlowField;
            Editable = False;
            CalcFormula = lookup(Item.Picture where("No." = field("No.")));
        }
    }
}