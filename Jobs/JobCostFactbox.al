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
                {
                    ApplicationArea = All;
                    Visible = true;
                }
                field(InvoicedHours; Rec.InvoicedHours)
                {
                    ApplicationArea = All;
                    Visible = true;
                }
                field(ToInvoice; Rec.TotalHours + Rec.InvoicedHours) { ApplicationArea = All; Visible = true; Caption = 'To be invoiced'; ToolTip = 'The number of hours left to invoice'; }
                field(ToInvoicePrice; Rec.ToInvoice)
                {
                    ApplicationArea = All;
                    Caption = 'Value to invoice';
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
                field(ProfitToDate; -(Rec.TotalValue + Rec.InvoicedValue)) { ApplicationArea = All; Visible = true; Caption = 'Profit to date, £'; ToolTip = 'The profit made so far'; StyleExpr = ProfitStyle; }
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