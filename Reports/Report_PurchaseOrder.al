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

    rendering
    {
        layout("./OmicronPurchOrder.rdlc")
        {
            Type = RDLC;
            LayoutFile = './OmicronPurchOrder.rdlc';
            Caption = 'Standard RDLC Purchase Order';
            Summary = 'Omicron Standard Purchase Order';
        }
        layout("./OmicronPurchOrder.docx")
        {
            Type = Word;
            LayoutFile = './OmicronPurchOrder.docx';
            Caption = 'Standard Word Purchase Order';
            Summary = 'Omicron Standard Purchase Order';
        }
    }
}
