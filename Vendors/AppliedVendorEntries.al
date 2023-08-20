pageextension 50201 AppliedVendorEntriesExt extends "Applied Vendor Entries"
{
    layout
    {
        addafter(Amount)
        {
            field("Bal. Account Type"; Rec."Bal. Account Type")
            { ApplicationArea = All; Visible = true; }
            field("Bal. Account No."; Rec."Bal. Account No.")
            { ApplicationArea = All; Visible = true; }
        }
    }
}