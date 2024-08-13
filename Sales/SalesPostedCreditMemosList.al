pageextension 50236 PostedSalesCreditMemosList extends "Posted Sales Credit Memos"
{
    layout
    {
        addlast(Control1)
        {
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            { ApplicationArea = All; Visible = true; Caption = 'Posted At'; }
            field(SystemCreatedBy; GetFullName(Rec.SystemCreatedBy))
            { ApplicationArea = All; Visible = true; Caption = 'Posted By'; }
        }
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