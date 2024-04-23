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

        field(50103; HoursWorkedLastMonth; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Hours Last Month';
            ToolTip = 'The number of hours submitted, approved and posted to the Resource Ledger SO FAR THIS MONTH.';
            CalcFormula = sum("Res. Ledger Entry".Quantity where("Resource No." = field("User ID Filter"),
                                                                 "Posting Date" = field(LastMonth),
                                                                 "Entry Type" = filter(Usage)));
            DecimalPlaces = 0 : 2;
        }
        field(50104; ThisMonth; Date)
        {
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(50105; HoursWorkedThisMonth; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Hours This Month';
            ToolTip = 'The number of hours submitted, approved and posted to the Resource Ledger LAST MONTH.';
            CalcFormula = sum("Res. Ledger Entry".Quantity where("Resource No." = field("User ID Filter"),
                                                                 "Posting Date" = field(ThisMonth),
                                                                 "Entry Type" = filter(Usage)));
            DecimalPlaces = 0 : 2;
        }
        field(50106; TwoLastMonth; Date)
        {
            Editable = false;
            FieldClass = FlowFilter;
        }

        field(50107; HoursWorkedTwoLastMonth; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Hours Two Months Ago';
            ToolTip = 'The number of hours submitted, approved and posted to the Resource Ledger TWO MONTHS AGO.';
            CalcFormula = sum("Res. Ledger Entry".Quantity where("Resource No." = field("User ID Filter"),
                                                                 "Posting Date" = field(TwoLastMonth),
                                                                 "Entry Type" = filter(Usage)));
            DecimalPlaces = 0 : 2;
        }
        field(50108; OngoingJobs; Integer)
        {
            CalcFormula = count(Job where(Status = filter(Open)));
            Caption = 'Ongoing Projects';
            FieldClass = FlowField;
            ToolTip = 'Specifies number of currently active (Open) projects';
        }
    }
}