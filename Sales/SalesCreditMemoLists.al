pageextension 50217 SalesCreditMemoListExt extends "Sales Credit Memos"
{
    layout
    {
        modify("Sell-to Customer No.")
        {
            AboutTitle = 'Sales Order Colours';
            AboutText = 'Orders that have *completely shipped* are shown in **bold RED**. If *partially invoiced* they are shown in **bold GREEN**. If some other condition exists they are shown in **BLUE**. *Released* orders are shown as **RED**. Pre-paid invoices are shown in **YELLOW**. Other orders are shown as **BLACK**.';
        }
        modify(Status)
        { AboutTitle = 'Order Status'; AboutText = '**Open** means that the order is *NOT YET FINALISED*. This should mean the order hasn'' been placed, and can be modified. **Released** means that the order has been sent to the supplier, and whilst prices might change, the order is *essentially fixed*. **Pending Prepayment** means a prepayment invoice has been posted.'; }
        modify("External Document No.")
        { Visible = false; }
        modify("Location Code")
        { Visible = false; }
        modify("Sell-To Contact")
        { Visible = false; }
        addafter("Sell-to Customer Name")
        {
            field("Order Date"; Rec."Order Date")
            { ApplicationArea = All; }
            field("Your Reference"; Rec."Your Reference")
            { ApplicationArea = All; Width = 14; }
        }
        addafter("Your Reference")
        {
            field("Order Notes1"; Rec."Order Notes")
            { ApplicationArea = All; }
        }
        moveafter("Sell-to Customer Name"; Amount, Status)
        modify("Document Date")
        { Visible = false; }
    }
    actions
    {
        addlast(CreditMemo)
        {
            action(CustomerInvoices)
            {
                ApplicationArea = All;
                Caption = 'Invoices';
                ToolTip = 'Open a list of posted invoices for this customer';
                Image = SalesInvoice;
                Scope = Repeater;
                RunObject = page "Posted Sales Invoices";
                RunPageLink = "Sell-to Customer No." = field("Sell-to Customer No.");
            }
            action(CustomerCredits)
            {
                ApplicationArea = All;
                Caption = 'Credit Memos';
                ToolTip = 'Open a list of posted credit memos for this customer';
                Image = SalesCreditMemo;
                Scope = Repeater;
                RunObject = page "Posted Sales Credit Memos";
                RunPageLink = "Sell-to Customer No." = field("Sell-to Customer No.");
            }
            action(CustomerLedger)
            {
                ApplicationArea = All;
                Caption = 'Ledger';
                Tooltip = 'Open the customer ledger entries list for this customer';
                image = LedgerEntries;
                Scope = Repeater;
                RunObject = page "Customer Ledger Entries";
                RunPageLink = "Customer No." = field("Sell-to Customer No.");
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        Rec.Ascending(false);
    end;
}