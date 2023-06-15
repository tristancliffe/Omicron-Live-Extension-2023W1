pageextension 50187 RecurringGenJournalExt extends "Recurring General Journal"
{
    layout
    {
        moveafter("Allocated Amt. (LCY)"; "VAT Amount")
        modify("VAT Amount")
        { Visible = true; }
        addafter("VAT Amount")
        {
            field("Bal. Account Type"; Rec."Bal. Account Type")
            {
                ApplicationArea = All;
                Visible = true;
            }
            field("Bal. Account No."; Rec."Bal. Account No.")
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
    }
}