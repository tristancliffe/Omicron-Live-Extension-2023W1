tableextension 50203 "Res. Ledger Entry Ext" extends "Res. Ledger Entry"
{
    fields
    {
        field(50100; "Work Done"; Text[700])
        { CaptionML = ENG = 'Work Done', ENU = 'Work Done'; } //!OptimizeForTextSearch = true; }
    }
}