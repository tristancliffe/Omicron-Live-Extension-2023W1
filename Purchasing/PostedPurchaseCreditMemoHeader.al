tableextension 50215 PostedPurchCreditMemoHeaderExt extends "Purch. Cr. Memo Hdr."
{
    DataCaptionFields = "No.", "Buy-from Vendor Name", "Amount Including VAT";

    fields
    {
        field(50100; "Order Notes"; Text[1000]) //* Changed from order notes [250] to Vendor notes [1000] to enable invoice posting.
        {
            ObsoleteReason = 'Mistake in field numbering';
            ObsoleteState = Removed;
            Caption = 'Vendor Notes';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50101; "Order Vendor Notes"; Text[1000]) //* Changed from Vendor notes [1000] to order notes [1000] to enable invoice posting
        {
            Caption = 'Order Notes';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}