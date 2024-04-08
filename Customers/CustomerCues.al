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
        modify(NoofQuotesTile)
        { StyleExpr = QuoteStyle; }
        modify(NoofBlanketOrdersTile)
        { StyleExpr = BlanketStyle; }
        modify(NoofOrdersTile)
        { StyleExpr = OrderStyle; }
        modify(NoofInvoicesTile)
        { StyleExpr = InvoiceStyle; }
        modify(NoofCreditMemosTile)
        { StyleExpr = CreditStyle; }
        modify(NoofReturnOrdersTile)
        { StyleExpr = ReturnStyle; }

        addlast(Control2)
        {
            field("No. of Jobs"; Rec."No. of Jobs")
            {
                ApplicationArea = Suite;
                Caption = 'Ongoing Jobs';
                DrillDownPageID = "Job List";
                ToolTip = 'Specifies the number of jobs ongoing for the customer.';
                StyleExpr = CurrentJobsStyle;
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

    var
        CurrentJobsStyle: Text;
        QuoteStyle: Text;
        BlanketStyle: Text;
        OrderStyle: Text;
        InvoiceStyle: Text;
        ReturnStyle: Text;
        CreditStyle: Text;

    trigger OnAfterGetRecord()
    begin
        SetStyles();
    end;

    local procedure SetStyles()
    begin
        if Rec."No. of Quotes" > 0 then
            QuoteStyle := 'Unfavorable';
        if rec."No. of Blanket Orders" > 0 then
            BlanketStyle := 'Unfavorable';
        if rec."No. of Orders" > 0 then
            OrderStyle := 'Unfavorable';
        if rec."No. of Invoices" > 0 then
            InvoiceStyle := 'Unfavorable';
        if rec."No. of Return Orders" > 0 then
            ReturnStyle := 'Unfavorable';
        if rec."No. of Credit Memos" > 0 then
            CreditStyle := 'Unfavorable';
        if Rec."No. of Jobs" > 0 then
            CurrentJobsStyle := 'Unfavorable';
    end;
}