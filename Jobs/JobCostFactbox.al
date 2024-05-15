pageextension 50196 JobCostFactboxExt extends "Job Cost Factbox"
{
    layout
    {
        addafter("No.")
        {
            group(JobHours)
            {
                Caption = 'Project Hours';
                field(TotalHours; Rec.TotalHours)
                { ApplicationArea = All; Visible = true; ToolTip = 'The total number of HOURS entered against the project, regardless of adjustments and invoicing'; }
                field(InvoicedHours; Rec.InvoicedHours)
                { ApplicationArea = All; Visible = true; ToolTip = 'The total number of INVOICED HOURS entered against the project'; }
                field(ToInvoice; Rec.TotalHours + Rec.InvoicedHours)
                { ApplicationArea = All; Visible = true; Caption = 'To be invoiced'; ToolTip = 'The number of hours left to invoice'; }
                field(ToInvoicePrice; Rec.ToInvoice)
                { ApplicationArea = All; Caption = 'Value to invoice'; Tooltip = 'This is the value due to be invoiced, calculated from Project Planning Lines.'; }
            }
            group(JobCosts)
            {
                Caption = 'Project Profitability';
                field(TotalValue; Rec.TotalValue)
                { ApplicationArea = All; Visible = true; Caption = 'Total Cost, £'; ToolTip = 'The value committed to the project so far.'; }
                field(InvoicedValue; Rec.InvoicedValue)
                { ApplicationArea = All; Visible = true; Caption = 'Total Invoiced, £'; ToolTip = 'The value invoiced to date.'; }
                field(ProfitToDate; -(Rec.TotalValue + Rec.InvoicedValue))
                { ApplicationArea = All; Visible = true; Caption = 'Profit to date, £'; ToolTip = 'The profit made so far'; StyleExpr = ProfitStyle; }
            }
        }
        addafter("Budget Cost")
        {
            group("Budget Price")
            {
                Caption = 'Budgeted Price';
                field("Budgeted Price"; Rec."Budgeted Price")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    Style = Strong;
                }
            }
        }
    }
    var
        ProfitStyle: Text;

    trigger OnAfterGetRecord()
    begin
        ProfitStyle := SetProfitStyle();
    end;

    procedure SetProfitStyle(): Text
    begin
        if (Rec.TotalValue + Rec.InvoicedValue) < -100 then
            exit('Favorable')
        else
            if (Rec.TotalValue + Rec.InvoicedValue) > 100 then
                exit('Unfavorable');
        exit('');
    end;
}