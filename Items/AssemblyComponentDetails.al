pageextension 50213 AssemblyComponentDetailsExt extends "Component - Item FactBox"
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