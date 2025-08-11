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
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = Assembly;
                    Caption = 'Quantity in Inventory';
                    ToolTip = 'Shows the current inventory quantity for the item.';
                    trigger OnDrillDown()
                    var
                        ItemLedgerEntryRec: Record "Item Ledger Entry";
                        ItemLedgerEntryPageID: Integer;
                    begin
                        ItemLedgerEntryPageID := Page::"Item Ledger Entries";
                        ItemLedgerEntryRec.SetRange("Item No.", Rec."No.");
                        PAGE.Run(ItemLedgerEntryPageID, ItemLedgerEntryRec);
                    end;
                }
                field(ShelfNo; Rec."Shelf No.")
                {
                    ApplicationArea = All;
                    Caption = 'Shelf';
                    Visible = true;
                    trigger OnDrillDown()
                    var
                        Items: Record Item;
                    begin
                        if Rec."Shelf No." = '' then
                            exit
                        else begin
                            Items.Reset();
                            Items.SetFilter("Shelf No.", Rec."Shelf No.");
                            if not Items.IsEmpty then
                                Page.Run(Page::"Item List", Items)
                        end;
                    end;
                }
            }
            group(Notes)
            {
                Caption = 'Item Notes';
                Visible = NotesExist;

                field("Item Notes"; Rec."Item Notes")
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
        if Rec.Picture.Count = 0 then
            ImageExists := false;
        If strlen(Rec."Item Notes") = 0 then
            NotesExist := false;
    end;
}