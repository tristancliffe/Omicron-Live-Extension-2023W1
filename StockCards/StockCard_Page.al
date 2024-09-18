page 50111 "Stock Card Page"
{
    ApplicationArea = All;
    Caption = 'Stock Card';
    PageType = Card;
    SourceTable = Job;

    layout
    {
        area(Content)
        {
            group(General)
            { }

            part(StockUsedForm; "Stock Used Subform")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Job No." = field("No.");
                UpdatePropagation = Both;
            }
        }
    }
}