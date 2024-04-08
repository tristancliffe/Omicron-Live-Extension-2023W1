pageextension 50228 VendorHistoryFactbox extends "Vendor Hist. Buy-from FactBox"
{
    layout
    {
        modify(CueQuotes)
        { StyleExpr = QuoteStyle; }
        modify(CueBlanketOrders)
        { StyleExpr = BlanketStyle; }
        modify(CueOrders)
        { StyleExpr = OrderStyle; }
        modify(CueInvoices)
        { StyleExpr = InvoiceStyle; }
        modify(CueReturnOrders)
        { StyleExpr = ReturnStyle; }
        modify(CueCreditMemos)
        { StyleExpr = CreditStyle; }
    }

    var
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
    end;
}