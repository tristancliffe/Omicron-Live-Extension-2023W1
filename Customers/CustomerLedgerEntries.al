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
        moveafter(Description; "Due Date", "Original Amount", Amount, "Amount (LCY)", "User ID", "Remaining Amount", "Remaining Amt. (LCY)")
        modify("User ID")
        {
            Visible = true;
            ApplicationArea = All;
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Posting Date", "Customer No.");
        Rec.Ascending(false);
    end;
}