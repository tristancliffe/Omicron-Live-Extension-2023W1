pageextension 50208 PostedPurchReceiptListExt extends "Posted Purchase Receipts"
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("Your Reference"; Rec."Your Reference") { Visible = true; ApplicationArea = All; }
            field("Order No."; Rec."Order No.") { ApplicationArea = All; Visible = true; }
        }
        addbefore("Location Code")
        {
            field("User ID"; Rec."User ID") { ApplicationArea = All; Visible = true; Caption = 'Posted By'; }
        }
        moveafter("No."; "Posting Date")
        modify("Posting Date") { Visible = true; }
    }
}