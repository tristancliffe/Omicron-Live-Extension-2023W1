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
                field(ToInvoicePrice; Rec.ToInvoice)
                { ApplicationArea = All; Caption = 'Value to invoice'; Tooltip = 'This is the value due to be invoiced, calculated from Job Planning Lines.'; }
            }
            group(JobCosts)
            {
                Caption = 'Job Profitability';
                field(TotalValue; Rec.TotalValue)
                { ApplicationArea = All; Visible = false; Caption = 'Total Cost, £'; ToolTip = 'The value committed to the job so far.'; }
                field(InvoicedValue; Rec.InvoicedValue)
                { ApplicationArea = All; Visible = false; Caption = 'Total Invoiced, £'; ToolTip = 'The value invoiced to date.'; }
                field(ProfitToDate; -(Rec.TotalValue + Rec.InvoicedValue))
                { ApplicationArea = All; Visible = true; Caption = 'Profit to date, £'; ToolTip = 'The profit made so far'; StyleExpr = ProfitStyle; }
            }
        }
    }
    var
        ProfitStyle: Text;

    trigger OnAfterGetRecord()
    begin
        ProfitStyle := 'Standard';
        if (Rec.TotalValue + Rec.InvoicedValue) < -100 then
            ProfitStyle := 'Favorable'
        else
            if (Rec.TotalValue + Rec.InvoicedValue) > 100 then
                ProfitStyle := 'Unfavorable';
    end;
}