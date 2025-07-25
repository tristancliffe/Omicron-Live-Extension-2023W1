pageextension 50131 TimesheetCardExt extends "Time Sheet Card"
{
    AboutTitle = 'Timesheets';
    AboutText = 'Use this page to enter timesheets to record hours on projects & administration/clerical duties, and absenses from work.';
    DataCaptionExpression = Format(Rec."Starting Date", 0, 4) + ' - ' + Format(Rec."Ending Date", 0, 4) + ' (' + Rec.Description + ') - ' + Rec."Resource Name";

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
            field(SubmitMsg; SubmitLbl)
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                ShowCaption = false;
                Style = StrongAccent;
                StyleExpr = TRUE;
                ToolTip = 'Submit all open lines - use this when you have finished updating your timesheet please.';

                trigger OnDrillDown()
                begin
                    SubmitLines();
                end;
            }
            field("Dropbox Link"; "Dropbox Link")
            {
                ApplicationArea = All;
                Caption = 'Image Uploads:';
                ShowCaption = true;
                Editable = false;
                Style = Strong;
            }
            label(BlankLabel)
            {
                ApplicationArea = Basic, Suite;
                ShowCaption = false;
                Caption = ' ';
                Visible = false;
            }
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
                Caption = 'Project Journal';
                Image = JobJournal;
                ApplicationArea = All;
                RunObject = Page "Job Journal";
                ShortcutKey = 'Shift+Ctrl+K';
                ToolTip = 'Takes the user to the Project Journal';
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
        SubmitLbl: Label 'Click here to submit all open lines...';
        RefActionType: Option Submit,ReopenSubmitted,Approve,ReopenApproved,Reject;
        EmploymentQst: Label 'Time Sheet: %1 for dates prior to the Employment Date: %2  for Resource user.Do you still want to submit open lines?', Comment = '%1=Time Sheet No; %2= Resource Employment Date';
        TimeSheetApprovalMgt: Codeunit "Time Sheet Approval Management";

    trigger OnOpenPage()
    begin
        if (CurrentClientType = CurrentClientType::Phone) or (CurrentClientType = CurrentClientType::Tablet) then
            Device := false
        else
            Device := true;
        "Dropbox Link" := 'bit.ly/omicronltd';
        Reminder := 'Don''t forget to SUBMIT timesheets regularly. \Keep STOCK CARDS up to date. Upload PICTURES.';
    end;

    local procedure SubmitLines()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSubmitLines2(Rec, IsHandled);
        if IsHandled then
            exit;

        if not CheckResourceEmployment2(RefActionType::Submit, Rec."Resource No.") then
            if TimeSheetApprovalMgt.ConfirmAction(RefActionType::Submit) then
                Process(RefActionType::Submit);
    end;

    local procedure CheckResourceEmployment2(ActionType: Option Submit,Reopen,Approve,ReopenApproved,Reject; ResourceNo: Code[20]): Boolean
    var
        Resource: Record Resource;
    begin
        if Resource.Get(ResourceNo) then
            if Resource."Employment Date" <> 0D then
                if Resource."Employment Date" > Rec."Starting Date" then begin
                    if Confirm(EmploymentQst, false, Rec."No.", Resource."Employment Date") then
                        Process(ActionType);
                    exit(true);
                end;
        exit(false)
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSubmitLines2(var TimeSheetHeader: Record "Time Sheet Header"; var IsHandled: Boolean);
    begin
    end;

    // local procedure OnBeforeReopenLines2(var TimeSheetHeader: Record "Time Sheet Header"; var IsHandled: Boolean);
    // begin
    // end;

    // local procedure ApproveLines2()
    // var
    //     IsHandled: Boolean;
    // begin
    //     IsHandled := false;
    //     OnBeforeSubmitLines2(Rec, IsHandled);
    //     if IsHandled then
    //         exit;

    //     if not CheckResourceEmployment2(RefActionType::Approve, Rec."Resource No.") then
    //         if TimeSheetApprovalMgt.ConfirmAction(RefActionType::Approve) then
    //             Process(RefActionType::Approve);
    // end;

    // local procedure ReopenApprovedLines2()
    // var
    //     IsHandled: Boolean;
    // begin
    //     IsHandled := false;
    //     OnBeforeReopenLines2(Rec, IsHandled);
    //     if IsHandled then
    //         exit;

    //     if TimeSheetApprovalMgt.ConfirmAction(RefActionType::ReopenApproved) then
    //         Process(RefActionType::ReopenApproved);
    // end;
}