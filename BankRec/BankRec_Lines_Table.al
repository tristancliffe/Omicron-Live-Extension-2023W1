tableextension 50125 "Bank Rec Lines Table Ext" extends "Bank Acc. Reconciliation Line"
{
    fields
    {
        field(50100; SumOfLines; Decimal)
        {
            Caption = 'Sum';
            ToolTip = 'This sums the lines on this bank reconciliation';
            FieldClass = FlowField;
            CalcFormula = sum("Bank Acc. Reconciliation Line"."Statement Amount" where("Statement No." = field("Statement No.")));
        }
    }
}