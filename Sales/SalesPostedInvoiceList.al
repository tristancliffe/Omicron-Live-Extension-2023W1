pageextension 50178 PostedSalesInvoiceListExt extends "Posted Sales Invoices"
{
    layout
    {
        movebefore("Sell-to Customer No."; "Document Date", "Posting Date")
        modify("Posting Date")
        {
            ApplicationArea = All;
            Visible = true;
            Caption = 'Posted Date';
            ToolTip = 'The date that the invoice was posted.';
        }
        modify("Currency Code")
        { Visible = false; }
        addafter("Sell-to Customer Name")
        {
            field("Your Reference"; Rec."Your Reference")
            { ApplicationArea = All; }
        }
        modify("Location Code")
        { Visible = false; }
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