pageextension 50162 VendorLedgerEntriesExt extends "Vendor Ledger Entries"
{
    layout
    {
        moveafter(Description; "Due Date", "Remaining Amount", "Remaining Amt. (LCY)", "Original Amount", "Amount (LCY)", "User ID")
        modify("User ID")
        { Visible = true; ApplicationArea = All; }
        modify("Pmt. Discount Date")
        { Visible = false; }
        modify("Pmt. Disc. Tolerance Date")
        { Visible = false; }
        modify("Original Pmt. Disc. Possible")
        { Visible = false; }
        modify("Remaining Pmt. Disc. Possible")
        { Visible = false; }
        modify("Max. Payment Tolerance")
        { Visible = false; }
        modify("Exported to Payment File")
        { Visible = false; }
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
