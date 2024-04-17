tableextension 50112 ProjectManagerCueExt extends "Job Cue"
{
    fields
    {
        field(50100; OngoingJobs; Integer)
        {
            CalcFormula = count(Job where(Status = filter(Open)));
            Caption = 'Ongoing Projects';
            FieldClass = FlowField;
        }
        field(50101; OpenTimeSheetsCue; Integer)
        {
            CalcFormula = count("Time Sheet Header");
            Caption = 'Active Time Sheets';
            FieldClass = FlowField;
        }
        field(50102; ActiveTimeSheetsCue; Integer)
        {
            CalcFormula = count("Time Sheet Header" where("Quantity Approved" = filter('<32'),
                                                          Quantity = filter('>0.25')));
            Caption = 'Active Time Sheets';
            FieldClass = FlowField;
        }
        field(50103; HoursThisMonth; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Job Planning Line".Quantity where("Unit of Measure Code" = const('HOUR'),
                                                                "Planning Date" = filter('-1M..Today')));
            Caption = 'Hours Last Month';
        }
        field(50104; ChargeableThisMonth; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Job Planning Line".Quantity where("Unit of Measure Code" = const('HOUR'),
                                                                "Planning Date" = filter('-1M..Today'),
                                                                "Line Type" = filter(Billable)));
            Caption = 'Chargeable Hours Last Month';
        }
        field(50105; "Invoiceable"; Decimal)
        {
            FieldClass = FlowField;
            AutoFormatExpression = '£<precision, 0:0><standard format, 0>';  //GetAmountFormat();
            AutoFormatType = 11;
            Caption = 'Invoiceable Projects';
            CalcFormula = sum("Job Planning Line".InvoicePrice where("Line Type" = filter("Billable" | "Both Budget and Billable"),
                                                                    "Qty. Transferred to Invoice" = filter('0'),
                                                                    "Qty. to Transfer to Invoice" = filter('>0'),
                                                                    Status = filter("Order")));
        }
        field(50106; "OpenTimeSheetHours"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Open hours not submitted or approved';
            CalcFormula = sum("Time Sheet Detail".Quantity where(Status = filter(Open | Submitted)));
            //sum("Time Sheet Header"."Quantity Open");
        }
    }
}