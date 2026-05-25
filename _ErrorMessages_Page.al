pageextension 50247 "Error Messages Ext" extends "Error Messages"
{
    actions
    {
        addlast(Navigation)
        {
            action(General_Ledger_Settings)
            {
                ApplicationArea = All;
                Caption = 'General Ledger Setup';
                Image = Setup;
                RunObject = page "General Ledger Setup";
                Description = 'Open the general ledger setup page.';
                ToolTip = 'Opens the general ledger setup page.';
                Visible = true;
                Enabled = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
            }
        }
    }
}
