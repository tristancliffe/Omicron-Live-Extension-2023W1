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
                field("Shelf No."; Rec."Shelf No.")
                {
                    ApplicationArea = All;
                    Caption = 'Shelf';
                    Visible = true;

                    trigger OnDrillDown()
                    var
                        Items: Record Item;
                    begin
                        Items.Reset();
                        Items.SetFilter("Shelf No.", Rec."Shelf No.");
                        if not Items.IsEmpty then
                            Page.Run(Page::"Item List", Items);
                    end;
                }
                field(ItemCost; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Cost';
                    Visible = true;
                    DrillDown = false;
                }
                field("Reordering Policy"; Rec."Reordering Policy")
                {
                    ApplicationArea = All;
                    Caption = 'Reorder Policy';
                    Visible = true;
                    DrillDown = false;
                }
                field(QtyToOrder; QtyToOrder)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity to Order';
                    Visible = true;
                    DrillDown = false;
                }
            }
            // group(Notes)
            // {
            //     Caption = 'Item Notes';
            //     Visible = NotesExist;

            //     field("Item Notes"; Rec."Item Notes") //ShowNotes())
            //     {
            //         ApplicationArea = All;
            //         Caption = '';
            //         MultiLine = true;
            //         Visible = true;
            //         DrillDown = false;
            //     }
            // }
            // group(Image)
            // {
            //     Visible = ImageExists;
            //     Caption = 'Item Image';

            //     field(Picture; Rec.Picture)
            //     {
            //         ApplicationArea = All;
            //         Caption = '';
            //     }
            // }
        }
    }

    var
        // ImageExists: Boolean;
        // NotesExist: Boolean;
        TypeExists: Boolean;
        QtyToOrder: Decimal;

    trigger OnAfterGetCurrRecord()
    var
        Item: Record Item;
    begin
        // ImageExists := true;
        // NotesExist := true;
        TypeExists := true;
        if (Rec.Type <> Rec.Type::Inventory) and (Rec.Type <> Rec.Type::"Non-Inventory") then
            TypeExists := false;
        //message('%1', strlen(Rec.ItemNotes_PurchLine));
        // if Rec.Picture.Count = 0 then
        //     ImageExists := false;
        // // if Rec.Type <> Rec.Type::Item then
        // //     TypeExists := false;
        // If strlen(Rec."Item Notes") = 0 then
        //     NotesExist := false;
        if Item.Get(Rec."No.") then begin
            if item."Reordering Policy" = item."Reordering Policy"::"Fixed Reorder Qty." then
                QtyToOrder := item."Reorder Quantity"
            else
                if item."Reordering Policy" = item."Reordering Policy"::"Maximum Qty." then begin
                    Item.CalcFields(Inventory, "Reserved Qty. on Inventory");
                    QtyToOrder := item."Reorder Quantity" - item.Inventory + item."Reserved Qty. on Inventory"
                end
                else
                    QtyToOrder := 0
        end;
    end;

    // local procedure ShowType(): Enum "Item Type"
    // begin
    //     if Rec.Type <> Rec.Type::Item then
    //         exit(Rec.ItemType_PurchLine::"Non-Inventory");
    //     exit(Rec.ItemType_PurchLine);
    // end;
}