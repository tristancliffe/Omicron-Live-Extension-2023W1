pageextension 50185 BankRecLedgerLinesExt extends "Apply Bank Acc. Ledger Entries"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Document Date"; Rec."Document Date")
            { ApplicationArea = All; Visible = true; }
        }
        modify("Check Ledger Entries")
        { Visible = false; }
        modify("External Document No.")
        { Visible = false; }
    }
}