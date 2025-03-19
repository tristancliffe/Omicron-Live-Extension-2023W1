tableextension 50112 ProjectManagerCueExt extends "Job Cue"
{
    fields
    {
        field(50100; OngoingJobs; Integer)
        {
            CalcFormula = count(Job where(Status = filter(Quote | Planning | Open | Paused | Finished)));
            // Rec.SetFilter("Status", 'Planning|Quote|Open|Paused|Finished');
            Caption = 'Ongoing Projects';
            FieldClass = FlowField;
            ToolTip = 'Specifies number of currently active (Open) projects';
        }
        field(50101; OpenTimeSheetsCue; Integer)
        {
            CalcFormula = count("Time Sheet Header");
            Caption = 'Active Time Sheets';
            FieldClass = FlowField;
            ToolTip = 'Number of active Time Sheets';
        }
        field(50102; ActiveTimeSheetsCue; Integer)
        {
            CalcFormula = count("Time Sheet Header" where("Quantity Approved" = filter('<32'),
                                                          Quantity = filter('>0.25')));
            Caption = 'Active Time Sheets';
            FieldClass = FlowField;
            ToolTip = 'Number of timesheets not submitted';
        }
        field(50103; HoursThisMonth; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Job Planning Line".Quantity where("Unit of Measure Code" = const('HOUR'),
                                                                "Planning Date" = filter('-30D..Today')));
            Caption = 'Hours Last Month';
            ToolTip = 'Number of approved/journalled hours in the last 30 days, including Admin. For 6 people one might expect 920 hours or more.';
        }
        field(50104; ChargeableThisMonth; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Job Planning Line".Quantity where("Unit of Measure Code" = const('HOUR'),
                                                                "Planning Date" = filter('-30D..Today'),
                                                                "Line Type" = filter(Billable)));
            Caption = 'Chargeable Hours Last Month';
            ToolTip = 'Number of approved/journalled hours that can be charged from the last 30 days, excluding Admin. For 6 people one might expect 644 or more.';
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
            ToolTip = 'The amount that can be currently be invoiced from all Active projects - check stock and time sheets are up to date before doing so.';
        }
        field(50106; "OpenTimeSheetHours"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Open hours not submitted or approved';
            CalcFormula = sum("Time Sheet Detail".Quantity where(Status = filter(Open | Submitted)));
            DecimalPlaces = 0 : 2;
            ToolTip = 'Number of ''Open'' or ''Submitted'' hours in timesheets, not approved';
        }
        field(50107; "Job Stock Outstanding"; Integer)
        {
            FieldClass = FlowField;
            Caption = 'Job Stock Used';
            ToolTip = 'Stock used on job that hasn''t been entered.';
            CalcFormula = count("Stock Used" where(Entered = const(false)));
        }
    }
}