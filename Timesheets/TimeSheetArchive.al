tableextension 50204 "Time Sheet Line Archive Ext" extends "Time Sheet Line Archive"
{
    fields
    {
        field(50100; "Work Done"; Text[1000])
        { CaptionML = ENG = 'Work Done', ENU = 'Work Done'; OptimizeForTextSearch = true; }
    }
}