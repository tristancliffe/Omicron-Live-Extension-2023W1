pageextension 50131 TimesheetCardExt extends "Time Sheet Card"
{
    AboutTitle = 'Timesheets';
    AboutText = 'Use this page to enter timesheets to record hours on jobs & administration/clerical duties, and absenses from work.';
    layout
    {
        modify(Description)
        { Importance = Additional; }
        Modify("Resource No.")
        { Importance = Additional; }
        addafter("Resource No.")
        {
            field("Resource Name1"; Rec."Resource Name")
            { ApplicationArea = All; Importance = Promoted; }
            // field(SubmitMsg; SubmitLbl)
            // {
            //     ApplicationArea = Basic, Suite;
            //     Editable = false;
            //     ShowCaption = false;
            //     Style = StrongAccent;
            //     StyleExpr = TRUE;
            //     ToolTip = 'Submit all open lines - use this when you have finished updating your timesheet please.';

            //     trigger OnDrillDown()
            //     begin
            //         SubmitLines();
            //     end;
            // }
            field(Reminder; Reminder)
            {
                ApplicationArea = All;
                Importance = Promoted;
                ShowCaption = false;
                Editable = false;
                MultiLine = true;
                Style = Attention;
                ToolTip = 'You must submit your timesheet lines when you have finished them or at the end of the week.';
            }
        }
    }
    actions
    {
        addlast("F&unctions")
        {
            action(ManagerTimeSheet)
            {
                Caption = 'Manager Time Sheets';
                Image = Timesheet;
                ApplicationArea = All;
                RunObject = Page "Manager Time Sheet List";
                ShortcutKey = 'Shift+Ctrl+J';
                ToolTip = 'Takes the user to the Manager Time Sheet page';
                Visible = Device;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
            }
            action(TimeSheetLink)
            {
                Caption = 'Time Sheets';
                Image = Timesheet;
                ApplicationArea = All;
                RunObject = Page "Time Sheet List";
                ToolTip = 'Takes the user to the Time Sheet page';
                Visible = Device;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
            }
            action(JobJournalLink)
            {
                Caption = 'Job Journal';
                Image = JobJournal;
                ApplicationArea = All;
                RunObject = Page "Job Journal";
                ShortcutKey = 'Shift+Ctrl+K';
                ToolTip = 'Takes the user to the Job Journal';
                Visible = Device;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
            }
            action(MoveTimeSheetsToArchive)
            {
                ApplicationArea = Jobs;
                Caption = 'Move Time Sheets to Archive';
                Image = Archive;
                //RunObject = Report "Move Time Sheets to Archive";
                ToolTip = 'Archive time sheets.';
                Visible = Device;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Timesheet: Record "Time Sheet Header";
                    ArchiveTimeSheet: Report "Move Time Sheets to Archive";
                begin
                    Timesheet.SetFilter("No.", Rec."No.");
                    ArchiveTimeSheet.SetTableView(Timesheet);
                    ArchiveTimeSheet.RunModal();
                    Clear(ArchiveTimeSheet);
                end;
            }
            action(Absences)
            {
                ApplicationArea = All;
                Caption = 'Absences';
                Image = Absence;
                Tooltip = 'Show a list of staff absenses.';
                RunObject = Page "Employee Absences";
                RunPageLink = "Employee No." = field("Resource No.");
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
            }
        }
    }
    var
        Device: Boolean;
        "Dropbox Link": Text[50];
        Reminder: Text[150];
        SubmitLbl: Label 'Submit Lines';

    trigger OnOpenPage()
    begin
        if (CurrentClientType = CurrentClientType::Phone) or (CurrentClientType = CurrentClientType::Tablet) then
            Device := false
        else
            Device := true;
        "Dropbox Link" := 'https://bit.ly/omicronltd';
        Reminder := 'Don''t forget to SUBMIT timesheets regularly. \Keep STOCK CARDS up to date. Upload PICTURES.';
    end;
}