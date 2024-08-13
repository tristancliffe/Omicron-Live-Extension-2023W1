pageextension 50216 PostedSalesCreditMemoExt extends "Posted Sales Credit Memo"
{
    layout
    {
        addbefore("Sell-to Customer Name")
        {
            field("Sell-to Customer No."; Rec."Sell-to Customer No.")
            { ApplicationArea = All; }
        }
        moveafter("Sell-to Customer Name"; "Your Reference")
        modify("Your Reference") { Visible = true; }
    }
}