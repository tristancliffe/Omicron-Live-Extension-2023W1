pageextension 50132 TimesheetFormExt extends "Time Sheet Lines Subform"
{
    AboutTitle = 'Timesheet Lines';
    AboutText = 'Use this section to enter the times for each day...';
    layout
    {
        modify(Control1) { FreezeColumn = "Resource No."; }
        modify(Type) { AboutTitle = 'Type'; Width = 6; AboutText = 'Use **Project** or **Absence**. Don''t worry about Resource, Service or Assembly Order.'; }
        modify(Status) { StyleExpr = StatusStyle; AboutTitle = 'Status'; AboutText = 'Open lines can be edited, but MUST be submitted when you''re finished. Submitted lines can be reopened until they are approved. Approved lines can be unapproved for editing unless they have been posted.'; }

        movefirst(Control1; Status, Type, "Job No.", "Job Task No.")
        addfirst(Control1)
        {
            field("Resource No."; Rec."Resource No.")
            {
                ApplicationArea = Jobs;
                Visible = false;
            }
        }
        addafter(Description)
        {
            field("Work Done"; Rec."Work Done")
            {
                AboutTitle = 'Work Done';
                AboutText = 'This field can accept up to 700 characters of text, describing what work was carried out, measurements taken, tests performed etc. Try to write in a scientific manner, e.g. "a leak down test was carried out" rather than "I did a leak down test".';
                Visible = true;
                ApplicationArea = all;
                ShowMandatory = WorkDoneStyle;
                Editable = CanEdit;
                AssistEdit = true;

                trigger OnAssistEdit()
                var
                    Dialog: Page "Work Done Dialog";
                    Check: Boolean;
                begin
                    if rec.Status <> rec.Status::Open then
                        // if CanEdit = false then
                        message('%1', rec."Work Done") //exit
                    else begin
                        Dialog.GetText(rec."Work Done");
                        if Dialog.RunModal() = Action::OK then
                            rec.Validate(Rec."Work Done", Dialog.SaveText());
                    end;
                end;
            }
        }
        modify(Description) { Visible = false; }
        modify("Job No.") { Visible = true; AboutTitle = 'Project Number'; AboutText = 'Choose the project (or admin) that the work was done on from the drop-down list.'; }
        modify("Job Task No.")
        {
            AboutTitle = 'Project Task';
            AboutText = 'Please use **appropriate* tasks. If work is carried out on two unrelated aspects then they should be recorded on separate lines. Removing a gearbox to get to a clutch can still be recorded under **Clutch** for example, but sorted the brake lights out at the same time needs a new line.';
            Caption = 'Project Task';
            Visible = true;

            trigger OnAfterValidate()
            begin
                if rec."Job Task No." = 'DIARY' then
                    rec.Validate("Work Done", 'Diary');
                //Rec.Modify();
            end;
        }
        moveafter("Total Quantity"; "Cause of Absence Code", Chargeable)
        modify("Work Type Code") { Visible = false; }
        modify(Chargeable) { Visible = Device; }
        modify("Cause of Absence Code") { Visible = true; ShowMandatory = AbsenceStyle; AboutTitle = 'Absences'; AboutText = 'Use this, and NOT Admin to record time off work, including bank holidays, sickness, approved holiday etc.'; }
        modify(UnitOfMeasureCode) { QuickEntry = false; }
        modify(TimeSheetTotalQuantity) { QuickEntry = false; }
    }
    actions
    {
        addlast(Processing)
        {
            action(StockCard)
            {
                Caption = 'Stock Card';
                Image = ItemLines;
                ApplicationArea = All;
                RunObject = Page "Stock Card Page";
                RunPageLink = "No." = field("Job No.");
                ToolTip = 'Takes the user to the Stock Card of the selected line as filled in by staff';
                Visible = false;
                Scope = Repeater;
            }
            action(StockCard2)
            {
                Caption = 'Stock Card';
                Image = ItemLines;
                ApplicationArea = All;
                RunObject = Page "Stock Used Job Form";
                RunPageLink = "Job No." = field("Job No.");
                ToolTip = 'Takes the user to the Stock Card of the selected line as filled in by staff';
                Visible = true;
                Scope = Repeater;
            }

            action(JobPlanningLines)
            {
                ApplicationArea = All;
                Caption = 'Project History';
                Image = History;
                ToolTip = 'Shows the entries made for the project so far that have been approved and posted';
                Scope = Repeater;
                RunObject = Page "Job Planning History";
                RunPageLink = "Job No." = FIELD("Job No.");
                RunPageView = SORTING("Job No.", "Planning Date", "Document No.")
                                  ORDER(Descending);
            }
            action(JobTaskLines)
            {
                ApplicationArea = All;
                Caption = 'Task History';
                Image = History;
                ToolTip = 'Shows the entries made for the selected task so far that have been approved and posted';
                Scope = Repeater;
                RunObject = Page "Job Planning History";
                RunPageLink = "Job No." = FIELD("Job No."), "Job Task No." = field("Job Task No.");
                RunPageView = SORTING("Job No.", "Planning Date", "Document No.")
                                  ORDER(Descending);
            }
            action(JobCard)
            {
                ApplicationArea = All;
                Caption = 'Project Card';
                Image = Job;
                ToolTip = 'Go to the main project card for the project.';
                Scope = Repeater;
                RunObject = Page "Job Card";
                RunPageLink = "No." = field("Job No.");
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetStyles();
    end;

    var
        CanEdit: Boolean;
        StatusStyle: Text[50];
        ChangeStatusColor: Codeunit ChangeStatusColour;
        Device: Boolean;
        WorkDoneStyle: Boolean;
        AbsenceStyle: Boolean;
    // RefActionType: Option Submit,ReopenSubmitted,Approve,ReopenApproved,Reject;
    // TimeSheetMgt: Codeunit "Time Sheet Management";
    // TimeSheetApprovalMgt: Codeunit "Time Sheet Approval Management";

    trigger OnOpenPage()
    begin
        if (CurrentClientType = CurrentClientType::Phone) or (CurrentClientType = CurrentClientType::Tablet) then
            Device := false
        else
            Device := true;
    end;

    local procedure SetStyles();
    begin
        WorkDoneStyle := true;
        AbsenceStyle := false;
        StatusStyle := ChangeStatusColor.ChangeLineStatusColour(Rec);
        if Rec.Type = Rec.Type::Absence then begin
            WorkDoneStyle := false;
            AbsenceStyle := true;
        end;
        IF rec.Status = rec.Status::Open THEN
            CanEdit := TRUE
        ELSE
            CanEdit := FALSE;
    end;

    // local procedure ApproveLines()
    // var
    //     IsHandled: Boolean;
    // begin
    //     IsHandled := false;
    //     OnBeforeApproveLines2(Rec, IsHandled);
    //     if IsHandled then
    //         exit;

    //     case ShowDialog2(RefActionType::Approve) of
    //         1:
    //             Process(RefActionType::Approve, true);
    //         2:
    //             Process(RefActionType::Approve, false);
    //     end;
    // end;

    // local procedure ReopenApprovedLines()
    // var
    //     IsHandled: Boolean;
    // begin
    //     IsHandled := false;
    //     OnBeforeReopenApprovedLines2(Rec, IsHandled);
    //     if IsHandled then
    //         exit;

    //     case ShowDialog2(RefActionType::ReopenApproved) of
    //         1:
    //             Process(RefActionType::ReopenApproved, true);
    //         2:
    //             Process(RefActionType::ReopenApproved, false);
    //     end;
    // end;

    // local procedure ShowDialog2(ActionType: Option Submit,ReopenSubmitted,Approve,ReopenApproved,Reject): Integer
    // begin
    //     exit(StrMenu(GetDialogText2(ActionType), 2, TimeSheetApprovalMgt.GetCommonTimeSheetDialogInstruction(ActionType)));
    // end;

    // [IntegrationEvent(false, false)]
    // local procedure OnBeforeApproveLines2(var TimeSheetLine: Record "Time Sheet Line"; var IsHandled: Boolean);
    // begin
    // end;

    // [IntegrationEvent(false, false)]
    // local procedure OnBeforeReopenApprovedLines2(var TimeSheetLine: Record "Time Sheet Line"; var IsHandled: Boolean);
    // begin
    // end;

    // local procedure GetDialogText2(ActionType: Option Submit,ReopenSubmitted,Approve,ReopenApproved,Reject): Text
    // var
    //     TimeSheetLine: Record "Time Sheet Line";
    // begin
    //     FilterAllLines(TimeSheetLine, ActionType);
    //     exit(TimeSheetApprovalMgt.GetCommonTimeSheetActionDialogText(ActionType, TimeSheetLine.Count()));
    // end;

    // local procedure FilterAllLines(var TimeSheetLine: Record "Time Sheet Line"; ActionType: Option Submit,ReopenSubmitted,Approve,ReopenApproved,Reject)
    // begin
    //     TimeSheetLine.CopyFilters(Rec);
    //     TimeSheetMgt.FilterAllTimeSheetLines(TimeSheetLine, ActionType);
    // end;
}