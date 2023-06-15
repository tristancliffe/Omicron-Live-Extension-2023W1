pageextension 50162 VendorLedgerEntriesExt extends "Vendor Ledger Entries"
{
    layout
    {
        moveafter(Description; "Original Amount")
        moveafter("Original Amount"; Amount)
        moveafter(Amount; "Amount (LCY)")
        moveafter("Amount (LCY)"; "Remaining Amount")
        moveafter("Remaining Amount"; "Remaining Amt. (LCY)")
        moveafter(Description; "Due Date")
        moveafter("Amount (LCY)"; "User ID")
        modify("User ID")
        {
            Visible = true;
            ApplicationArea = All;
        }
    }
}
