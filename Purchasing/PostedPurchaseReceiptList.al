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
            field(SystemCreatedAt; Rec.SystemCreatedAt) { ApplicationArea = All; Visible = true; Caption = 'Posted At'; }
            field("User ID"; GetFullName(Rec."User ID")) { ApplicationArea = All; Visible = true; Caption = 'Posted By'; }
        }
        moveafter("No."; "Posting Date")
        modify("Posting Date") { Visible = true; }
    }

    procedure GetFullName(userID: Guid): Text
    var
        UserInfo: Record User;
    begin
        if not UserInfo.Get(userID) then
            exit('');
        exit(UserInfo."Full Name");
    end;
}