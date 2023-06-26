pageextension 50162 VendorLedgerEntriesExt extends "Vendor Ledger Entries"
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
}
