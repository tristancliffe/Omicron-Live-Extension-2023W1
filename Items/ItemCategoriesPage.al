pageextension 50248 "Item Categories Extension" extends "Item Categories"
{
    layout
    {
        addafter(Description)
        {
            field(CategoryCount; Rec."Category Count")
            {
                ApplicationArea = All;
                Caption = 'Category Count';
                Editable = false;
                BlankZero = true;
            }
        }
    }
}

