pageextension 50161 TeamMemberTimeSheetCues extends "Team Member Activities"
{
    CaptionML = ENG = 'Time Sheets';
    layout
    {
        addafter(Approvals)
        {
            label("Timesheet History")
            { ApplicationArea = All; Caption = 'Time Sheet History'; }
            cuegroup(TimeSheetHistory)
            {
                CuegroupLayout = Wide;
                Caption = 'Hours submitted history...';
                field(HoursWorkedThisMonth; Rec.HoursWorkedThisMonth)
                { ApplicationArea = All; DrillDownPageId = "Resource Ledger Entries"; Style = Favorable; }
                field(HoursWorkedLastMonth; Rec.HoursWorkedLastMonth)
                { ApplicationArea = All; DrillDownPageId = "Resource Ledger Entries"; Style = Favorable; }
                field(HoursWorkedTwoLastMonth; Rec.HoursWorkedTwoLastMonth)
                { ApplicationArea = All; DrillDownPageId = "Resource Ledger Entries"; Style = Favorable; }
            }
            // label("Projects")
            // { ApplicationArea = All; ShowCaption = false; }
            cuegroup(ActiveProjects)
            {
                Caption = 'Projects';
                field(OngoingJobsCue; Rec.OngoingJobs)
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Job List";
                    Caption = 'Active Projects';
                    Visible = true;
                    Image = Checklist;
                }
                field(StockList; Rec.StockList)
                {
                    ApplicationArea = Basic, Suite;
                    //DrillDownPageID = "Stock Entry List";
                    DrillDown = true;
                    Caption = 'Stock Used';
                    Visible = true;
                    Image = Checklist;

                    trigger OnDrillDown()
                    var
                        StockList: Record "Stock Used";
                    begin
                        StockList.Reset();
                        StockList.SetRange("Resource No.", UserId);
                        if not StockList.IsEmpty then
                            Page.Run(Page::"Stock Entry List", StockList);
                    end;
                }
            }
        }
        addafter("Open Time Sheets")
        {
            field(AllTimeSheets; Rec.AllTimeSheets)
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageID = "Time Sheet List";
            }
            field(ArchivedTimeSheets; Rec.ArchivedTimeSheets)
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageId = "Time Sheet Archive List";
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