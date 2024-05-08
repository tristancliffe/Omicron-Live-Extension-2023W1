reportextension 50102 OmicronSalesOrderConf extends "Standard Sales - Order Conf."
{
    dataset
    {
        add(Header)
        {
            column(Sell_to_Phone_No_; "Sell-to Phone No.") { }
            column(Mobile_No_; Header."Mobile No.") { }
            column(Sell_to_E_Mail; "Sell-to E-Mail") { }
        }
        add(Line)
        {
            column(ShelfNo_SalesLine; Line.ShelfNo_SalesLine) { }
            column(CommodityCode_SalesLine; Line.CommodityCode_SalesLine) { }
            column(Instock_SalesLine; Line.Instock_SalesLine) { }

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
            Caption = 'Omicron Sales Order Confirmation';
            Summary = 'Omicron Sales Order Confirmation';
        }
    }
    // var
    //     TenantMedia: Record "Tenant Media";
}
