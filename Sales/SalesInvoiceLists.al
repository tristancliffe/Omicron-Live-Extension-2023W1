pageextension 50116 SalesInvoiceList extends "Sales Invoice List"
{
    layout
    {
        modify("External Document No.")
        { Visible = false; }
        modify("Location Code")
        { Visible = false; }
        modify("Sell-To Contact")
        { Visible = false; }
        addafter("Sell-to Customer Name")
        {
            field("Order Date98002"; Rec."Order Date")
            { ApplicationArea = All; }
            field("Your Reference50380"; Rec."Your Reference")
            { ApplicationArea = All; Width = 14; }
        }
        addafter("Your Reference50380")
        {
            field("Order Notes1"; Rec."Order Notes")
            { ApplicationArea = All; }
        }
        moveafter("Sell-to Customer Name"; Amount)
        addafter(Amount)
        {
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Incl. VAT';
            }
        }
        moveafter(Amount; Status)
        modify(Status)
        { Visible = true; }
        modify("Posting Date")
        { Visible = false; }
        modify("Due Date")
        { Visible = false; }
    }
    actions
    {
        addlast("&Invoice")
        {
            action(PostedInvoices)
            {
                ApplicationArea = all;
                Caption = 'Posted Invoices';
                ToolTip = 'Opens the list of posted sales invoices';
                Image = PurchaseInvoice;
                RunObject = Page "Posted Sales Invoices";
            }
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
        addlast(Promoted)
        {
            actionref(PostedInvoices_Promoted; PostedInvoices)
            { }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        Rec.Ascending(false);
    end;
}