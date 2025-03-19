pageextension 50206 ReviewGLLedgerEntriesExte extends "Review G/L Entries"
{
    layout
    {
        addafter("Posting Date")
        {
            field(Reversed59198; Rec.Reversed)
            { ApplicationArea = All; }
        }
    }
}