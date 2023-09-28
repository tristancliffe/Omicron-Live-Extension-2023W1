report 50105 "Purchase Order Checklist"
{
    ApplicationArea = All;
    Caption = 'Purchase Order Checklist';
    Description = 'Checking list for receiving purchase orders from suppliers';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = PurchaseOrderChecklist;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.")
            { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name")
            { }
            column(Your_Reference; "Your Reference")
            { }
            column(OrderNo; "No.")
            { }
            column(Order_Date; Format("Order Date", 0, 0))
            { }
            column(Order_Notes; "Order Notes")
            { }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                column(Document_No_; "Document No.")
                { }
                column(Line_No_; "Line No.")
                { }
                column(No_; "No.")
                { }
                column(Vendor_Item_No_; "Vendor Item No.")
                { }
                column(Description; Description)
                { }
                column(Quantity; Quantity)
                { }
                column(ShelfNo_PurchLine; ShelfNo_PurchLine)
                { }
            }
        }
    }
    // requestpage
    // {
    //     AboutTitle = 'Teaching tip title';
    //     AboutText = 'Teaching tip content';
    //     layout
    //     {
    //         area(Content)
    //         {
    //             group(GroupName)
    //             {
    //                 field(Name; SourceExpression)
    //                 { ApplicationArea = All; }
    //             }
    //         }
    //     }
    // 
    // actions
    // {
    //     area(processing)
    //     {
    //         action(LayoutName)
    //         {
    //             ApplicationArea = All;

    //         }
    //     }
    // }
    // }

    rendering
    {
        layout(PurchaseOrderChecklist)
        {
            Type = Word;
            LayoutFile = 'OmicronPurchOrderChecklist.docx';
        }
    }
}