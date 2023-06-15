pageextension 50159 ChartOfAccountsListExt extends "Chart of Accounts"
{
    layout
    {
        addafter("Gen. Prod. Posting Group")
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            { ApplicationArea = All; }
        }
    }
}