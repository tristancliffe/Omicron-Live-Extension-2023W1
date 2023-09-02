pageextension 50209 TimesheetLineDetailExt extends "Time Sheet Line Job Detail"
{
    layout
    {
        addafter(Description)
        {
            field("Work Done"; Rec."Work Done")
            { ApplicationArea = All; Caption = 'Work Done'; Editable = false; MultiLine = true; }
        }
    }
}