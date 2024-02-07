pageextension 50141 TimeSheetManagerListExt extends "Manager Time Sheet List"
{
    layout
    {
        modify("Resource No.")
        { StyleExpr = PendingStyle; }
        modify(Quantity)
        { BlankZero = true; StyleExpr = OvertimeStyle; }
        modify("Quantity Open")
        { BlankZero = true; }
        modify("Quantity Submitted")
        { BlankZero = true; Style = Strong; }
        modify("Quantity Approved")
        { BlankZero = true; Style = Favorable; }
        modify("Quantity Rejected")
        { BlankZero = true; Style = Unfavorable; }
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
            action(ArchiveTimeSheet)
            {
                Caption = 'Archive Timesheet';
                Image = Archive;
                ApplicationArea = All;
                ToolTip = 'Send this sheet to the archive if fully posted';
                Visible = true;
                Promoted = true;
                PromotedOnly = true;
                Ellipsis = true;
                Scope = Repeater;

                trigger OnAction()
                var
                    Timesheet: Record "Time Sheet Header";
                    ArchiveReport: Report "Move Time Sheets to Archive";
                begin
                    Timesheet.SetFilter("No.", Rec."No.");
                    ArchiveReport.SetTableView(Timesheet);
                    ArchiveReport.RunModal();
                    Clear(ArchiveReport);
                end;
            }
            action(TimeSheetArchive)
            {
                Caption = 'Time Sheet Archive';
                Image = PostedTimeSheet;
                ApplicationArea = All;
                RunObject = Page "Time Sheet Archive List";
                ToolTip = 'Takes the user to the Time Sheet Archive list';
                Visible = true;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
            }
            action(OpenTimeSheet)
            {
                ApplicationArea = All;
                Caption = 'Open Time Sheet';
                Image = Timesheet;
                RunObject = Page "Time Sheet Card";
                RunPageLink = "No." = field("No.");
                ToolTip = 'Open this time sheet for editing (not as Manager).';
                Scope = Repeater;
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
        SetOvertimeStyle();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetPendingStyle();
        SetOvertimeStyle();
    end;

    procedure SetPendingStyle()
    begin
        PendingStyle := 'Standard';
        if Rec."Quantity Open" >= 0.25 then begin
            PendingStyle := 'Attention';
        end else
            if ((Rec.Quantity < 40) and (Rec."Quantity Open" = 0) and (Rec."Quantity Submitted" = 0)) then begin
                PendingStyle := 'Unfavorable'
            end else
                if Rec."Quantity Submitted" >= 0.25 then begin
                    PendingStyle := 'AttentionAccent';//'StrongAccent';
                end else
                    if Rec."Quantity Approved" = Rec.Quantity then begin
                        PendingStyle := 'Favorable';
                    end else
                        if Rec."Quantity Rejected" >= 0.25 then begin
                            PendingStyle := 'Unfavorable';
                        end else
                            PendingStyle := 'Standard';
    end;

    procedure SetOvertimeStyle()
    begin
        OvertimeStyle := 'Standard';
        if rec.Quantity > 40 then begin
            OvertimeStyle := 'Favorable';
        end else
            OvertimeStyle := 'Standard';
    end;

    var
        PendingStyle: Text;
        OvertimeStyle: Text;
}