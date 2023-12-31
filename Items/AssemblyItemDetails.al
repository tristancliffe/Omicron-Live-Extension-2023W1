// This is a page extension for the "Component - Item FactBox"
// Adds a new group called "ItemType" to show the item type of the component
// Adds a new group called "Notes" to show the item notes of the component
// Adds a new group called "Image" to show the item image of the component
// The visibility of the ItemType, Notes, and Image groups depend on the existence of data in the corresponding fields
// The OnAfterGetCurrRecord trigger is used to check if the data exists in each field and sets the visibility flags accordingly
pageextension 50168 AssemblyItemDetailsExt extends "Assembly Item - Details"
{
    layout
    {
        addafter("Unit Price")
        {
            group(ItemType)
            {
                Caption = 'Item Info.';
                Visible = true;

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

    trigger OnAfterGetCurrRecord()
    begin
        ImageExists := true;
        NotesExist := true;
        //message('%1', strlen(Rec.ItemNotes_PurchLine));
        if Rec.Picture.Count = 0 then
            ImageExists := false;
        If strlen(Rec."Item Notes") = 0 then
            NotesExist := false;
    end;
}