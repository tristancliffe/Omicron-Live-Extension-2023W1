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
    }
}