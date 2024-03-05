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
        NegativeAmounts := UpdateNegativeStyle();
    end;

    procedure UpdateNegativeStyle(): Text
    begin
        if Rec.Difference < 0 then
            exit('Attention');
        exit('');
    end;
}