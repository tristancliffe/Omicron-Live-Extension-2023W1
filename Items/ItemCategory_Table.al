tableextension 50129 "Item Category Extension" extends "Item Category"
{
    fields
    {
        field(50129; "Category Count"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Item where("Item Category Code" = field("Code")));
        }
    }
}