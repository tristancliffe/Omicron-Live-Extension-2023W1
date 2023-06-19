#pragma implicitwith disable
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
                ShowMandatory = true;
                DrillDown = true;

                Editable = CanEdit;
                AssistEdit = true;

                trigger OnAssistEdit()
                var
                    Dialog: Page "Work Done Dialog";
                begin
                    if CanEdit = false then
                        exit //message('%1', rec."Work Done")
                    else begin
                        Dialog.GetText(rec."Work Done");
                        if Dialog.RunModal() = Action::OK then
                            rec."Work Done" := Dialog.SaveText()
                    end;
                end;

                trigger OnDrillDown()
                begin
                    if CanEdit = false then
                        message('%1', rec."Work Done")
                    else
                        exit;
                end;
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
            trigger OnAfterValidate()
            begin
                if Rec."Work Done" = '' then
                    Rec."Work Done" := Rec.Description;
                Rec.Modify();
            end;
        }
        moveafter(Status; "Job No.")
        moveafter("Job No."; "Job Task No.")
        moveafter("Total Quantity"; Chargeable)
        movebefore(Chargeable; "Cause of Absence Code")
        modify(Chargeable)
        { Visible = true; }
        modify("Cause of Absence Code")
        { Visible = true; }
        modify(UnitOfMeasureCode)
        { QuickEntry = false; }
        modify(TimeSheetTotalQuantity)
        { QuickEntry = false; }
    }
    trigger OnAfterGetCurrRecord()
    var
        Job: Record Job;
    Begin
        IF rec.Status = rec.Status::Open THEN
            CanEdit := TRUE
        ELSE
            CanEdit := FALSE;
        ;
    End;

    trigger OnAfterGetRecord()
    begin
        StatusStyle := ChangeStatusColor.ChangeLineStatusColour(Rec);
    end;

    var
        CanEdit: Boolean;
        StatusStyle: Text[50];
        ChangeStatusColor: Codeunit ChangeStatusColour;
}