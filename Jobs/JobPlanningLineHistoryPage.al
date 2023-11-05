page 50103 "Job Planning History"
{
    AutoSplitKey = true;
    Caption = 'Job Planning Line History';
    DataCaptionFields = "Job No.", "Job Task No.";
    //DataCaptionExpression = Caption();
    PageType = List;
    SourceTable = "Job Planning Line";
    Editable = False;
    //AnalysisModeEnabled = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the related job.';
                    //Visible = false;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the related job task.';
                }
                // field("Line Type"; Rec."Line Type")
                // {
                //     ApplicationArea = Jobs;
                //     ToolTip = 'Specifies the type of planning line.';
                // }
                field("Planning Date"; Rec."Planning Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the date of the planning line. You can use the planning date for filtering the totals of the job, for example, if you want to see the scheduled usage for a specific month of the year.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the type of account to which the planning line relates.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the account to which the resource, item or general ledger account is posted, depending on your selection in the Type field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the name of the resource, item, or G/L account to which this entry applies. You can change the description.';
                }
                field("Work Done"; Rec."Work Done")
                {
                    ApplicationArea = All;
                    AssistEdit = true;

                    trigger OnDrillDown()
                    begin
                        message(Rec."Work Done");
                    end;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of units of the resource, item, or general ledger account that should be specified on the planning line. If you later change the No., the quantity you have entered remains on the line.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                    //Visible = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
                    Width = 8;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the amount that will be posted to the job ledger.';
                    Width = 8;
                }
                field("Invoiced Amount (LCY)"; Rec."Invoiced Amount (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies, in local currency, the sales amount that was invoiced for this planning line.';
                    Width = 10;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Planning Date", "Line No.");
        Rec.Ascending(true);
    end;
}

