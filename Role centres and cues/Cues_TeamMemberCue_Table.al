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
        field(50102; LastMonth; Date)
        {
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(50103; HoursWorked; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Hours Worked';
            CalcFormula = sum("Res. Ledger Entry".Quantity where("Resource No." = field("User ID Filter"),
                                                                 "Posting Date" = field(LastMonth)));
        }
    }
}