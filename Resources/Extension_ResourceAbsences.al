pageextension 50226 ResourceAbsenceListExt extends "Absence Registration"
{
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("From Date");
        Rec.Ascending(false);
        Rec.FindFirst
    end;
}