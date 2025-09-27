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

                field(QtyInStock; InStock)
                {
                    Editable = false;
                    Caption = 'Qty in Stock';
                    ApplicationArea = All;
                    Visible = true;
                    BlankZero = true;
                    Style = StandardAccent;
                    Width = 5;
                    DecimalPlaces = 0 : 2;

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
        }
    }

    var
        TypeExists: Boolean;

    local procedure QtytoOrder(): Decimal
    var
        Item: Record Item;
    begin
        TypeExists := true;
        if (Rec.Type <> Rec.Type::Inventory) and (Rec.Type <> Rec.Type::"Non-Inventory") then
            TypeExists := false;
        if Item.Get(Rec."No.") then begin
            if item."Reordering Policy" = item."Reordering Policy"::"Fixed Reorder Qty." then
                exit(item."Reorder Quantity")
            else
                if item."Reordering Policy" = item."Reordering Policy"::"Maximum Qty." then begin
                    Item.CalcFields(Inventory, "Reserved Qty. on Inventory");
                    exit(item."Reorder Quantity" - item.Inventory + item."Reserved Qty. on Inventory")
                end
                else
                    exit(0)
        end;
    end;

    local procedure InStock(): Decimal
    var
        Item: Record Item;
    begin
        if Item.Get(Rec."No.") and (Item.Type = Item.Type::Inventory) then begin
            Item.CalcFields(Inventory);
            Exit(Item.Inventory);
        end
        else
            if Item.Get(Rec."No.") and ((Item.Type = Item.Type::"Non-Inventory") or (Item.Type = Item.Type::Service)) then begin
                Exit(999);
            end
            else
                exit(0);
    end;
}