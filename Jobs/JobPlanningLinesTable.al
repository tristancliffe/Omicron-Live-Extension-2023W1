tableextension 50107 JobPlanningLinesExt extends "Job Planning Line"
{
    fields
    {
        field(50100; "Work Done"; Text[700])
        {
            Caption = 'Work Done';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies information in addition to the description.';
        } //!OptimizeForTextSearch = true; }
        field(50101; "InvoicePrice"; Decimal)
        { Caption = 'Price to Invoice'; DataClassification = CustomerContent; }
        field(50102; "InvoiceCost"; Decimal)
        { Caption = 'Cost for Invoice'; DataClassification = CustomerContent; }
        field(50103; "VAT"; Decimal)
        { Caption = 'VAT at 20%'; DataClassification = CustomerContent; }
        field(50104; "InvoicePriceInclVAT"; Decimal)
        { Caption = 'Invoice Price Incl. VAT'; DataClassification = CustomerContent; }
    }

    trigger OnModify()
    begin
        if ((rec."Line Type" = Rec."Line Type"::Billable) or (rec."Line Type" = Rec."Line Type"::"Both Budget and Billable")) then begin
            Rec.Validate(InvoicePrice, round((Rec."Unit Price (LCY)" * Rec."Qty. to Transfer to Invoice") - "Line Discount Amount (LCY)", 0.01));
            Rec.Validate(InvoiceCost, round(Rec."Total Cost", 0.01));
            Rec.Validate(VAT, round(Rec.InvoicePrice * 0.2, 0.01));
            Rec.Validate(InvoicePriceInclVAT, round(Rec.InvoicePrice + Rec.VAT, 0.01));
        end;
    end;
}