pageextension 50117 SalesQuoteList extends "Sales Quotes"
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
            { ApplicationArea = All; StyleExpr = OldQuoteStyle; }
            field("Your Reference50380"; Rec."Your Reference")
            { ApplicationArea = All; Width = 14; }
        }
        addafter("Your Reference50380")
        {
            field("Order Notes1"; Rec."Order Notes")
            { ApplicationArea = All; }
        }
        moveafter("Sell-to Customer Name"; Amount, Status)
        moveafter("Assigned User ID"; "Quote Valid Until Date")
        modify("Quote Valid Until Date")
        {
            Visible = true;
            ApplicationArea = All;
            Caption = 'Valid Until';
        }
        modify(Status)
        { Visible = true; }
        modify("Posting Date")
        { Visible = false; }
        modify("Requested Delivery Date")
        { Visible = false; }
    }

    actions
    {
        addlast(Create)
        {
            separator(TJPC)
            { }
            action(ArchiveQuote)
            {
                ApplicationArea = Suite;
                Caption = 'Archi&ve Document';
                Image = Archive;
                ToolTip = 'Send the document to the archive, for example because it is too soon to delete it. Later, you delete or reprocess the archived document.';

                trigger OnAction()
                begin
                    ArchiveManagement.ArchiveSalesDocument(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref(ArchiveQuote_Promoted; ArchiveQuote)
            { }
        }
        addlast("&Quote")
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

    var
        ArchiveManagement: Codeunit ArchiveManagement;

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        Rec.Ascending(false);
    end;

    trigger OnAfterGetRecord()
    begin
        OldQuoteStyle := SetOldQuoteStyle();
    end;

    procedure SetOldQuoteStyle(): Text;
    begin
        if (Rec."Quote Valid Until Date" <> 0D) and (Rec."Quote Valid Until Date" < CalcDate('-12M', WorkDate())) then
            exit('Unfavorable');
        exit('');
    end;

    var
        OldQuoteStyle: Text;
}