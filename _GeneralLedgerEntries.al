pageextension 50186 GenLedgerEntriesExt extends "General Ledger Entries"
{
    AboutTitle = 'General Ledger Colours';
    AboutText = 'The colours on the list show if an amount is negative (**red**) or positive (**black**).';
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
        addafter("VAT Reporting Date")
        {
            field(Comment; Rec.Comment)
            { ApplicationArea = All; }
        }
    }

    var
        BalanceColour: Text;

    local procedure SetBalanceColours()
    begin
        BalanceColour := 'Standard';
        if Rec.Amount < 0 then BalanceColour := 'Attention'
    end;

    trigger OnAfterGetRecord()
    begin
        SetBalanceColours();
    end;
}