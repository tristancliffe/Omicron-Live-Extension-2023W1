pageextension 50206 ReviewGLLedgerEntriesExte extends "Review G/L Entries"
{
    layout
    {
        addafter("Posting Date")
        {
            field(Reversed59198; Rec.Reversed)
            { ApplicationArea = All; Editable = false; }
        }
        addbefore(Description)
        {
            field("Source No."; Rec."Source No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the source number of the G/L entry.';
                Editable = false;
            }
        }
    }
}