pageextension 50152 RequisitionWorksheetExt extends "Req. Worksheet"
{
    // layout
    // {
    //     addafter("Location Code")
    //     {
    //         field(Instock_ReqLine; rec.Instock_ReqLine)
    //         {
    //             Editable = false;
    //             Caption = 'Qty in Stock';
    //             ApplicationArea = All;
    //             Visible = true;
    //             BlankZero = false;
    //             Style = Strong;
    // DecimalPlaces = 0 : 2;
    //         }
    //     }
    // }
    layout
    {
        addafter("Location Code")
        {
            field(Instock_ReqLine; QtyInStock())
            {
                Editable = false;
                Caption = 'Qty in Stock';
                ApplicationArea = All;
                Visible = true;
                //BlankZero = true;
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
        }
    }
    actions
    {
        addlast(navigation)
        {
            group(Utilities)
            {
                action(InvertSelection)
                {
                    Caption = 'Invert Actions';
                    Visible = true;
                    ApplicationArea = Planning;
                    Description = 'Inverts the ''Accept Action Message'' for each line';
                    Tooltip = 'Inverts the ''Accept Action Message'' for each line';
                    Image = ToggleBreakpoint;

                    trigger OnAction();
                    var
                        ReqLines: Record "Requisition Line";
                    begin
                        ReqLines.SetRange("Accept Action Message");
                        if ReqLines.FindFirst then
                            repeat
                                ReqLines."Accept Action Message" := not ReqLines."Accept Action Message";
                                ReqLines.Modify;
                            until ReqLines.Next = 0;
                    end;
                }
                action(ViewItemCard)
                {
                    ApplicationArea = Planning;
                    Caption = 'Item Card';
                    Image = EditLines;
                    RunObject = Codeunit "Req. Wksh.-Show Card";
                    ToolTip = 'View or change detailed information about the item or resource.';
                    Scope = Repeater;
                }
            }
        }
        addlast(Category_Process)
        {
            actionref(ItemCard; ViewItemCard)
            { }
            actionref(InvertChoice; InvertSelection)
            { }
        }
    }
    local procedure QtyInStock(): Decimal
    var
        Item: Record Item;
    begin
        if Item.Get(Rec."No.") and (Item.Type = Item.Type::Inventory) then begin
            Item.CalcFields(Inventory, "Reserved Qty. on Inventory");
            exit(Item.Inventory - Item."Reserved Qty. on Inventory");
        end
        else
            if Item.Get(Rec."No.") and ((Item.Type = Item.Type::"Non-Inventory") or (Item.Type = Item.Type::Service)) then
                exit(999);
    end;
}