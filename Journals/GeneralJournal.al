pageextension 50163 GeneralJournalExt extends "General Journal"
{
    layout
    {
        moveafter("Posting Date"; "Document Date", "VAT Reporting Date")
        modify("Document Date")
        { Visible = true; width = 10; }
        modify("VAT Reporting Date")
        { Visible = true; Width = 10; }
        modify("EU 3-Party Trade")
        { Visible = false; }
        modify("Deferral Code")
        { Visible = false; }
        modify("Applies-to Doc. Type")
        { Visible = true; }
        modify("Applies-to Doc. No.")
        { Visible = true; }
        modify("External Document No.")
        { Visible = true; }
        //moveafter("Bal. Gen. Prod. Posting Group"; "Applies-to Doc. Type", "Applies-to Doc. No.")
    }
    actions
    {
        addlast(processing)
        {
            action(ChartOfAccounts)
            {
                ApplicationArea = All;
                Image = GeneralLedger;
                Caption = 'G/L Account';
                RunObject = page "G/L Account Card";
                RunPageLink = "No." = field("Account No.");
                Description = 'Go to the General Ledger account card';
                ToolTip = 'Opens the general ledger account card for this line';
                Scope = Repeater;
                Visible = true;
                Enabled = true;
            }
            action(VendorLink)
            {
                ApplicationArea = All;
                Image = Vendor;
                Caption = 'Vendor Card';
                RunObject = page "Vendor Card";
                RunPageLink = "No." = field("Account No.");
                Description = 'Go to the Vendor card';
                ToolTip = 'Opens the Vendor account card for this line';
                Scope = Repeater;
                Visible = true;
                Enabled = true;
            }
            action(CustomerLink)
            {
                ApplicationArea = All;
                Image = Customer;
                Caption = 'Customer Card';
                RunObject = page "Customer Card";
                RunPageLink = "No." = field("Account No.");
                Description = 'Go to the Customer card';
                ToolTip = 'Opens the Customer account card for this line';
                Scope = Repeater;
                Visible = true;
                Enabled = true;
            }
        }
        addafter(Category_Category9)
        {
            group("Std.Journals")
            {
                Caption = 'Save/Load Standard Journals';
                Image = GetStandardJournal;
                ShowAs = SplitButton;
                Visible = true;
                actionref(GetStdJournals; GetStandardJournals)
                { }
                actionref(SaveStdJournals; SaveAsStandardJournal)
                { }
            }
        }
        modify(GetStandardJournals_Promoted)
        { Visible = false; }
    }
}