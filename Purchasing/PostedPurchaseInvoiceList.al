pageextension 50179 PostedPurchInvoiceListExt extends "Posted Purchase Invoices"
{
    layout
    {
        movebefore("Buy-from Vendor No."; "Posting Date", "Document Date", Cancelled)
        moveafter(Amount; "Amount Including VAT", "Remaining Amount")
        movebefore(Amount; "Vendor Invoice No.")
        modify("Posting Date")
        {
            ApplicationArea = All;
            Visible = true;
            Caption = 'Posted Date';
            ToolTip = 'The date that the invoice was posted.';
        }
        modify("Amount Including VAT") { Caption = 'Amount incl. VAT'; Visible = true; }
        modify("Remaining Amount") { Visible = true; }
        modify("Document Date") { Visible = true; }
        modify(Cancelled) { Visible = true; }
        modify("Currency Code") { Visible = true; }
        addafter(Corrective)
        {
            field("User ID"; GetFullName(Rec.SystemCreatedBy))
            {
                ApplicationArea = All;
                Caption = 'Posted by';
                Tooltip = 'The user name of the account that posted the bank reconciliation.';
                Editable = false;
            }
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