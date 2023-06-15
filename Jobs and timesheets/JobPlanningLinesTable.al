tableextension 50107 JobPlanningLinesExt extends "Job Planning Line"
{
    fields
    {
        field(50100; "Work Done"; Text[700])
        {
            Caption = 'Work Done';
            DataClassification = CustomerContent;
        }
        field(50101; "InvoicePrice"; Decimal)
        {
            Caption = 'Invoice Price';
            DataClassification = CustomerContent;
        }
        field(50102; "InvoiceCost"; Decimal)
        {
            Caption = 'Invoice Cost';
            DataClassification = CustomerContent;
        }
        field(50103; "VAT"; Decimal)
        {
            Caption = 'VAT at 20%';
            DataClassification = CustomerContent;
        }
        field(50104; "InvoicePriceInclVAT"; Decimal)
        {
            Caption = 'Invoice Price Incl. VAT';
            DataClassification = CustomerContent;
        }
    }
}