// This is a page extension for the "Component - Item FactBox"
// Adds a new group called "ItemType" to show the item type of the component
// Adds a new group called "Notes" to show the item notes of the component
// Adds a new group called "Image" to show the item image of the component
// The visibility of the ItemType, Notes, and Image groups depend on the existence of data in the corresponding fields
// The OnAfterGetCurrRecord trigger is used to check if the data exists in each field and sets the visibility flags accordingly
pageextension 50168 AssemblyOrderItemDetailsExt extends "Component - Item FactBox"
{
    layout
    {
        addafter("Required Quantity")
        {
            group(ItemType)
            {
                Caption = 'Item Info.';
                Visible = TypeExists;

                field(ItemType_AssemblyLine; Rec.ItemType_AssemblyLine)
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

                field(ItemNotes_AssemblyLine; Rec.ItemNotes_AssemblyLine) //ShowNotes())
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

                field(Image_AssemblyLine; Rec.Image_AssemblyLine)
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
        if Rec.Image_AssemblyLine.Count = 0 then
            ImageExists := false;
        if Rec.Type <> Rec.Type::Item then
            TypeExists := false;
        If strlen(Rec.ItemNotes_AssemblyLine) = 0 then
            NotesExist := false;
    end;
}