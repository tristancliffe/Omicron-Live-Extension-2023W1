pageextension 50186 GenLedgerEntriesExt extends "General Ledger Entries"
{
    AboutTitle = 'General Ledger Colours';
    AboutText = 'The colours on the list show if an amount is negative (**red**) or positive (**black**).';
    layout
    {
        moveafter("Posting Date"; Reversed)
        modify(Reversed)
        { Visible = true; }
        modify("User ID")
        { Visible = false; }
        moveafter("External Document No."; "VAT Bus. Posting Group", "VAT Prod. Posting Group", "VAT Amount")
        modify("VAT Bus. Posting Group")
        { Visible = true; }
        modify("VAT Prod. Posting Group")
        { Visible = true; }
        modify("VAT Amount")
        { Visible = true; }
        modify(Amount)
        { StyleExpr = BalanceColour; }
        addafter("VAT Reporting Date")
        {
            field(Comment; Rec.Comment)
            { ApplicationArea = All; }
        }
        moveafter("Bal. Account No."; RunningBalance)
        modify(RunningBalance)
        { Visible = true; }
        addlast(Control1)
        {
            field(SystemCreatedAt; Rec.SystemCreatedAt) { ApplicationArea = All; Visible = true; Caption = 'Posted At'; }
            field(SystemCreatedBy; GetFullName(Rec.SystemCreatedBy)) { ApplicationArea = All; Visible = true; Caption = 'Posted By'; }
        }
    }

    var
        BalanceColour: Text;

    local procedure SetBalanceColours(): Text
    begin
        if Rec.Amount < 0 then
            exit('Attention');
        exit('');
    end;

    trigger OnAfterGetRecord()
    begin
        BalanceColour := SetBalanceColours();
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