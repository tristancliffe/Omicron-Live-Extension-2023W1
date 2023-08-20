pageextension 50208 PostedPurchReceiptListExt extends "Posted Purchase Receipts"
{
    layout
    {
        moveafter("No."; "Posting Date")
        modify("Posting Date")
        { Visible = true; }
    }
}