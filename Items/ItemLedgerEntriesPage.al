pageextension 50180 ItemLedgerEntriesExt extends "Item Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field(ReasonCode; Rec.ReasonCode)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
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
                ToolTip = 'Shows who created this entry.';
            }
        }
        moveafter("Entry No."; RunningBalance)
        modify(RunningBalance)
        { Visible = true; }
    }
}