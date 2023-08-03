pageextension 50162 VendorLedgerEntriesExt extends "Vendor Ledger Entries"
{
    layout
    {
        moveafter(Description; "Due Date", "Original Amount", Amount, "Amount (LCY)", "User ID", "Remaining Amount", "Remaining Amt. (LCY)")
        modify("User ID")
        { Visible = true; ApplicationArea = All; }
    }
    actions
    {
        addlast("F&unctions")
        {
            action(VendorList)
            {
                ApplicationArea = All;
                Image = Vendor;
                Caption = 'Vendor List';
                RunObject = page "Vendor List";
                Description = 'Open the vendor list.';
                ToolTip = 'Opens the vendor ledger entries for this vendor.';
                Visible = true;
                Enabled = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Scope = Repeater;
            }
            // action(VendorLedger)
            // {
            //     ApplicationArea = All;
            //     Image = VendorLedger;
            //     Caption = 'Vendor Ledger';
            //     RunObject = page "Vendor Ledger Entries";
            //     RunPageLink = "Vendor No." = field("Vendor No.");
            //     Description = 'Open the vendor list.';
            //     ToolTip = 'Opens the vendor ledger entries for this vendor.';
            //     Visible = true;
            //     Enabled = true;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedOnly = true;
            // }
        }
    }
}
