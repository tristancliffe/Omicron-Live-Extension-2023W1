page 50108 "Job Journal Factbox"
{
    Caption = 'Item Details';
    PageType = CardPart;
    SourceTable = Item;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(Type)
            {
                ShowCaption = false;
                Visible = TypeExists;
                field(UnitofMeasureCode; Rec."Sales Unit of Measure")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Unit of Measure Code';
                    ToolTip = 'Specifies the unit of measure that is used to determine the value in the Unit Price field on the sales line.';
                }
                field(ShelfNo; Rec."Shelf No.")
                {
                    ApplicationArea = All;
                    Caption = 'Shelf';
                    Visible = true;

                    trigger OnDrillDown()
                    var
                        Items: Record Item;
                    begin
                        if Rec."Shelf No." = '' then
                            exit
                        else begin
                            Items.Reset();
                            Items.SetFilter("Shelf No.", Rec."Shelf No.");
                            if not Items.IsEmpty then
                                Page.Run(Page::"Item List", Items)
                        end;
                    end;
                }
                field(NonStockShelfNo; Rec.NonStockShelf) { ApplicationArea = All; Caption = 'Non-Stock Shelf'; Visible = true; DrillDown = false; }
                field(ItemType; Rec.Type) { ApplicationArea = All; Caption = 'Item Type'; Visible = true; DrillDown = false; }
                field(ItemReplenishment; Rec."Replenishment System") { ApplicationArea = All; Caption = 'Replenishment'; Visible = true; DrillDown = false; }
                field(ItemVendor; Rec."Vendor No.") { ApplicationArea = All; Visible = true; Drilldown = true; }
                field(ItemVendorNo; Rec."Vendor Item No.") { ApplicationArea = All; Visible = true; DrillDown = false; }
                field(ItemQtyOnOrder; Rec."Qty. on Purch. Order") { ApplicationArea = All; Visible = true; DrillDown = true; }
                field(ItemReorderPolicy; Rec."Reordering Policy") { ApplicationArea = All; Caption = 'Reorder Policy'; Visible = true; DrillDown = false; }
                field(ItemReorderPoint; Rec."Reorder Point") { ApplicationArea = All; Caption = 'Reorder Qty'; Visible = true; DrillDown = false; }
                field(ItemReorderQty; Rec."Reorder Quantity") { ApplicationArea = All; Caption = 'Item Type'; Visible = OrderFixed; DrillDown = false; }
                field(ItemMaxInventory; Rec."Maximum Inventory") { ApplicationArea = All; Caption = 'Max Inventory'; Visible = OrderMax; DrillDown = false; }
            }
            group(Notes)
            {
                Caption = 'Item Notes';
                Visible = NotesExist;
                field(ItemNotes; Rec."Item Notes") //ShowNotes())
                {
                    ApplicationArea = All;
                    Caption = '';
                    MultiLine = true;
                    Visible = true;
                    DrillDown = false;
                }
            }
        }
    }

    var
        TypeExists: Boolean;
        NotesExist: Boolean;
        OrderFixed: Boolean;
        OrderMax: Boolean;


    trigger OnAfterGetCurrRecord()
    begin
        NotesExist := true;
        TypeExists := false;
        OrderFixed := true;
        OrderMax := true;
        if (Rec.Type = Rec.Type::Inventory) or (Rec.Type = Rec.Type::"Non-Inventory") then TypeExists := true;
        // if Rec.Type <> Rec.type::Inventory then IsInventory := false;
        // if Rec.Type <> Rec.type::"Non-Inventory" then IsNotInventory := false;
        If strlen(Rec."Item Notes") = 0 then NotesExist := false;
        if Rec."Reordering Policy" <> Rec."Reordering Policy"::"Fixed Reorder Qty." then OrderFixed := false;
        if Rec."Reordering Policy" <> Rec."Reordering Policy"::"Maximum Qty." then OrderMax := false;
    end;
}