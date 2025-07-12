pageextension 50143 ActivityCuesExt extends "O365 Activities"
{
    layout
    {
        addafter("Ongoing Sales Invoices")
        {
            field("Ongoing Sales Credit Memos"; Rec."Ongoing Sales Credit Memos")
            {
                ApplicationArea = Suite;
                DrillDownPageID = "Sales Credit Memos";
                Caption = 'Sales Credit Memos';
                Image = Cash;
            }
        }
        addbefore("Purchase Orders")
        {
            field(OngoingPurchQuote; Rec.OngoingPurchQuote)
            {
                ApplicationArea = Suite;
                DrillDownPageID = "Purchase Quotes";
                Caption = 'Purchase Quotes';
                Image = Receipt;
            }
        }
        addafter("Ongoing Purchase Invoices")
        {
            field("Ongoing Purchase Credit Memos"; Rec."Ongoing Purchase Credit Memos")
            {
                ApplicationArea = Suite;
                DrillDownPageID = "Purchase Credit Memos";
                Caption = 'Purchase Credit Memos';
                Image = Diagnostic;
            }
        }
        addbefore("Overdue Purch. Invoice Amount")
        {
            field("Pending Sales Invoice Amount"; Rec."Pending Sales Invoice Amount")
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageId = "Sales Invoice List";
                Visible = true;
            }
        }
        addafter("Purch. Invoices Due Next Week")
        {
            field("Purch. Invoices Due This Week"; Rec."Purch. Invoices Due This Week")
            {
                ApplicationArea = Basic, Suite;
                Visible = true;
            }
        }
        modify("Purch. Invoices Due Next Week") { Visible = false; }
        addlast(Control54)
        {
            field(CustomersOpen; Rec.CustomersOpen)
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageID = "Customer Ledger Entries";
                Caption = 'Open Customer Entries';
                Visible = true;
                Image = Person;
            }
            field(SuppliersOpen; Rec.SuppliersOpen)
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageID = "Vendor Ledger Entries";
                Caption = 'Open Vendor Entries';
                Visible = true;
                Image = People;
            }
            field(ItemsOnShopify; Rec.ItemsOnShopify)
            {
                ApplicationArea = All;
                DrillDownPageId = ShopifyAllVariants;
                Caption = 'Shopify Items';
                Visible = false;
            }
        }
        modify("Ongoing Purchase Invoices")
        { Caption = 'Purch. Invoices'; }
        modify("Sales Invoices Predicted Overdue")
        { Visible = false; }
        modify("Non-Applied Payments")
        { Visible = false; }
        modify("Average Collection Days")
        { Visible = false; }
        modify("S. Ord. - Reserved From Stock")
        { Visible = false; }
    }

    trigger OnOpenPage()
    begin
        if Date2DWY(WorkDate(), 1) >= 5 then // Check if today is Friday
            Rec.SetFilter("Due This Week Filter", '<=%1', CalcDate('CW+8D', WorkDate())) // Show up to the end of next week and a bit of the week after
        else
            Rec.SetFilter("Due This Week Filter", '<=%1', CalcDate('CW+1D', WorkDate())); // Show up to the end of the current week and a bit of the next week
    end;
}