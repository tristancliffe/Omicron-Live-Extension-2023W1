tableextension 50119 PostedSalesHeaderExt extends "Sales Invoice Header"
{
    fields
    {
        field(50100; "Customer Notes"; Text[2000])
        {
            ObsoleteReason = 'Not needed anymore';
            ObsoleteState = Removed;
            Caption = 'Customer Notes';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50101; "Order Notes"; Text[250])
        {
            Caption = 'Order Notes';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}