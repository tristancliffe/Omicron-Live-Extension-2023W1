pageextension 50220 FixedAssetGLJournalExt extends "Fixed Asset G/L Journal"
{
    layout
    {
        moveafter("Document No."; "External Document No.")
        modify("External Document No.")
        { Visible = true; }
    }
}