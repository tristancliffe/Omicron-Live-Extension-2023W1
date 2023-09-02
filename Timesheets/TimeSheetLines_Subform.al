pageextension 50132 TimesheetFormExt extends "Time Sheet Lines Subform"
{
    layout
    {
        modify(Status)
        { StyleExpr = StatusStyle; }
        addafter(Description)
        {
            field("Work Done"; Rec."Work Done")
            {
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
                            rec."Work Done" := Dialog.SaveText();
                            rec.Modify(); //saves the line to the table even if no other field is selected
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
        { Visible = true; }
        modify("Job Task No.")
        {
            Caption = 'Job Task';
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
        { Visible = true; ShowMandatory = AbsenceStyle; }
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
                Caption = 'Timesheet History';
                Image = History;
                ToolTip = 'Shows the entries made for the job so far that have been approved and posted';
                Scope = Repeater;
                RunObject = Page "Job Planning Lines";
                RunPageLink = "Job No." = FIELD("Job No.");
                RunPageView = SORTING("Job No.", "Planning Date", "Document No.")
                                  ORDER(Descending);
            }
            action(JobCard)
            {
                ApplicationArea = All;
                Caption = 'Job Card';
                Image = Job;
                ToolTip = 'Go to the main job card for the job.';
                Scope = Repeater;
                RunObject = Page "Job Card";
                RunPageLink = "No." = field("Job No.");
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
    trigger OnAfterGetCurrRecord()
    var
        Job: Record Job;
    Begin
        SetStyles();
    End;

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