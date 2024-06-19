pageextension 50226 ResourceAbsenceListExt extends "Absence Registration"
{
    layout
    {
        addafter(Description)
        {
            field("Work Done"; Rec."Work Done") { ApplicationArea = All; Caption = 'Details'; }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("From Date");
        Rec.Ascending(false);
        Rec.FindFirst
    end;
}