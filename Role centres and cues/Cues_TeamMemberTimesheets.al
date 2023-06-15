pageextension 50161 TeamMemberTimeSheetCues extends "Team Member Activities"
{
    layout
    {
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
}