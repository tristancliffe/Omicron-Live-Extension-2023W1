pageextension 50144 BankRecPageExt extends "Bank Acc. Reconciliation"
{
    layout
    {
        modify(StatementEndingBalance)
        {
            trigger OnAfterValidate()
            begin
                if Rec."Statement Ending Balance" <> 0 then
                    if Rec."Balance Last Statement" / Rec."Statement Ending Balance" < 0 then
                        message('Double-check the sign (positive/negative) of the Statement Ending Balance.');
            end;
        }
    }
    actions
    {
        addlast("F&unctions")
        {
            action("Bank Acc. Statements")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Bank Acc. Statements';
                Image = BankAccountStatement;
                RunObject = Page "Bank Account Statement List";
                RunPageLink = "Bank Account No." = field("Bank Account No.");
                RunPageView = sorting("Statement Date") order(descending);
                ToolTip = 'View statements for selected bank accounts. For each bank transaction, the report shows a description, an applied amount, a statement amount, and other information.';
            }
        }
        modify(MatchManually)
        { ShortcutKey = 'Alt+M'; CaptionML = ENG = 'MATCH'; }
        modify(RemoveMatch)
        { ShortcutKey = 'Alt+R'; CaptionML = ENG = 'UN-MATCH'; }
        modify(MatchAutomatically)
        { ShortcutKey = 'Alt+X'; }
        modify(MatchDetails)
        { ShortcutKey = 'Alt+D'; }
        modify("&Test Report")
        { ShortcutKey = 'Ctrl+Alt+T'; }
        modify(NotMatched)
        { ShortcutKey = 'Alt+S'; CaptionML = ENG = 'HIDE Matched'; }
        modify(All)
        { ShortcutKey = 'Alt+A'; CaptionML = ENG = 'SHOW All'; }
        modify("Transfer to General Journal_Promoted")
        { Visible = false; }
        modify(SuggestLines_Promoted)
        { Visible = false; }
        addfirst(Category_Process)
        {
            actionref(ImportStatement_Promoted; ImportBankStatement)
            { }
            actionref(AutoMatch_Promoted; MatchAutomatically)
            { }
            actionref(ManualMatch_Promoted; MatchManually)
            { }
            actionref(UnMatch_Promoted; RemoveMatch)
            { }
            actionref(HideMatched_Promoted; NotMatched)
            { }
            actionref(ShowMatched_Promoted; All)
            { }
            actionref(BankStatements; "Bank Acc. Statements")
            { }
            actionref(TestReport; "&Test Report")
            { }
        }
    }
}

