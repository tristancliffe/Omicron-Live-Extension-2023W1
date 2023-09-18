pageextension 50142 TimeSheetList extends "Time Sheet List"
{
    layout
    {
        modify(Description)
        { StyleExpr = PendingStyle; }
        modify("Resource No.")
        { StyleExpr = PendingStyle; }
        modify(Quantity)
        { BlankZero = true; }
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
            action(ManagerTimeSheet)
            {
                Caption = 'Manager Time Sheets';
                Image = Timesheet;
                ApplicationArea = All;
                RunObject = Page "Manager Time Sheet List";
                ShortcutKey = 'Shift+Ctrl+J';
                ToolTip = 'Takes the user to the Manager Time Sheet List page';
                Visible = true;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
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
            action(ArchiveTimeSheet)
            {
                Caption = 'Archive Timesheet';
                Image = Archive;
                ApplicationArea = All;
                ToolTip = 'Send this sheet to the archive if fully posted';
                Visible = Device;
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
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Starting Date", "Resource No.");
        Rec.Ascending(true);
        if (CurrentClientType = CurrentClientType::Phone) or (CurrentClientType = CurrentClientType::Tablet) then
            Device := false
        else
            Device := true;
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
        // if (Rec.Quantity < 40.0) and (rec.Quantity > 0) then
        //     PendingStyle := 'Unfavorable';
        if rec.Quantity = 0 then
            PendingStyle := 'Strong'
        else
            if (Rec.Quantity > 35) and (Rec.Quantity = (Rec."Quantity Approved" + Rec."Quantity Submitted")) then
                PendingStyle := 'Favorable'
            else
                if (Rec.Quantity > 20) and (Rec.Quantity = (Rec."Quantity Approved" + Rec."Quantity Submitted")) then
                    PendingStyle := 'Attention'
                else
                    if rec.Quantity < 35 then
                        PendingStyle := 'Unfavorable';
        //PendingStyle := 'Standard';
    end;

    var
        PendingStyle: Text;
        Device: Boolean;
}