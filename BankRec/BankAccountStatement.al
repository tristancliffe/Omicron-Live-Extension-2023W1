pageextension 50188 BankStatementExt extends "Bank Account Statement"
{
    layout
    {
        addafter("Balance Last Statement")
        {
            field("Change in Balance"; Rec."Statement Ending Balance" - Rec."Balance Last Statement")
            {
                ApplicationArea = All;
                Caption = 'Change in Balance';
                Tooltip = 'The difference between the ''Statement Ending Balance'' and the ''Balance Last Statement''';
                Editable = False;
                Style = Ambiguous;
            }
        }
        addafter("Statement Ending Balance")
        {
            field("G/L Balance at Posting Date"; Rec."G/L Balance at Posting Date")
            {
                ApplicationArea = All;
                Caption = 'G/L Balance at Posting Date';
                ToolTip = 'Balance of the Bank Account G/L Account after posting Bank Reconciliation.';
                Editable = false;
            }
            field(Difference; Difference)
            {
                ApplicationArea = All;
                Caption = 'Difference between statement and G/L';
                Tooltip = 'Shows the difference between the statement ending balance and the Bank Account G/L account balance. This is ''G/L - Statement''';
                Editable = false;
                Style = Ambiguous;
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

    var
        Difference: Decimal;
        UserName: Record User;

    trigger OnAfterGetRecord()
    begin
        Difference := Rec."G/L Balance at Posting Date" - Rec."Statement Ending Balance";
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