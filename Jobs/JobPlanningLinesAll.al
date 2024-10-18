page 50104 "Job Planning Lines All"
{
    //AutoSplitKey = true;
    Caption = 'Project Planning Lines - All';
    // DataCaptionExpression = Caption();
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Job Planning Line";
    Editable = false;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Project No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the related project.';
                }
                field("Project Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the related project task.';
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the type of planning line.';
                }
                field("Planning Date"; Rec."Planning Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the date of the planning line. You can use the planning date for filtering the totals of the project, for example, if you want to see the scheduled usage for a specific month of the year.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a document number for the planning line.';
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
                    ApplicationArea = Jobs;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies a location code for an item.';
                    Visible = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of units of the resource, item, or general ledger account that should be specified on the planning line. If you later change the No., the quantity you have entered remains on the line.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the cost of one unit of the item or resource on the line.';
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total cost for the planning line. The total cost is in the project currency, which comes from the Currency Code field in the Job Card.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the amount that will be posted to the project ledger.';
                }
                field("Total Price"; Rec."Total Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total price in the project currency on the planning line.';
                    Visible = false;
                }
                field("Qty. Transferred to Invoice"; Rec."Qty. Transferred to Invoice")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity that has been transferred to a sales invoice or credit memo.';
                }
                field("Qty. to Transfer to Invoice"; Rec."Qty. to Transfer to Invoice")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity you want to transfer to the sales invoice or credit memo. The value in this field is calculated as Quantity - Qty. Transferred to Invoice.';
                }
                field("Qty. Invoiced"; Rec."Qty. Invoiced")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity that been posted through a sales invoice.';
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        Rec.DrillDownJobInvoices();
                    end;
                }
                field("Qty. to Invoice"; Rec."Qty. to Invoice")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity that remains to be invoiced. It is calculated as Quantity - Qty. Invoiced.';
                    Visible = false;
                }
                field(InvoicePrice; Rec.InvoicePrice)
                { ApplicationArea = All; BlankZero = true; }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if ((rec."Line Type" = Rec."Line Type"::Billable) or (rec."Line Type" = Rec."Line Type"::"Both Budget and Billable")) then begin
            Rec.Validate(InvoicePrice, round(Rec."Unit Price (LCY)" * Rec."Qty. to Transfer to Invoice", 0.01));
            Rec.Validate(InvoiceCost, round(Rec."Total Cost", 0.01));
            Rec.Validate(VAT, round(Rec.InvoicePrice * 0.2, 0.01));
            Rec.Validate(InvoicePriceInclVAT, round(Rec.InvoicePrice + Rec.VAT, 0.01));
            Rec.Modify();
        end;
    end;
}