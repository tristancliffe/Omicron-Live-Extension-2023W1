pageextension 50186 GenLedgerEntriesExt extends "General Ledger Entries"
{
    layout
    {
        moveafter("Posting Date"; Reversed)
        modify(Reversed)
        { Visible = true; }
        movelast(Control1; "User ID")
        modify("User ID")
        { Visible = true; }
        moveafter("External Document No."; "VAT Bus. Posting Group", "VAT Prod. Posting Group", "VAT Amount")
        modify("VAT Bus. Posting Group")
        { Visible = true; }
        modify("VAT Prod. Posting Group")
        { Visible = true; }
        modify("VAT Amount")
        { Visible = true; }
        modify(Amount)
        { StyleExpr = BalanceColour; }
    }

    var
        BalanceColour: Text;

    local procedure SetBalanceColours()
    begin
        BalanceColour := 'Standard';
        if Rec.Amount < 0 then BalanceColour := 'Ambiguous'
    end;

    trigger OnAfterGetRecord()
    begin
        SetBalanceColours();
    end;
}