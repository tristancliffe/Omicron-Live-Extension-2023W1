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
                }
                field(InvoicedHours; Rec.InvoicedHours)
                {
                    ApplicationArea = All;
                    Visible = true;
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
                {
                    ApplicationArea = All;
                    Visible = true;
                    Caption = 'Total Cost, £';
                }
                field(InvoicedValue; Rec.InvoicedValue)
                {
                    ApplicationArea = All;
                    Visible = true;
                    Caption = 'Total Invoiced, £';
                }
                field(ProfitToDate; -(Rec.TotalValue + Rec.InvoicedValue))
                { ApplicationArea = All; Visible = true; Caption = 'Profit to date, £'; ToolTip = 'The profit made so far'; }
            }
        }
    }
}