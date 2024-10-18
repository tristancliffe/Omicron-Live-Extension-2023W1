pageextension 50180 ItemLedgerEntriesExt extends "Item Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field(ReasonCode; Rec.ReasonCode)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Reason Code';
            }
        }
        addafter("Shortcut Dimension 8 Code")
        {
            field(CreatedByFlow; Rec.CreatedByFlow)
            {
                Visible = true;
                ApplicationArea = All;
                Caption = 'Created By';
            }
        }
        moveafter("Entry No."; RunningBalance)
        modify(RunningBalance) { Visible = true; }
    }
}