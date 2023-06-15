pageextension 50142 TimeSheetList extends "Time Sheet List"
{
    layout
    {
        modify(Description)
        { StyleExpr = PendingStyle; }
        modify("Resource No.")
        { StyleExpr = PendingStyle; }
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
                RunObject = Page "Time Sheet Archive";
                ToolTip = 'Takes the user to the Time Sheet Archive page';
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
}