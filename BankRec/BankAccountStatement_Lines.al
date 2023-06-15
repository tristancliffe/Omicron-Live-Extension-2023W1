pageextension 50189 BankStatementLinesExt extends "Bank Account Statement Lines"
{
    layout
    {
        addlast(Control16)
        {
            field(SumAmountApplied; TotalApplied)
            {
                ApplicationArea = All;
                Caption = 'Sum of Applied';
                ToolTip = 'This is the sum of the ''Amount Applied'' column. Added on 6th June 2023';
                Editable = false;
                Style = Ambiguous;
            }
        }
    }
    var
        TotalApplied: Decimal;

    trigger OnAfterGetRecord()
    begin
        UpdateTotalApplied();
    end;

    procedure UpdateTotalApplied()
    var
        BankStatement: Record "Bank Account Statement Line";
    begin
        TotalApplied := 0;
        BankStatement.Reset();
        BankStatement.CopyFilters(Rec);
        BankStatement.CalcSums("Applied Amount");
        TotalApplied := BankStatement."Applied Amount";
    end;
}