tableextension 50122 PurchaseReceiptLineTableExt extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50100; "Shelf No."; Code[10])
        {
            Caption = 'Shelf No.';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Item."Shelf No." where("No." = field("No.")));
        }
    }
}