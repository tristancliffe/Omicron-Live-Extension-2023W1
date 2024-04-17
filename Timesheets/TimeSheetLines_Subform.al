pageextension 50132 TimesheetFormExt extends "Time Sheet Lines Subform"
{
    AboutTitle = 'Timesheet Lines';
    AboutText = 'Use this section to enter the times for each day...';
    layout
    {
        modify(Type)
        { AboutTitle = 'Type'; AboutText = 'Use **Project** or **Absence**. Don''t worry about Resource, Service or Assembly Order.'; }
        modify(Status)
        { StyleExpr = StatusStyle; AboutTitle = 'Status'; AboutText = 'Open lines can be edited, but MUST be submitted when you''re finished. Submitted lines can be reopened until they are approved. Approved lines can be unapproved for editing unless they have been posted.'; }
        addafter(Description)
        {
            field("Work Done"; Rec."Work Done")
            {
                AboutTitle = 'Work Done';
                AboutText = 'This field can accept up to 700 characters of text, describing what work was carried out, measurements taken, tests performed etc. Try to write in a scientific manner, e.g. "a leak down test was carried out" rather than "I did a leak down test".';
                Visible = true;
                ApplicationArea = all;
                ShowMandatory = WorkDoneStyle;
                //DrillDown = true;

                Editable = CanEdit;
                AssistEdit = true;

                trigger OnAssistEdit()
                var
                    Dialog: Page "Work Done Dialog";
                begin
                    if CanEdit = false then
                        message('%1', rec."Work Done") //exit
                    else begin
                        Dialog.GetText(rec."Work Done");
                        if Dialog.RunModal() = Action::OK then begin
                            // rec."Work Done" := Dialog.SaveText();
                            // rec.Modify(); //saves the line to the table even if no other field is selected
                            rec.Validate(Rec."Work Done", Dialog.SaveText());
                        end;
                    end;
                end;

                // trigger OnDrillDown()
                // begin
                //     if CanEdit = false then
                //         message('%1', rec."Work Done")
                //     else
                //         exit;
                // end;
            }
        }
        modify(Description)
        { Visible = false; }
        modify("Job No.")
        { Visible = true; AboutTitle = 'Project Number'; AboutText = 'Choose the project (or admin) that the work was done on from the drop-down list.'; }
        modify("Job Task No.")
        {
            AboutTitle = 'Project Task';
            AboutText = 'Please use **appropriate* tasks. If work is carried out on two unrelated aspects then they should be recorded on separate lines. Removing a gearbox to get to a clutch can still be recorded under **Clutch** for example, but sorted the brake lights out at the same time needs a new line.';
            Caption = 'Project Task';
            Visible = true;
            // trigger OnAfterValidate()
            // begin
            //     if Rec."Work Done" = '' then
            //         Rec."Work Done" := Rec.Description;
            //     Rec.Modify();
            // end;
        }
        moveafter(Status; "Job No.", "Job Task No.")
        moveafter("Total Quantity"; "Cause of Absence Code", Chargeable)
        modify(Chargeable)
        { Visible = Device; }
        modify("Cause of Absence Code")
        { Visible = true; ShowMandatory = AbsenceStyle; AboutTitle = 'Absences'; AboutText = 'Use this, and NOT Admin to record time off work, including bank holidays, sickness, approved holiday etc.'; }
        modify(UnitOfMeasureCode)
        { QuickEntry = false; }
        modify(TimeSheetTotalQuantity)
        { QuickEntry = false; }

    }
    actions
    {
        addlast(Processing)
        {
            action(JobPlanningLines)
            {
                ApplicationArea = All;
                Caption = 'Project Timesheet History';
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
                Caption = 'Task Timesheet History';
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
                Caption = 'View Project Card';
                Image = Job;
                ToolTip = 'Go to the main project card for the project.';
                Scope = Repeater;
                RunObject = Page "Job Card";
                RunPageLink = "No." = field("Job No.");
            }
            // action("Report Timesheet Entries")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Job History PDF';
            //     Image = History;
            //     ToolTip = 'Open the approved and posted job history in a PDF format. You''ll need to print it or use a PDF app.';
            //     Scope = Repeater;

            //     trigger OnAction()
            //     var
            //         Job: Record Job;
            //         TimesheetReport: Report "Timesheet Entries";
            //     begin
            //         Job.SetFilter("No.", Rec."Job No.");
            //         TimesheetReport.SetTableView(Job);
            //         TimesheetReport.UseRequestPage(false);
            //         TimesheetReport.RunModal();
            //     end;
            // }
        }
    }
    // trigger OnAfterGetCurrRecord()
    // var
    //     Job: Record Job;
    // Begin
    //     SetStyles();
    // End;

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
}