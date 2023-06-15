pageextension 50145 TimeSheetManagerExt extends "Manager Time Sheet"
{
    layout
    {
        addafter(Description)
        {
            field("Work Done"; Rec."Work Done")
            {
                ApplicationArea = All;
                Editable = False;
                AssistEdit = true;

                trigger OnAssistEdit()
                begin
                    message(Rec."Work Done");
                end;
            }
        }
        addafter(Type)
        {
            field("Job No.1"; Rec."Job No.")
            { ApplicationArea = All; }
            field("Job Description"; JobDescription)
            { ApplicationArea = All; }
            field("Job Task No.1"; Rec."Job Task No.")
            { ApplicationArea = All; }
        }
        addafter(Status)
        {
            field("Cause of Absence Code1"; Rec."Cause of Absence Code")
            { ApplicationArea = All; }
        }
        addbefore(Status)
        {
            field(Chargeable1; Rec.Chargeable)
            { ApplicationArea = All; }
        }
    }
    actions
    {
        addlast("F&unctions")
        {
            action(JobJournal)
            {
                Caption = 'Job Journal';
                Image = JobJournal;
                ApplicationArea = All;
                RunObject = Page "Job Journal";
                ShortcutKey = 'Shift+Ctrl+J';
                ToolTip = 'Takes the user to the Job Journal';
                Visible = true;
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
                ToolTip = 'Takes the user to the Time Sheet List';
                Visible = true;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    var
        Job: Record Job;
    begin
        JobDescription := Job.Description;
    end;

    var
        JobDescription: Text[100];
}