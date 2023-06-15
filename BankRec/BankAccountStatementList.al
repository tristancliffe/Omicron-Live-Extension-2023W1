pageextension 50190 BankStatementListExt extends "Bank Account Statement List"
{
    layout
    {
        addlast(Control1)
        {
            field("G/L Balance at Posting Date"; Rec."G/L Balance at Posting Date")
            {
                ApplicationArea = All;
                Tooltip = 'The balance of the G/L account after posting the statement, which SHOULD match the Bank Statement from the bank.';
                Style = Ambiguous;
                Editable = False;
            }
            field(Difference; Rec."G/L Balance at Posting Date" - Rec."Statement Ending Balance")
            {
                ApplicationArea = All;
                Caption = 'Difference';
                Tooltip = 'Different between "G/L Balance at Posting Date" and "Statement Ending Balance"';
                Style = Subordinate;
                Editable = False;
            }
            field("User ID"; GetFullName(Rec.SystemCreatedBy))
            {
                ApplicationArea = All;
                Caption = 'Posted by';
                Tooltip = 'The user name of the account that posted the bank reconciliation.';
                Editable = false;
            }
        }
    }
    views
    {
        addfirst
        {
            view(CurrentAccount)
            {
                Caption = 'Current Account';
                Filters = where("Bank Account No." = filter('CURRENT_BANK'));
                //OrderBy = descending("Statement Date");
            }
            view(CreditCard)
            {
                Caption = 'Credit Card';
                Filters = where("Bank Account No." = filter('NATWEST_CREDIT'));
                //OrderBy = descending("Statement Date");
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