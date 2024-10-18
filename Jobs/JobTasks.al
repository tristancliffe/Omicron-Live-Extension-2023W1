tableextension 50126 "Job Task Extension" extends "Job Task"
{
    fields
    {
        field(50100; "Usage (Total Hours)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("Job Ledger Entry".Quantity where("Job No." = field("Job No."),
                                                                            "Job Task No." = field("Job Task No."),
                                                                            "Entry Type" = const(Usage),
                                                                            "Line Type" = const(Billable),
                                                                            "Unit of Measure Code" = filter('HOUR')));
            Caption = 'Hours';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50101; ToInvoice; Decimal)
        {
            Caption = 'To Invoice';
            AutoFormatExpression = '£<precision, 2:2><standard format, 0>';
            AutoFormatType = 1;
            DecimalPlaces = 2 : 2;
            FieldClass = FlowField;
            CalcFormula = sum("Job Planning Line".InvoicePrice where("Job No." = field("Job No."),
                                                                    "Job Task No." = field("Job Task No."),
                                                                    "Line Type" = filter("Billable" | "Both Budget and Billable"),
                                                                    "Qty. Transferred to Invoice" = filter('0')));
            ToolTip = 'Shows the amount to be invoiced at the current time';
        }
    }
}