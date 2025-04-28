pageextension 50154 PurchaseQuoteListExt extends "Purchase Quotes"
{
    layout
    {
        moveafter("Buy-from Vendor Name"; "Your Reference", "Document Date")
        modify("Your Reference")
        {
            ApplicationArea = All;
            Caption = 'Our reference';
            ToolTip = 'Add our reference here so we know something about the order';
            Visible = true;
            Editable = true;
        }
        modify("Document Date")
        { Visible = true; }
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
        movebefore("Document Date"; Status)
        modify(Status)
        { Visible = true; }
        modify("Location Code")
        { Visible = false; }
        addbefore(Control1901138007)
        {
            part(PurchaseOrderDetailFactbox; "Purchase Order Detail Factbox") { ApplicationArea = Basic, Suite; SubPageLink = "No." = field("No."); }
        }
        addafter(Control1901138007)
        {
            part(VendorHistBuyFromFactBox; "Vendor Hist. Buy-from FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = field("Buy-from Vendor No."),
                              "Date Filter" = field("Date Filter");
            }
        }
    }
    actions
    {
        addlast("&Quote")
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
