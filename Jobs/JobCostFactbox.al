pageextension 50196 JobCostFactboxExt extends "Job Cost Factbox"
{
    layout
    {
        addafter("No.")
        {
            field(TotalHours; Rec.TotalHours)
            {
                ApplicationArea = All;
                Visible = true;
                ToolTip = 'The total number of HOURS entered against the job, regardless of adjustments and invoicing';
            }
            field(InvoicedHours; Rec.InvoicedHours)
            {
                ApplicationArea = All;
                Visible = true;
                ToolTip = 'The total number of INVOICED HOURS entered against the job';
            }
        }
    }
}