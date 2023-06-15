// The extension adds new groups to the layout: "Item Info.", "Item Notes", and "Item Image".
// The "Item Info." group contains a field for the item type.
// The "Item Notes" group contains a field for the item notes.
// The "Item Image" group contains a field for the item image.
// The extension also defines three Boolean variables: ImageExists, NotesExist, and TypeExists.
// The OnAfterGetCurrRecord trigger sets these variables based on whether an image, notes, or item type exist for the current record.
pageextension 50169 ItemBOMDetailsExt extends "Component - Item Details"
{
    layout
    {
        addafter("Vendor No.")
        {
            group(ItemType)
            {
                Caption = 'Item Info.';
                Visible = TypeExists;

                //field(ItemType; Rec.ItemType_ReqLine) //ShowType())
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'Item Type';
                    Visible = true;
                    DrillDown = false;
                }
            }
            group(Notes)
            {
                Caption = 'Item Notes';
                Visible = NotesExist;

                field("Item Notes"; Rec."Item Notes") //ShowNotes())
                {
                    ApplicationArea = All;
                    Caption = '';
                    MultiLine = true;
                    Visible = true;
                    DrillDown = false;
                }
            }
            group(Image)
            {
                Visible = ImageExists;
                Caption = 'Item Image';

                field(Picture; Rec.Picture)
                {
                    ApplicationArea = All;
                    Caption = '';
                }
            }
        }
    }

    var
        ImageExists: Boolean;
        NotesExist: Boolean;
        TypeExists: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        ImageExists := true;
        NotesExist := true;
        TypeExists := true;
        //message('%1', strlen(Rec.ItemNotes_PurchLine));
        if Rec.Picture.Count = 0 then
            ImageExists := false;
        // if Rec.Type <> Rec.Type::Item then
        //     TypeExists := false;
        If strlen(Rec."Item Notes") = 0 then
            NotesExist := false;
    end;
}