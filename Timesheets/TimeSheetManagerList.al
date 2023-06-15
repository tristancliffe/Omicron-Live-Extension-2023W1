pageextension 50141 TimeSheetManagerListExt extends "Manager Time Sheet List"
{
    layout
    {
        modify("Resource No.")
        {
            StyleExpr = PendingStyle;
        }
    }
    actions
    {
        addlast("&Time Sheet")
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
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Starting Date", "Resource No.");
        Rec.Ascending(true);
    end;

    trigger OnAfterGetRecord()
    begin
        SetPendingStyle();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetPendingStyle();
    end;

    procedure SetPendingStyle()
    begin
        PendingStyle := 'Standard';
        if Rec."Quantity Open" >= 0.25 then begin
            PendingStyle := 'AttentionAccent';
        end else
            if Rec."Quantity Submitted" >= 0.25 then begin
                PendingStyle := 'StrongAccent';
            end else
                if Rec."Quantity Approved" >= 0.25 then begin
                    PendingStyle := 'Favorable';
                end else
                    if Rec."Quantity Rejected" >= 0.25 then begin
                        PendingStyle := 'Unfavorable';
                    end
                    else
                        PendingStyle := 'Standard';
    end;

    var
        PendingStyle: Text;
}