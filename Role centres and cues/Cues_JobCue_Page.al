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
                Caption = 'Active Projects';
                Visible = true;
                Image = Calendar;
            }
            field(ActiveTimeSheetsCue; Rec.ActiveTimeSheetsCue)
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageId = "Time Sheet List";
                Caption = 'Open Time Sheets';
                Visible = true;
                Image = Time;
            }
            field(OpenTimeSheetsCue; Rec.OpenTimeSheetsCue)
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageId = "Time Sheet List";
                Caption = 'Time Sheets';
                Visible = true;
                Image = Library;
            }
            field(HoursThisMonth; Rec.HoursThisMonth)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Hours This Month';
                AutoFormatExpression = '<precision, 0:0><standard format, 0>';
                AutoFormatType = 11;
                Image = Funnel;
            }
            field(ChargeableThisMonth; Rec.ChargeableThisMonth)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Chargeable This Month';
                AutoFormatExpression = '<precision, 0:0><standard format, 0>';
                AutoFormatType = 11;
                Image = Cash;
            }
            field(OpenTimesheetHours; Rec.OpenTimeSheetHours)
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageId = "Time Sheet Lines Subform";
                Caption = 'Open Time Sheet Hours';
                Visible = true;
                Image = Message;
            }
            field("Job Stock Outstanding"; Rec."Job Stock Outstanding")
            {
                DrillDownPageId = "Stock Card List";
                ApplicationArea = All;
                Image = Diagnostic;
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