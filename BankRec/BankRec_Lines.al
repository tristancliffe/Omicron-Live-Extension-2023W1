pageextension 50184 BankRecLinesExt extends "Bank Acc. Reconciliation Lines"
{
    layout
    {
        modify("Document No.")
        { Visible = false; }
        modify("Check No.")
        { Visible = false; }
    }
}