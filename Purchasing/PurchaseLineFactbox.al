pageextension 50166 PurchaseFactboxExt extends "Purchase Line FactBox"
{
    layout
    {
        addafter(Availability)
        {
            field(QtyOnSalesOrder_PurchLine; Rec.CalcQtyOnSalesOrder_PurchLine)
            { ApplicationArea = All; Visible = true; DrillDown = true; }
        }
        addafter(Attachments)
        {
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
        Item: Record Item;

    trigger OnAfterGetCurrRecord()
    begin
        ImageExists := true;
        NotesExist := true;
        if Rec.Image_PurchLine.Count = 0 then
            ImageExists := false;
        If strlen(Rec.ItemNotes_PurchLine) = 0 then
            NotesExist := false;
    end;

    local procedure ShowNotes(): text[1000]
    begin
        if Rec.Type <> Rec.Type::Item then
            exit('');
        exit(Rec.ItemNotes_PurchLine);
    end;
}