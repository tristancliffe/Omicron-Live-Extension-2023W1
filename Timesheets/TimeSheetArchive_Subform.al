pageextension 50204 "Time Sheet Archive Subform Ext" extends "Time Sheet Archive Subform"
{
    layout
    {
        addafter(Description)
        {
            field("Work Done"; Rec."Work Done")
            {
                ApplicationArea = all;
                AssistEdit = true;

                trigger OnAssistEdit()
                begin
                    Message(Rec."Work Done");
                end;
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action(JobPlanningLines)
            {
                ApplicationArea = All;
                Caption = 'Timesheet Entries';
                Image = History;
                ToolTip = 'Shows the entries made for the job so far that have been approved and posted';
                Scope = Repeater;
                RunObject = Page "Job Planning Lines";
                RunPageLink = "Job No." = FIELD("Job No.");
                RunPageView = SORTING("Job No.", "Planning Date", "Document No.")
                                  ORDER(Descending);
            }
            action("Report Timesheet Entries")
            {
                ApplicationArea = All;
                Caption = 'Job History PDF';
                Image = History;
                ToolTip = 'Open the approved and posted job history in a PDF format. You''ll need to print it or use a PDF app.';
                Scope = Repeater;

                trigger OnAction()
                var
                    Job: Record Job;
                    TimesheetReport: Report "Timesheet Entries";
                begin
                    Job.SetFilter("No.", Rec."Job No.");
                    TimesheetReport.SetTableView(Job);
                    TimesheetReport.UseRequestPage(false);
                    TimesheetReport.RunModal();
                end;
            }
        }
    }
}