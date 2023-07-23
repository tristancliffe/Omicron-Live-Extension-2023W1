permissionset 50100 OmicronPermissions
{
    Caption = 'Omicron Extension';
    Assignable = true;
    Permissions = codeunit "Table Page Events" = X,
        page "Logged-In Users" = X,
        codeunit ChangeStatusColour = X,
        codeunit ItemLedgerReasons = X,
        page ShopifyAllVariants = X,
        page "Work Done Dialog" = X,
        report "Job Billing Excel" = X,
        report "Timesheet Entries" = X,
        report ResourceEfficiency = X,
        report "Service Instruction" = X,
        report "Workshop Request" = X;
}