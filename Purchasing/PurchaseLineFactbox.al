pageextension 50166 PurchaseFactboxExt extends "Purchase Line FactBox"
{
    layout
    {
        addafter(Availability)
        {
            field(QtyOnSalesOrder_PurchLine; Rec.QtyOnSalesOrder_PurchLine)
            { ApplicationArea = All; Visible = true; DrillDown = false; }
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
    // TypeExists: Boolean;
    // QtyToOrder: Decimal;
    // Item: Record Item;

    trigger OnAfterGetCurrRecord()
    begin
        ImageExists := true;
        NotesExist := true;
        // TypeExists := true;
        // //message('%1', strlen(Rec.ItemNotes_PurchLine));
        if Rec.Image_PurchLine.Count = 0 then
            ImageExists := false;
        // if Rec.Type <> Rec.Type::Item then
        //     TypeExists := false;
        If strlen(Rec.ItemNotes_PurchLine) = 0 then
            NotesExist := false;
        // if Item.Get(Rec."No.") then begin
        //     if item."Reordering Policy" = item."Reordering Policy"::"Fixed Reorder Qty." then
        //         QtyToOrder := item."Reorder Quantity"
        //     else
        //         if item."Reordering Policy" = item."Reordering Policy"::"Maximum Qty." then begin
        //             Item.CalcFields(Inventory);
        //             QtyToOrder := item."Reorder Quantity" - item.Inventory
        //         end
        //         else
        //             QtyToOrder := 0
        // end;
        if Item.Get(Rec."No.") and (Item.Type = Item.Type::Inventory) then begin
            Item.CalcFields("Qty. on Sales Order");
            Rec.Validate(Rec.QtyOnSalesOrder_PurchLine, Item."Qty. on Sales Order")
        end
        else
            if Item.Get(Rec."No.") and ((Item.Type = Item.Type::"Non-Inventory") or (Item.Type = Item.Type::Service)) then
                Rec.Validate(QtyOnSalesOrder_PurchLine, 0)
    end;


    // local procedure ShowType(): Enum "Item Type"
    // begin
    //     if Rec.Type <> Rec.Type::Item then
    //         exit(Rec.ItemType_PurchLine::"Non-Inventory");
    //     exit(Rec.ItemType_PurchLine);
    // end;

    local procedure ShowNotes(): text[1000]
    begin
        if Rec.Type <> Rec.Type::Item then
            exit('');
        exit(Rec.ItemNotes_PurchLine);
    end;
}