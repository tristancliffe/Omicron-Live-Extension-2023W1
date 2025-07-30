reportextension 50104 OmicronPurchaseOrder extends "Order"
{
    //WordLayout = './OmicronPurchaseOrder.docx';
    dataset
    {
        add(RoundLoop)
        {
            column(Vendor_Item_No_; "Purchase Line"."Vendor Item No.")
            { }
        }
    }
    requestpage
    {
        trigger OnOpenPage()
        begin
            ShowInternalInfo := true;
        end;
    }

    rendering
    {
        layout("./OmicronPurchOrder.rdlc")
        {
            Type = RDLC;
            LayoutFile = './OmicronPurchOrder.rdlc';
            Caption = 'Omicron RDLC Purchase Order';
            Summary = 'Omicron RDLC Purchase Order';
        }
        layout("./OmicronPurchOrder.docx")
        {
            Type = Word;
            LayoutFile = './OmicronPurchOrder.docx';
            Caption = 'Omicron Purchase Order';
            Summary = 'Omicron Purchase Order';
        }
        layout("./OmicronPurchOrderNoPrices.docx")
        {
            Type = Word;
            LayoutFile = './OmicronPurchOrderNoPrices.docx';
            Caption = 'Omicron No-Price Purchase Order';
            Summary = 'Omicron No-Price Purchase Order';
        }
    }
}