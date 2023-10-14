
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
        Items: Record Item;
    begin
        if Items.Get("Assembly Line"."No.") then begin
            Items.CalcFields(Inventory);
            "Assembly Line".Instock_AssemblyLine := Items.Inventory;
            "Assembly Line".Modify();
            Commit();
        end
        else
            if Items.Get("Assembly Line"."No.") and ((Items.Type = Items.Type::"Non-Inventory") or (Items.Type = Items.Type::Service)) then begin
                "Assembly Line".Instock_AssemblyLine := 999;
                "Assembly Line".Modify();
                Commit();
            end;
    end;
}
