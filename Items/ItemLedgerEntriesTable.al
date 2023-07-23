tableextension 50117 ItemLedgerEntryTableExt extends "Item Ledger Entry"
{
    fields
    {
        field(50100; ReasonCode; Code[10])
        { Caption = 'Reason Code'; }
        field(50101; CreatedByFlow; Code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(User."User Name" where("User Security ID" = field(SystemCreatedBy)));
        }
    }
}