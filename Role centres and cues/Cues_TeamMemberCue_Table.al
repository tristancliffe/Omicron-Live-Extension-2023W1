tableextension 50115 TeamMemberCueExt extends "Team Member Cue"
{
    fields
    {
        field(50100; AllTimeSheets; Integer)
        {
            FieldClass = FlowField;
            Caption = 'All Time Sheets';
            CalcFormula = Count("Time Sheet Header" where("Owner User ID" = field("User ID Filter")));
        }
        field(50101; ArchivedTimeSheets; Integer)
        {
            FieldClass = FlowField;
            Caption = 'Archived Time Sheets';
            CalcFormula = count("Time Sheet Header Archive" where("Owner User ID" = field("User ID Filter")));
        }
    }
}