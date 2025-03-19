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
        }
        modify(Line)
        {
            trigger OnAfterAfterGetRecord()
            begin
                if (Line.Type = Line.Type::Item) and (Line."Qty. to Ship" = 0) and (HideLinesWithZeroQuantity = true) then CurrReport.Skip();
                FormattedQuantity := format("Qty. to Ship");
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
    }
    var
        HideLinesWithZeroQuantity: Boolean;
}