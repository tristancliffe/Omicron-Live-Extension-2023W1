pageextension 50243 Shopify_PaymentTransactions extends "Shpfy Payment Transactions"
{
    layout
    {
        addbefore(InvoiceNo)
        {
            field(CustomerNo; CustomerNo)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customer';
                ToolTip = 'Specifies the customer associated with the payment transaction.';

                trigger OnDrillDown()
                var
                    Customer: Record Customer;
                begin
                    if Customer.Get(CustomerNo) then
                        PAGE.RUN(PAGE::"Customer Card", Customer);
                end;
            }
        }
    }
    var
        Invoice: Record "Sales Invoice Header";
        CustomerNo: Code[20];

    trigger OnAfterGetRecord()
    begin
        CustomerNo := '';
        if Invoice.Get(Rec."Invoice No.") then
            CustomerNo := Invoice."Sell-to Customer No.";
    end;
}
