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
        report "Job Invoice" = X,
        report "Workshop Request" = X,
        report "Active Jobs" = X,
        page "Completed Job List" = X,
    // page "Customer Phone Number List" = X,
    // page "Employee Phone Number List" = X,
    // page "Phone Number Lists" = X,
    // page "Vendor Phone Number List" = X,
        report "Purchase Order Checklist" = X,
        codeunit "Shpfy Order External Doc. No" = X,
        codeunit "Shpfy Stock Calc. Inventory" = X,
        report "Phone Numbers" = X,
    // codeunit MessageHandlePurch = X,
        page "Job Planning History" = X,
        page "Job Planning Lines All" = X,
        report "Timesheet Instructions" = X,
        page "Job Cues" = X;
}