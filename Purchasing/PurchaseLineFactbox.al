pageextension 50166 PurchaseFactboxExt extends "Purchase Line FactBox"
{
    layout
    {
        addafter(Availability)
        {
            group(Type)
            {
                ShowCaption = false;
                Visible = TypeExists;

                field(ItemType; Rec.ItemType_PurchLine) //ShowType())
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

                field(ItemNotes_SalesLine; Rec.ItemNotes_PurchLine) //ShowNotes())
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

                field(Image_SalesLine; Rec.Image_PurchLine)
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
        if Rec.Image_PurchLine.Count = 0 then
            ImageExists := false;
        if Rec.Type <> Rec.Type::Item then
            TypeExists := false;
        If strlen(Rec.ItemNotes_PurchLine) = 0 then
            NotesExist := false;
    end;


    local procedure ShowType(): Enum "Item Type"
    begin
        if Rec.Type <> Rec.Type::Item then
            exit(Rec.ItemType_PurchLine::"Non-Inventory");
        exit(Rec.ItemType_PurchLine);
    end;

    local procedure ShowNotes(): text[1000]
    begin
        if Rec.Type <> Rec.Type::Item then
            exit('');
        exit(Rec.ItemNotes_PurchLine);
    end;
}