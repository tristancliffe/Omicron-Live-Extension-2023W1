pageextension 50131 TimesheetCardExt extends "Time Sheet Card"
{
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
            field(Reminder; Reminder)
            {
                ApplicationArea = All;
                Importance = Promoted;
                Editable = false;
                MultiLine = true;
                Style = Strong;
            }
            field("Dropbox Link"; "Dropbox Link")
            {
                ApplicationArea = All;
                Importance = Promoted;
                Description = 'The link to the Dropbox image upload page';
                ExtendedDatatype = URL;
                Editable = false;
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
                end;
            }
        }
    }
    var
        Device: Boolean;
        "Dropbox Link": Text[50];
        Reminder: Text[150];

    trigger OnOpenPage()
    begin
        if (CurrentClientType = CurrentClientType::Phone) or (CurrentClientType = CurrentClientType::Tablet) then
            Device := false
        else
            Device := true;
        "Dropbox Link" := 'https://bit.ly/omicronltd';
        Reminder := 'Do not forget to SUBMIT your timesheets regularly. \Keep STOCK CARDS up to date. Take & UPLOAD pictures.';
    end;
}