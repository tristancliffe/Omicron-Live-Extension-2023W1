pageextension 50239 "Shopify Order Page" extends "Shpfy Order"
{
    actions
    {
        addafter(CreateSalesDocument)
        {
            action(CustomerCard)
            {
                ApplicationArea = All;
                Caption = 'Customer Card';
                Image = Customer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Open customer card.';
                RunObject = page "Customer Card";
                RunPageLink = "No." = field("Sell-to Customer No.");
            }
        }
    }
}