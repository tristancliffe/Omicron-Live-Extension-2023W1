
reportextension 50140 "Omicron Picking List" extends "Pick Instruction"
{
    dataset
    {
        modify("Assembly Line")
        {
            trigger OnAfterAfterGetRecord()
            begin
                GetInventory;
            end;
        }

        add("Sales Line")
        {
            column(ShelfNo_SalesLine; "Sales Line".ShelfNo_SalesLine)
            { }
            column(CommodityCode_SalesLine; "Sales Line".CommodityCode_SalesLine)
            { }
            column(Instock_SalesLine; "Sales Line".Instock_SalesLine)
            { }
            // column(Image_SalesLine; "Sales Line".Image_SalesLine)
            // { }
            // column(InventoryQty_SalesLine; "Sales Line".InventoryQty_SalesLine)
            // { }
        }
        add("Assembly Line")
        {
            column(ShelfNo_AssemblyLine; "Assembly Line".ShelfNo_AssemblyLine)
            { }
            column(CommodityCode_AssemblyLine; "Assembly Line".CommodityCode_AssemblyLine)
            { }
            column(Instock_AssemblyLine; "Assembly Line".Instock_AssemblyLine)
            { }

            // column(InventoryQty_AssemblyLine; "Assembly Line".InventoryQty_AssemblyLine)
            // { }
        }
        // modify("Sales Line")
        // {
        //     trigger OnAfterAfterGetRecord()
        //     var
        //         Item: record Item;
        //     begin
        //         Item.get("No.");
        //         if Item.Picture.Count > 0 then begin
        //             TenantMedia.Get(Item.Picture.Item(1));
        //             TenantMedia.CalcFields(Content);
        //         end;
        //     end;
        // }

    }

    rendering
    {
        layout("./OmicronPickInstruction.rdlc")
        {
            Type = RDLC;
            LayoutFile = './OmicronPickInstruction.rdlc';
            Caption = 'Omicron Pick Instruction';
            Summary = 'Omicron Pick Instruction';
        }
    }
    // var
    //     TenantMedia: Record "Tenant Media";

    local procedure GetInventory()
    var
        Item: Record Item;
    begin
        if Item.Get("Assembly Line"."No.") then begin
            Item.CalcFields(Inventory, "Reserved Qty. on Inventory");
            "Assembly Line".Validate(Instock_AssemblyLine, Item.Inventory - Item."Reserved Qty. on Inventory");
            "Assembly Line".Modify();
            Commit();
        end
        else
            if Item.Get("Assembly Line"."No.") and ((Item.Type = Item.Type::"Non-Inventory") or (Item.Type = Item.Type::Service)) then begin
                "Assembly Line".Validate(Instock_AssemblyLine, 999);
                "Assembly Line".Modify();
                Commit();
            end;
    end;
}
