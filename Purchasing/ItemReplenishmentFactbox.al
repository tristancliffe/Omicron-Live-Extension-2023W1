pageextension 50167 ItemReplenishmentExt extends "Item Replenishment FactBox"
{
    layout
    {
        addbefore(Production)
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