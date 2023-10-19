tableextension 50112 ProjectManagerExt extends "Job Cue"
{
    fields
    {
        field(50100; OngoingJobs; Integer)
        {
            CalcFormula = count(Job where(Status = filter(Open)));
            Caption = 'Ongoing Jobs';
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
            CalcFormula = count("Time Sheet Header" where("Quantity Approved" = filter('<38')));
            Caption = 'Active Time Sheets';
            FieldClass = FlowField;
        }
        field(50103; HoursThisMonth; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Job Planning Line".Quantity where("Unit of Measure Code" = const('HOUR'), "Planning Date" = filter('-1M..Today')));
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
    }
}