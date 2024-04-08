pageextension 50185 BankRecLedgerLinesExt extends "Apply Bank Acc. Ledger Entries"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Document Date"; Rec."Document Date")
            { ApplicationArea = All; Visible = true; }
        }
        moveafter(Open; "Bal. Account No.")
        modify("Bal. Account No.")
        { Visible = true; }
        addafter(Open)
        {
            field("User ID"; Rec."User ID")
            { ApplicationArea = All; }
        }
        modify("Check Ledger Entries")
        { Visible = false; }
        modify("External Document No.")
        { Visible = false; }
    }
    actions
    {
        addfirst(Processing)
        {
            action("&Navigate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Find entries...';
                Image = Navigate;
                ShortCutKey = 'Ctrl+Alt+Q';
                ToolTip = 'Find entries and documents that exist for the document number and posting date on the selected document. (Formerly this action was named Navigate.)';
                Scope = Repeater;

                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.Run();
                end;
            }
        }
    }
    var
        Navigate: Page Navigate;
}