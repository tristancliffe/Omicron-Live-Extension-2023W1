pageextension 50218 DepreciationBooksExt extends "FA Depreciation Books Subform"
{
    layout
    {
        movebefore("Declining-Balance %"; "Straight-Line %")
        modify("Straight-Line %") { Visible = true; }
    }
}