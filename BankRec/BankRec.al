pageextension 50144 BankRecPageExt extends "Bank Acc. Reconciliation"
{
    layout
    { }
    actions
    {
        addfirst(Category_Process)
        {
            actionref(ImportStatement_Promoted; ImportBankStatement)
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

