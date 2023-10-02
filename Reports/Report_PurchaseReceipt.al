reportextension 50113 PurchaseReceiptExt extends "Purchase - Receipt"
{
    dataset
    {
        add("Purch. Rcpt. Line")
        {
            column(ShelfNo; "Shelf No.")
            { }
            column(JobNo; "Job No.")
            { }
            column(Vendor_Item_No_; "Vendor Item No.")
            { }
        }
    }

    rendering
    {
        layout("./OmicronPurchaseReceipt.rdlc")
        {
            Type = RDLC;
            LayoutFile = './OmicronPurchaseReceipt.rdlc';
            Caption = 'Omicron Purchase Receipt';
            Summary = 'Omicron Purchase Reciept';
        }
    }
}