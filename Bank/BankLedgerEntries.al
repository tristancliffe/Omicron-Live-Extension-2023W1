pageextension 50198 BankAccountLedgerEntries extends "Bank Account Ledger Entries"
{
    layout
    {
        moveafter("Bank Account No."; "Bal. Account No.")
        modify("Bal. Account No.")
        { Visible = true; }
        modify(Reversed)
        { Visible = true; }
        moveafter("Global Dimension 1 Code"; Amount, RunningBalance, Open, Reversed, "Entry No.")
    }
}