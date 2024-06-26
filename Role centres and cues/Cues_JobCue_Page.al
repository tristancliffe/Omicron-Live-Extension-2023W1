pageextension 50150 ProjectCues extends "Project Manager Activities"
{
    CaptionML = ENG = 'Project Activities';
    layout
    {
        addlast("Jobs to Budget")
        {
            field(OngoingJobsCue; Rec.OngoingJobs)
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageID = "Job List";
                ToolTip = 'Specifies number of currently active (Open) projects';
                Caption = 'Active Projects';
                Visible = true;
                Image = Calendar;
            }
            field(ActiveTimeSheetsCue; Rec.ActiveTimeSheetsCue)
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageId = "Time Sheet List";
                Tooltip = 'Number of timesheets not submitted';
                Caption = 'Open Time Sheets';
                Visible = true;
                Image = Time;
            }
            field(OpenTimeSheetsCue; Rec.OpenTimeSheetsCue)
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageId = "Time Sheet List";
                ToolTip = 'Number of active Time Sheets';
                Caption = 'Time Sheets';
                Visible = true;
                Image = Library;
            }
            field(HoursThisMonth; Rec.HoursThisMonth)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Hours This Month';
                AutoFormatExpression = '<precision, 0:0><standard format, 0>';
                ToolTip = 'Number of approved/journalled hours in the last 30 days, including Admin.';
                AutoFormatType = 11;
                Image = Funnel;
            }
            field(ChargeableThisMonth; Rec.ChargeableThisMonth)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Chargeable This Month';
                ToolTip = 'Number of approved/journalled hours that can be charged from the last 30 days, excluding Admin.';
                AutoFormatExpression = '<precision, 0:0><standard format, 0>';
                AutoFormatType = 11;
                Image = Cash;
            }
            field(OpenTimesheetHours; Rec.OpenTimeSheetHours)
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageId = "Time Sheet Lines Subform";
                Tooltip = 'Number of ''Open'' or ''Submitted'' hours in timesheets, not approved';
                Caption = 'Open Time Sheet Hours';
                Visible = true;
                Image = Message;
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