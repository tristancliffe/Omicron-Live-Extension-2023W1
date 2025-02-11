pageextension 50216 PostedSalesCreditMemoExt extends "Posted Sales Credit Memo"
{
    layout
    {
        moveafter("Sell-to Customer Name"; "Your Reference")
        modify("Your Reference") { Visible = true; }
    }
}