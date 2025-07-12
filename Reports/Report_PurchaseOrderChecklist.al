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
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.") { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name") { }
            column(Your_Reference; "Your Reference") { }
            column(OrderNo; "No.") { }
            column(Order_Date; Format("Order Date", 0, 0)) { }
            column(Order_Notes; "Order Notes") { }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                column(Document_No_; "Document No.") { }
                column(Line_No_; "Line No.") { }
                column(No_; "No.") { }
                column(Vendor_Item_No_; "Vendor Item No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(ShelfNo_PurchLine; ShelfNo_PurchLine) { }
                column(ItemPicture; ItemTenantMedia.Content) { }

                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                begin
                    if (Type = Type::"Charge (Item)") or (Type = Type::" ") then CurrReport.Skip();
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
            Caption = 'Omicron Purchase Order Checklist';
            Summary = 'Omicron Purchase Order Checklist (for checking parcels before receiving the invoice)';
        }
    }
    var
        ItemTenantMedia: Record "Tenant Media";
}