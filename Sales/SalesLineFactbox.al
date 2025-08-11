pageextension 50165 SalesLineFactBoxExt extends "Sales Line FactBox"
{
    layout
    {
        addafter("Required Quantity")
        {
            group(Type)
            {
                ShowCaption = false;
                Visible = TypeExists;

                field(ShelfNo_SalesLine; Rec.ShelfNo_SalesLine)
                {
                    ApplicationArea = All;
                    Caption = 'Shelf';
                    Visible = true;
                    trigger OnDrillDown()
                    var
                        Items: Record Item;
                    begin
                        if Rec.ShelfNo_SalesLine = '' then
                            exit
                        else begin
                            Items.Reset();
                            Items.SetFilter("Shelf No.", Rec.ShelfNo_SalesLine);
                            if not Items.IsEmpty then
                                Page.Run(Page::"Item List", Items)
                        end;
                    end;
                }
                field(ItemType; Rec.ItemType_SalesLine) //ShowType())
                { ApplicationArea = All; Caption = 'Item Type'; Visible = true; DrillDown = false; }
                field(ItemVendor; Rec.Itemvendor_SalesLine)
                { ApplicationArea = All; Visible = true; Drilldown = true; }
                field(ItemVendorNo; Rec.ItemVendorNo_SalesLine)
                { ApplicationArea = All; Visible = true; DrillDown = false; }
                field(ItemQtyOnOrder_SalesLine; Rec.CalcItemQtyOnOrder_SalesLine)
                { ApplicationArea = All; Visible = true; DrillDown = true; }
            }
        }
        addafter(Attachments)
        {
            group(Notes)
            {
                Caption = 'Item Notes';
                Visible = NotesExist;

                field(ItemNotes_SalesLine; Rec.ItemNotes_SalesLine) //ShowNotes())
                {
                    ApplicationArea = All;
                    Caption = '';
                    MultiLine = true;
                    Visible = true;
                    DrillDown = false;
                }
            }
        }
        addbefore(ItemNo)
        {
            group(Image)
            {
                Visible = ImageExists;
                Caption = 'Item Image';
                ShowCaption = false;

                field(Image_SalesLine; Rec.Image_SalesLine)
                {
                    ApplicationArea = All;
                    Caption = '';
                }
            }
        }
    }

    var
        ImageExists: Boolean;
        NotesExist: Boolean;
        TypeExists: Boolean;
        Vendor: Code[20];
        VendorNo: Text[50];
        Item: Record Item;

    trigger OnAfterGetCurrRecord()
    begin
        ImageExists := true;
        NotesExist := true;
        TypeExists := true;
        if Rec.Image_SalesLine.Count = 0 then
            ImageExists := false;
        if Rec.Type <> Rec.Type::Item then
            TypeExists := false;
        If strlen(Rec.ItemNotes_SalesLine) = 0 then
            NotesExist := false;
    end;


    local procedure ShowType(): Enum "Item Type"
    begin
        if Rec.Type <> Rec.Type::Item then
            exit(Rec.ItemType_SalesLine::"Non-Inventory");
        exit(Rec.ItemType_SalesLine);
    end;

    local procedure ShowNotes(): text[1000]
    begin
        if Rec.Type <> Rec.Type::Item then
            exit('');
        exit(Rec.ItemNotes_SalesLine);
    end;
}