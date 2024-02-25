// Extends the "Sales Hist. Sell-to FactBox" page
// The new field is called "No. of Jobs".
// The field shows the value of the "No. of Jobs" field from the underlying data source ("Rec.").
// The field has a custom caption of "Ongoing Jobs".
// The field has a tooltip that explains that it shows the number of ongoing jobs for the customer.
// The field is linked to a drilldown page with ID "Job List".
pageextension 50158 CustomerCueFactboxExt extends "Sales Hist. Sell-to FactBox"
{
    layout
    {
        addlast(Control2)
        {
            field("No. of Jobs"; Rec."No. of Jobs")
            {
                ApplicationArea = Suite;
                Caption = 'Ongoing Jobs';
                DrillDownPageID = "Job List";
                ToolTip = 'Specifies the number of jobs ongoing for the customer.';
            }
            field("No. of Completed Jobs"; Rec."No. of Completed Jobs")
            {
                ApplicationArea = Suite;
                Caption = 'Completed Jobs';
                DrillDownPageID = "Completed Job List";
                ToolTip = 'Specifies the number of jobs completed for the customer.';
            }
        }
    }
}