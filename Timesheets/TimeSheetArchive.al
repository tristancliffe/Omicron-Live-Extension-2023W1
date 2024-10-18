tableextension 50204 "Time Sheet Line Archive Ext" extends "Time Sheet Line Archive"
{
    fields
    {
        field(50100; "Work Done"; Text[700])
        { CaptionML = ENG = 'Work Done', ENU = 'Work Done'; } //!OptimizeForTextSearch = true; }
    }
}