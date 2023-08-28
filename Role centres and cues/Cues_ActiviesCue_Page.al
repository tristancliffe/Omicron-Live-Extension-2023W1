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
                ToolTip = 'Specifies sales credit memos that are active';
                Caption = 'Sales Credit Memos';
            }
        }
        addbefore("Purchase Orders")
        {
            field(OngoingPurchQuote; Rec.OngoingPurchQuote)
            {
                ApplicationArea = Suite;
                DrillDownPageID = "Purchase Quotes";
                ToolTip = 'Specifies purchases quotes that are active';
                Caption = 'Purchase Quotes';
            }
        }
        addafter("Ongoing Purchase Invoices")
        {
            field("Ongoing Purchase Credit Memos"; Rec."Ongoing Purchase Credit Memos")
            {
                ApplicationArea = Suite;
                DrillDownPageID = "Purchase Credit Memos";
                ToolTip = 'Specifies purchases credit memos that are active';
                Caption = 'Purchase Credit Memos';
            }
        }
        addafter("Overdue Purch. Invoice Amount")
        {
            field("Pending Sales Invoice Amount"; Rec."Pending Sales Invoice Amount")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the sum of sales invoices to be sent.';
                DrillDownPageId = "Sales Invoice List";
                Visible = true;
            }
        }
        addlast(Control54)
        {
            field(CustomersOpen; Rec.CustomersOpen)
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageID = "Customer Ledger Entries";
                ToolTip = 'Specifies number of ''Open'' customer ledger entries';
                Caption = 'Open Customer Entries';
                Visible = true;
            }
            field(SuppliersOpen; Rec.SuppliersOpen)
            {
                ApplicationArea = Basic, Suite;
                DrillDownPageID = "Vendor Ledger Entries";
                ToolTip = 'Specifies number of ''Open'' vendor ledger entries';
                Caption = 'Open Vendor Entries';
                Visible = true;
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
    }
    var
        ActivitiesManagement: Codeunit "Activities Mgt.";
}