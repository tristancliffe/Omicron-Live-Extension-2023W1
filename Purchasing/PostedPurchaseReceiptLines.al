pageextension 50222 PostedPurchaseReceiptLines extends "Posted Purchase Receipt Lines"
{
    layout
    {
        addafter("Document No.")
        {
            field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
        }
        addlast(Control1)
        {
            field("Unit Cost"; Rec."Unit Cost") { ApplicationArea = All; }
        }
        moveafter("Unit Cost"; "Order No.", "Job No.")
        modify("Order No.") { Visible = true; }
        modify("Job No.") { Visible = true; }
        addafter("Job No.")
        {
            field(SystemCreatedAt; Rec.SystemCreatedAt) { ApplicationArea = All; Visible = true; Caption = 'Posted At'; }
            field(SystemCreatedBy; GetFullName(Rec.SystemCreatedBy)) { ApplicationArea = All; Visible = true; Caption = 'Posted By'; }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Document No.");
        Rec.Ascending := false;
        Rec.FindFirst;
    end;

    procedure GetFullName(userID: Guid): Text
    var
        UserInfo: Record User;
    begin
        if not UserInfo.Get(userID) then
            exit('');
        exit(UserInfo."Full Name");
    end;
}