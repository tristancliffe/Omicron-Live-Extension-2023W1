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
        Items: Record Item;
    begin
        if Items.Get(Rec."No.") and (Items.Type = Items.Type::Inventory) then begin
            Items.CalcFields(Inventory);
            exit(Items.Inventory);
        end
        else
            if Items.Get(Rec."No.") and ((Items.Type = Items.Type::"Non-Inventory") or (Items.Type = Items.Type::Service)) then
                exit(999);
    end;
}