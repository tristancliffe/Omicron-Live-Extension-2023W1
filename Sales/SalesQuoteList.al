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
            { ApplicationArea = All; }
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
}