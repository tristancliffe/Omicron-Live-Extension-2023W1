tableextension 50119 PostedSalesHeaderExt extends "Sales Invoice Header"
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