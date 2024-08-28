// This is a page extension for the "Customer Ledger Entries" page.
// The extension adds functionality to the page layout by moving certain fields around.
// The "Description" field is moved after the "Original Amount" field.
// The "Original Amount" field is moved after the "Amount" field.
// The "Amount (LCY)" field is moved after the "Amount" field.
// The "Remaining Amount" field is moved after the "Amount (LCY)" field.
// The "Remaining Amt. (LCY)" field is moved after the "Remaining Amount" field.
// The "Due Date" field is moved after the "Description" field.
// The "OnOpenPage()" trigger is defined to set the current key to "Posting Date" and "Customer No." in descending order.
pageextension 50155 CustLedgerEntriesExt extends "Customer Ledger Entries"
{
    layout
    {
        moveafter(Description; "Due Date", "Remaining Amount", "Remaining Amt. (LCY)", "Original Amount", "Amount (LCY)", "User ID", RunningBalanceLCY)
        modify("User ID") { Visible = true; ApplicationArea = All; }
        modify("Pmt. Discount Date") { Visible = false; }
        modify("Pmt. Disc. Tolerance Date") { Visible = false; }
        modify("Original Pmt. Disc. Possible") { Visible = false; }
        modify("Remaining Pmt. Disc. Possible") { Visible = false; }
        modify("Max. Payment Tolerance") { Visible = false; }
        modify("Exported to Payment File") { Visible = false; }
        modify("Customer Name") { StyleExpr = TypeStyle; }
        modify(Description) { StyleExpr = TypeStyle; }
        moveafter("Document Type"; "Document No.", Reversed)
        modify(Reversed) { Visible = true; }
        modify("Document No.") { Visible = true; }
        modify(RunningBalanceLCY) { Visible = true; }
        moveafter("Entry No."; "Message to Recipient")
        modify("Message to Recipient") { Visible = true; }
        addlast(Control1)
        {
            field(SystemCreatedAt; Rec.SystemCreatedAt) { ApplicationArea = All; Visible = true; Caption = 'Posted At'; }
            field(SystemCreatedBy; GetFullName(Rec.SystemCreatedBy)) { ApplicationArea = All; Visible = true; Caption = 'Posted By'; }
        }
    }
    actions
    {
        addafter(Customer)
        {
            action(PostedInvoices)
            {
                ApplicationArea = All;
                Caption = 'Posted Invoices';
                Image = SalesInvoice;
                RunObject = Page "Posted Sales Invoices";
                RunPageLink = "Sell-to Customer No." = field("Customer No.");
                RunPageView = sorting("Sell-to Customer No.", "Order Date");
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'View all posted invoices for this customer.';
            }
        }
    }

    var
        TypeStyle: Text;

    trigger OnAfterGetRecord()
    begin
        TypeStyle := SetTypeStyle();
    end;

    local procedure SetTypeStyle(): Text
    begin
        if Rec."Document Type" <> Rec."Document Type"::Invoice then
            exit('Ambiguous');
        exit('');
    end;

    procedure GetFullName(userID: Guid): Text
    var
        UserInfo: Record User;
    begin
        if not UserInfo.Get(userID) then
            exit('');
        exit(UserInfo."Full Name");
    end;

    // trigger OnOpenPage()
    // begin
    //     Rec.SetCurrentKey("Posting Date", "Customer No.");
    //     Rec.Ascending(false);
    // end;
}