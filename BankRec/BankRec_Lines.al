pageextension 50184 BankRecLinesExt extends "Bank Acc. Reconciliation Lines"
{
    layout
    {
        modify("Document No.")
        { Visible = false; }
        modify("Check No.")
        { Visible = false; }
        modify(Difference)
        { StyleExpr = NegativeAmounts; }
    }

    var
        NegativeAmounts: Text;

    trigger OnAfterGetRecord()
    begin
        UpdateNegativeStyle();
    end;

    procedure UpdateNegativeStyle()
    begin
        if Rec.Difference < 0 then
            NegativeAmounts := 'Attention'
        else
            NegativeAmounts := 'Standard';
    end;
}