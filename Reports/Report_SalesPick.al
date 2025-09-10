
reportextension 50140 "Omicron Picking List" extends "Pick Instruction"
{
    dataset
    {
        modify("Assembly Line")
        {
            trigger OnAfterAfterGetRecord()
            var
                Item: Record Item;
            begin
                GetInventory;
                if "Sales Line"."Qty. to Ship" = 0 then CurrReport.Skip();
                Clear(ItemTenantMedia);
                if Type = Type::Item then
                    if Item.Get("No.") then
                        if Item.Picture.Count > 0 then begin
                            ItemTenantMedia.Get(Item.Picture.Item(1));
                            ItemTenantMedia.CalcFields(Content);
                        end
            end;
        }

        add("Sales Line")
        {
            column(ShelfNo_SalesLine; "Sales Line".ShelfNo_SalesLine) { }
            column(CommodityCode_SalesLine; "Sales Line".CommodityCode_SalesLine) { }
            column(Instock_SalesLine; "Sales Line".Instock_SalesLine) { }
            column(ItemPicture; ItemTenantMedia.Content) { }
            // column(InventoryQty_SalesLine; "Sales Line".InventoryQty_SalesLine) { }

        }
        add("Assembly Line")
        {
            column(ShelfNo_AssemblyLine; "Assembly Line".ShelfNo_AssemblyLine) { }
            column(CommodityCode_AssemblyLine; "Assembly Line".CommodityCode_AssemblyLine) { }
            column(Instock_AssemblyLine; "Assembly Line".Instock_AssemblyLine) { }
            column(ItemPictureAssembly; ItemTenantMedia.Content) { }
        }

        modify("Sales Line")
        {
            trigger OnAfterAfterGetRecord()
            var
                Item: Record Item;
            begin
                if "Sales Line"."Qty. to Ship" = 0 then CurrReport.Skip();
                Clear(ItemTenantMedia);
                if Type = Type::Item then
                    if Item.Get("No.") then
                        if Item.Picture.Count > 0 then begin
                            ItemTenantMedia.Get(Item.Picture.Item(1));
                            ItemTenantMedia.CalcFields(Content);
                        end
            end;
        }
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
    var
        ItemTenantMedia: Record "Tenant Media";

    local procedure GetInventory()
    var
        Item: Record Item;
    begin
        if Item.Get("Assembly Line"."No.") then begin
            Item.CalcFields(Inventory);
            "Assembly Line".Validate(Instock_AssemblyLine, Item.Inventory);
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
