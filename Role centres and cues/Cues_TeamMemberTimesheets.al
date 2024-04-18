pageextension 50161 TeamMemberTimeSheetCues extends "Team Member Activities"
{
    CaptionML = ENG = 'Time Sheets';
    layout
    {
        addbefore("Current Time Sheet")
        {
            cuegroup(TimeSheetHistory)
            {
                CuegroupLayout = Wide;
                Caption = 'Time Sheet History';
                ShowCaption = false;

                field(HoursWorkedThisMonth; Rec.HoursWorkedThisMonth)
                { ApplicationArea = All; DrillDownPageId = "Resource Ledger Entries"; Style = Favorable; }
                field(HoursWorkedLastMonth; Rec.HoursWorkedLastMonth)
                { ApplicationArea = All; DrillDownPageId = "Resource Ledger Entries"; Style = Favorable; }
                field(HoursWorkedTwoLastMonth; Rec.HoursWorkedTwoLastMonth)
                { ApplicationArea = All; DrillDownPageId = "Resource Ledger Entries"; Style = Favorable; }
            }
        }
        addafter("Open Time Sheets")
        {
            field(AllTimeSheets; Rec.AllTimeSheets)
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageID = "Time Sheet List";
                ToolTip = 'This will show all the un-archived timesheets for a given user, including those fully submitted and approved.';
            }
            field(ArchivedTimeSheets; Rec.ArchivedTimeSheets)
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageId = "Time Sheet Archive List";
                Tooltip = 'This will show the archived timesheets for a given user. It will eventually be a very long list!';
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetFilter(TwoLastMonth, '%1..%2', CalcDate('<-CM-2M>', WorkDate()), CalcDate('<-CM-1M-1D', WorkDate()));
        Rec.SetFilter(LastMonth, '%1..%2', CalcDate('<-CM-1M>', WorkDate()), CalcDate('<-CM-1D', WorkDate()));
        Rec.SetFilter(ThisMonth, '%1..%2', CalcDate('<-CM>', WorkDate()), Today);
    end;
}