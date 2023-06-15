tableextension 50111 ItemVendorTableExt extends "Item Vendor"
{
    fields
    {
        field(50100; ItemDescription; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }
}