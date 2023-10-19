pageextension 50150 ProjectCues extends "Project Manager Activities"
{
    CaptionML = ENG = 'Job Activities';
    layout
    {
        addlast("Jobs to Budget")
        {
            field(OngoingJobsCue; Rec.OngoingJobs)
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageID = "Job List";
                ToolTip = 'Specifies number of currently active (Open) jobs';
                Caption = 'Active Jobs';
                Visible = true;
            }
            field(ActiveTimeSheetsCue; Rec.ActiveTimeSheetsCue)
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageId = "Time Sheet List";
                Tooltip = 'Number of timesheets not submitted';
                Caption = 'Open Time Sheets';
                Visible = true;
            }
            field(OpenTimeSheetsCue; Rec.OpenTimeSheetsCue)
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageId = "Time Sheet List";
                ToolTip = 'Number of active Time Sheets';
                Caption = 'Time Sheets';
                Visible = true;
            }
            field(HoursThisMonth; Rec.HoursThisMonth)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Hours This Month';
                AutoFormatExpression = '<precision, 0:0><standard format, 0>';
                AutoFormatType = 11;
            }
            field(ChargeableThisMonth; Rec.ChargeableThisMonth)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Chargeable This Month';
                AutoFormatExpression = '<precision, 0:0><standard format, 0>';
                AutoFormatType = 11;
            }
        }
        modify("Completed - WIP Not Calculated")
        { Visible = false; }
        modify(Invoicing)
        { Visible = false; }
        modify("Jobs Over Budget")
        { Visible = false; }
    }
}