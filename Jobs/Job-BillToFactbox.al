pageextension 50238 CustomerBillToFactboxExt extends "Sales Hist. Bill-to FactBox"
{
    layout
    {
        modify(NoofQuotesTile) { StyleExpr = QuoteStyle; }
        modify(NoofBlanketOrdersTile) { StyleExpr = BlanketStyle; }
        modify(NorOfOrdersTile) { StyleExpr = OrderStyle; }
        modify(NoofInvoicesTile) { StyleExpr = InvoiceStyle; }
        modify(NoofCreditMemosTile) { StyleExpr = CreditStyle; }
        modify(NoofReturnOrdersTile) { StyleExpr = ReturnStyle; }

        addlast(Control23)
        {
            field("No. of Projects"; Rec."No. of Jobs")
            {
                ApplicationArea = Suite;
                Caption = 'Ongoing Projects';
                DrillDownPageID = "Job List";
                StyleExpr = CurrentProjectsStyle;
            }
            field("No. of Completed Projects"; Rec."No. of Completed Jobs")
            {
                ApplicationArea = Suite;
                Caption = 'Completed Projects';
                DrillDownPageID = "Completed Job List";
            }
        }
    }

    var
        CurrentProjectsStyle: Text;
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
            CurrentProjectsStyle := 'Unfavorable';
    end;
}