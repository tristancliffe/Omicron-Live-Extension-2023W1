page 50111 "Stock Card Page"
{
    ApplicationArea = All;
    Caption = 'Stock Card';
    PageType = Document;
    SourceTable = Job;
    Editable = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    Editable = false;
                    Importance = Additional;
                }
            }
            part(StockUsedForm; "Stock Used Subform")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Job No." = field("No."); //, Entered = filter(False);
                UpdatePropagation = Both;
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(YourStockCard)
            {
                Caption = 'Your Stock Card';
                Image = ItemLedger;
                ApplicationArea = All;
                RunObject = Page "Stock Entry List";
                RunPageLink = "Resource No." = filter('%USER');
                ToolTip = 'Opens your stock card (for all projects)';
                Visible = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
            }
        }
    }
}