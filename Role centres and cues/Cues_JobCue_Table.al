tableextension 50112 ProjectManagerExt extends "Job Cue"
{
    fields
    {
        field(50100; OngoingJobs; Integer)
        {
            CalcFormula = count(Job where(Status = filter(Open)));
            Caption = 'Ongoing Jobs';
            FieldClass = FlowField;
        }
        field(50101; OpenTimeSheetsCue; Integer)
        {
            CalcFormula = count("Time Sheet Header");
            Caption = 'Active Time Sheets';
            FieldClass = FlowField;
        }
        field(50102; ActiveTimeSheetsCue; Integer)
        {
            CalcFormula = count("Time Sheet Header" where("Quantity Open" = filter('>1')));
            Caption = 'Active Time Sheets';
            FieldClass = FlowField;
        }
    }
}