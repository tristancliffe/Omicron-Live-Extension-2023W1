reportextension 50102 OmicronSalesOrderConf extends "Standard Sales - Order Conf."
{
    dataset
    {
        add(Header)
        {
            column(Sell_to_Phone_No_; "Sell-to Phone No.") { }
            column(Mobile_No_; Header."Mobile No.") { }
            column(Sell_to_E_Mail; "Sell-to E-Mail") { }
            column(CustomerBalance; CustBalance) { AutoCalcField = true; AutoFormatType = 10; AutoFormatExpression = '1,GBP'; }
        }
        add(Line)
        {
            column(ItemPicture; ItemTenantMedia.Content) { }
            column(ShelfNo_SalesLine; Line.ShelfNo_SalesLine) { }
            column(CommodityCode_SalesLine; Line.CommodityCode_SalesLine) { }
            column(Instock_SalesLine; Line.Instock_SalesLine) { }
        }
        modify(Line)
        {
            trigger OnAfterAfterGetRecord()
            var
                Item: Record Item;
            begin
                if (Line.Type = Line.Type::Item) and (Line."Qty. to Ship" = 0) and (HideLinesWithZeroQuantity = true) then CurrReport.Skip();
                FormattedQuantity := format("Qty. to Ship");
                Clear(ItemTenantMedia);
                if Line.Type = Line.Type::Item then begin
                    if Item.Get("No.") then begin
                        // Message('Item No.: %1, Picture Count: %2, Qty. to Ship: %3', Line."No.", Item.Picture.Count, Line."Qty. to Ship");
                        if Item.Picture.Count >= 1 then begin
                            ItemTenantMedia.Get(Item.Picture.Item(1));
                            ItemTenantMedia.CalcFields(Content);
                        end
                    end
                end
            end;
        }
    }
    requestpage
    {
        layout
        {
            addafter(ArchiveDocument)
            {
                field(HideLinesWithZeroQuantityControl; HideLinesWithZeroQuantity)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the lines with nothing to ship are printed.';
                    Caption = 'Hide lines that are not to be shipped';
                }
            }
        }
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
        layout("./OmicronSalesOrderConfPictures.docx")
        {
            Type = Word;
            LayoutFile = './OmicronSalesOrderConfPics.docx';
            Caption = 'Omicron Sales Order Confirmation with Pictures';
            Summary = 'Omicron Sales Order Confirmation with Pictures';
        }
    }
    var
        HideLinesWithZeroQuantity: Boolean;
        ItemTenantMedia: Record "Tenant Media";

    local procedure CustBalance(): Decimal
    var
        RecCustomer: Record Customer;
    begin
        RecCustomer.SetRange("No.", Header."Sell-to Customer No.");
        if RecCustomer.FindSet() then begin
            RecCustomer.CalcFields("Balance (LCY)");
            exit(RecCustomer."Balance (LCY)");
        end;
    end;
}