tableextension 50128 "Gen. Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(50100; SumOfLines; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Gen. Journal Line"."Amount (LCY)" where("Journal Template Name" = field("Journal Template Name"),
                                                                       "Journal Batch Name" = field("Journal Batch Name")));
            ToolTip = 'Total Amount (LCY) of the lines in the current journal batch.';
        }
    }
}