reportextension 50102 OmicronSalesOrderConf extends "Standard Sales - Order Conf."
{
    dataset
    {
        add(Line)
        {
            column(ShelfNo_SalesLine; Line.ShelfNo_SalesLine)
            { }
            column(CommodityCode_SalesLine; Line.CommodityCode_SalesLine)
            { }
            column(Instock_SalesLine; Line.Instock_SalesLine)
            { }
            // column(Image_SalesLine; Line.Image_SalesLine)
            // { }
        }
        // addlast(Line)
        // {
        //     dataitem(Item; Item)
        //     {
        //         Description = 'Image';
        //     }
        // }
        // modify(Line)
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
        layout("./OmicronSalesOrderConf.docx")
        {
            Type = Word;
            LayoutFile = './OmicronSalesOrderConf.docx';
        }
    }
    // var
    //     TenantMedia: Record "Tenant Media";
}
