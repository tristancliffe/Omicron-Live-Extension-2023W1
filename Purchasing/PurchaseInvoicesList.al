pageextension 50156 PurchaseInvoiceListExt extends "Purchase Invoices"
{
    layout
    {
        moveafter("Buy-from Vendor Name"; "Your Reference", "Vendor Invoice No.", Amount, Status)
        addafter(Status)
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
        modify("Your Reference")
        {
            ApplicationArea = All;
            Caption = 'Our reference';
            ToolTip = 'Add our reference here so we know something about the order';
            Visible = true;
            Editable = true;
        }
        addafter(Amount)
        {
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = All;
                Caption = 'Amount incl. VAT';
                Visible = true;
            }
        }
        // addafter("Buy-from Vendor Name")
        // {
        //     field("Your Reference"; Rec."Your Reference")
        //     {
        //         ApplicationArea = All;
        //         Caption = 'Our reference';
        //         ToolTip = 'Add our reference here so we know something about the order';
        //         Visible = true;
        //         Editable = true;
        //     }
        // }
        modify("Vendor Authorization No.")
        { Visible = false; }
        modify("Assigned User ID")
        { Visible = true; }
        modify("Location Code")
        { Visible = false; }
        modify(Status)
        {
            ApplicationArea = All;
            Visible = true;
        }
    }
    actions
    {
        addlast("&Invoice")
        {
            action(PostedInvoices)
            {
                ApplicationArea = all;
                Caption = 'Posted Invoices';
                ToolTip = 'Opens the list of posted purchase invoices';
                Image = PurchaseInvoice;
                RunObject = Page "Posted Purchase Invoices";
            }
            action(VendorInvoices)
            {
                ApplicationArea = All;
                Caption = 'Invoices';
                ToolTip = 'Open a list of posted invoices for this vendor';
                Image = PurchaseInvoice;
                Scope = Repeater;
                RunObject = page "Posted Purchase Invoices";
                RunPageLink = "Buy-from Vendor No." = field("Buy-from Vendor No.");
            }
            action(VendorLedger)
            {
                ApplicationArea = All;
                Caption = 'Ledger';
                Tooltip = 'Open the vendor entries list for this vendor';
                image = LedgerEntries;
                Scope = Repeater;
                RunObject = page "Vendor Ledger Entries";
                RunPageLink = "Vendor No." = field("Buy-from Vendor No.");
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
        Rec.SetCurrentKey("Order Date", "No.");
        Rec.Ascending(false);
    end;
}