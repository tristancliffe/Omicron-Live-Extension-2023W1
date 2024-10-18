pageextension 50136 ItemJournalShelfExt extends "Phys. Inventory Journal"
{
    layout
    {
        addafter("Location Code")
        {
            field("Shelf No"; Rec.ShelfNo_ItemJournalLine)
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'Shelf Location';
            }
        }
        modify("Salespers./Purch. Code") { Visible = false; }
        modify(ShortcutDimCode4) { Visible = false; }
        modify(ShortcutDimCode5) { Visible = false; }
        modify(ShortcutDimCode3) { Visible = false; }
        modify("Shortcut Dimension 2 Code") { Visible = false; }
        modify("Shortcut Dimension 1 Code") { Visible = false; }
    }
}