pageextension 50197 JobWIP_RecognitionFactBoxExt extends "Job WIP/Recognition FactBox"
{
    layout
    {
        addafter("No.")
        {
            group(JobDetails)
            {
                Caption = 'Job Details';

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
                field("Vehicle Reg"; Rec."Vehicle Reg")
                {
                    ApplicationArea = All;
                    Caption = 'Vehicle Registration';
                }
            }
        }
    }
}