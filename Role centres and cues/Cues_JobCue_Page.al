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
            field(OpenTimeSheetsCue; Rec.OpenTimeSheetsCue)
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageId = "Time Sheet List";
                ToolTip = 'Number of active Time Sheets';
                Caption = 'Time Sheets';
                Visible = true;
            }
        }
        modify("Completed - WIP Not Calculated")
        { Visible = false; }
        modify(Invoicing)
        { Visible = false; }
    }
}