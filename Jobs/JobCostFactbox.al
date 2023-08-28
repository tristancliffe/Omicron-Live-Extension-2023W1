pageextension 50196 JobCostFactboxExt extends "Job Cost Factbox"
{
    layout
    {
        addafter("No.")
        {
            group(JobHours)
            {
                Caption = 'Job Hours';
                field(TotalHours; Rec.TotalHours)
                { ApplicationArea = All; Visible = true; ToolTip = 'The total number of HOURS entered against the job, regardless of adjustments and invoicing'; }
                field(InvoicedHours; Rec.InvoicedHours)
                { ApplicationArea = All; Visible = true; ToolTip = 'The total number of INVOICED HOURS entered against the job'; }
                field(ToInvoice; Rec.TotalHours + Rec.InvoicedHours)
                { ApplicationArea = All; Visible = true; Caption = 'To be invoiced'; ToolTip = 'The number of hours left to invoice'; }
            }
            group(JobCosts)
            {
                Caption = 'Job Values';
                field(TotalValue; Rec.TotalValue)
                { ApplicationArea = All; Visible = true; Caption = 'Total Spent, £'; ToolTip = 'The value committed to the job so far.'; }
                field(InvoicedValue; Rec.InvoicedValue)
                { ApplicationArea = All; Visible = true; Caption = 'Total Invoiced, £'; ToolTip = 'The value invoiced to date.'; }
                field(ValueToInvoice; Rec.TotalValue + Rec.InvoicedValue)
                { ApplicationArea = All; Visible = true; Caption = 'To be invoiced, £'; ToolTip = 'The value left to invoice'; }
            }
        }
    }
}