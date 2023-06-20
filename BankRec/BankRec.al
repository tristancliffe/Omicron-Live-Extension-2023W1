pageextension 50144 BankRecPageExt extends "Bank Acc. Reconciliation"
{
    layout
    { }
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
                ToolTip = 'View statements for selected bank accounts. For each bank transaction, the report shows a description, an applied amount, a statement amount, and other information.';
            }
        }
        addfirst(Category_Process)
        {
            actionref(ImportStatement_Promoted; ImportBankStatement)
            { }
        }
        addlast(Category_Process)
        {
            actionref(BankStatements; "Bank Acc. Statements")
            { }
        }
        modify(MatchManually)
        { ShortcutKey = 'Alt+M'; }
        modify(RemoveMatch)
        { ShortcutKey = 'Alt+R'; }
        modify(MatchAutomatically)
        { ShortcutKey = 'Alt+X'; }
        modify(MatchDetails)
        { ShortcutKey = 'Alt+D'; }
        modify("&Test Report")
        { ShortcutKey = 'Ctrl+Alt+T'; }
    }
}

