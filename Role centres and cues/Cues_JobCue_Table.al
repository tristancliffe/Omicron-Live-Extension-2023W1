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
    }
}