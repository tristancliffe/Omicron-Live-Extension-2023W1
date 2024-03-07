// The extension adds two fields to the table
// The first field is "Shelf No." with a code of 10
// The field is a flow field and is not editable
// The CalcFormula is set to lookup the "Shelf No." of the item where the item number matches the "Item No." in the line
// The second field is "Available" with a decimal data type
// The Caption for the field is set to "Available"
// The field is not editable and has 1 to 2 decimal places
// The DataClassification for the field is set to "CustomerContent"
tableextension 50108 ItemJournalTableExt extends "Item Journal Line"
{
    fields
    {
        field(50100; ShelfNo_ItemJournalLine; Code[10])
        {
            Caption = 'Shelf No.';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Item."Shelf No." where("No." = field("Item No.")));
        }
        field(50101; Instock_ItemJournalLine; Decimal)
        {
            Caption = 'Available';
            DecimalPlaces = 0 : 2;
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
}