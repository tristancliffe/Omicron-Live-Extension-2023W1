pageextension 50197 JobWIP_RecognitionFactBoxExt extends "Job WIP/Recognition FactBox"
{
    layout
    {
        addafter("No.")
        {
            group(JobDetails)
            {
                Caption = 'Project Details';

                field(TotalHours; Rec.TotalHours)
                {
                    ApplicationArea = All;
                    Visible = true;
                    ToolTip = 'The total number of HOURS entered against the project, regardless of adjustments and invoicing';
                }
                field(InvoicedHours; Rec.InvoicedHours)
                {
                    ApplicationArea = All;
                    Visible = true;
                    ToolTip = 'The total number of INVOICED HOURS entered against the project';
                }
                field("Vehicle Reg"; Rec."Vehicle Reg")
                {
                    ApplicationArea = All;
                    Caption = 'Vehicle Registration';
                }
            }
            group(JobCosts)
            {
                Caption = 'Project Profitability';
                field(TotalValue; Rec.TotalValue)
                { ApplicationArea = All; Visible = true; Caption = 'Total Cost, £'; ToolTip = 'The value committed to the project so far.'; }
                field(InvoicedValue; Rec.InvoicedValue)
                { ApplicationArea = All; Visible = true; Caption = 'Total Invoiced, £'; ToolTip = 'The value invoiced to date.'; }
                field(ProfitToDate; -(Rec.TotalValue + Rec.InvoicedValue))
                { ApplicationArea = All; Visible = true; Caption = 'Profit to date, £'; ToolTip = 'The profit made so far'; }
            }
        }
    }
}