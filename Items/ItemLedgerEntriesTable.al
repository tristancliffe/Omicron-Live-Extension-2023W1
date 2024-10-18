tableextension 50117 ItemLedgerEntryTableExt extends "Item Ledger Entry"
{
    fields
    {
        field(50100; ReasonCode; Code[10])
        {
            Caption = 'Reason Code';
            ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
        }
        field(50101; CreatedByFlow; Code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(User."User Name" where("User Security ID" = field(SystemCreatedBy)));
            ToolTip = 'Shows who created this entry.';
        }
    }
}