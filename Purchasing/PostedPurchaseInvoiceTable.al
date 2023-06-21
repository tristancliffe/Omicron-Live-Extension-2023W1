tableextension 50120 PostedPurchInvHeader extends "Purch. Inv. Header"
{
    fields
    {
        field(50100; "Order Notes"; Text[250])
        {
            Caption = 'Order Notes';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}