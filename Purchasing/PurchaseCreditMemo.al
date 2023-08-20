pageextension 50110 PurchaseCreditExt extends "Purchase Credit Memo"
{
    layout
    {
        modify("Document Date")
        {
            Visible = true;
            Importance = Standard;
        }
        modify("VAT Reporting Date")
        {
            Visible = true;
            Importance = Standard;
        }
        modify("Buy-from Vendor No.")
        { Importance = Standard; }
        modify("Payment Method Code")
        { Importance = Standard; ShowMandatory = true; }
        modify("Currency Code")
        { Importance = Standard; }
    }
    actions
    {
        addlast("F&unctions")
        {
            action(PostedInvoices)
            {
                ApplicationArea = All;
                Image = PurchaseInvoice;
                Caption = 'Posted Credit Memos';
                RunObject = page "Posted Purchase Credit Memos";
                RunPageLink = "Buy-from Vendor No." = field("Buy-from Vendor No.");
                Description = 'Open list of posted purchase credit memos.';
                ToolTip = 'Opens the list of posted purchase credit memos.';
                Visible = true;
                Enabled = true;
            }
            action(VendorLedgerEntries)
            {
                ApplicationArea = All;
                Image = LedgerEntries;
                Caption = 'Vendor Ledger';
                RunObject = page "Vendor Ledger Entries";
                RunPageLink = "Vendor No." = field("Buy-from Vendor No.");
                Description = 'Open vendor ledger entries list for this vendor.';
                ToolTip = 'Opens the list of vendor ledger entries for this vendor.';
                Visible = true;
                Enabled = true;
            }
        }
        addlast(Category_Process)
        {
            actionref(VendorCard; Vendor)
            { }
            actionref(PostedInvoices_Promoted; PostedInvoices)
            { }
            actionref(VendorLedger_Promoted; VendorLedgerEntries)
            { }
            actionref(Statistics2; Statistics)
            { }
        }
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    Rec.Validate("Posting Date", Today);
                    Rec.Modify();
                end;
            end;
        }
        modify(PostAndPrint)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    Rec.Validate("Posting Date", Today);
                    Rec.Modify();
                end;
            end;
        }
        modify(PostAndNew)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    Rec.Validate("Posting Date", Today);
                    Rec.Modify();
                end;
            end;
        }
    }
}