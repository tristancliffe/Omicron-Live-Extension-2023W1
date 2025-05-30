pageextension 50136 PhysicalInventJournalExt extends "Phys. Inventory Journal"
{
    layout
    {
        addafter("Location Code")
        {
            field("Shelf No"; Rec.ShelfNo_ItemJournalLine)
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'Shelf';
                trigger OnDrillDown()
                var
                    Items: Record Item;
                begin
                    if Rec.ShelfNo_ItemJournalLine = '' then
                        exit
                    else begin
                        Items.Reset();
                        Items.SetFilter("Shelf No.", Rec.ShelfNo_ItemJournalLine);
                        if not Items.IsEmpty then
                            Page.Run(Page::"Item List", Items)
                    end;
                end;
            }
            field(AssemblyBOM; Rec.AssemblyBOM)
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'Assembly';
            }
            field("Last Physical Inventory"; Rec.LastPhysicalInventory)
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'Last Phys. Invt.';
            }
        }
        modify("Salespers./Purch. Code") { Visible = false; }
        modify(ShortcutDimCode4) { Visible = false; }
        modify(ShortcutDimCode5) { Visible = false; }
        modify(ShortcutDimCode3) { Visible = false; }
        modify("Shortcut Dimension 2 Code") { Visible = true; }
        modify("Shortcut Dimension 1 Code") { Visible = true; }
        modify("Applies-to Entry") { Visible = false; }
        addafter(JournalErrorsFactBox)
        {
            part(ItemPicture; "Item Picture")
            {
                ApplicationArea = All;
                Caption = 'Picture';
                SubPageLink = "No." = field("Item No.");
            }
            part(JobJournalFactbox; "Job Journal Factbox")
            {
                ApplicationArea = All;
                Visible = true;
                SubPageLink = "No." = field("Item No.");
            }
            part(VendorListFactbox; "Item Vendor List Factbox")
            {
                ApplicationArea = All;
                Visible = true;
                //Provider = PurchLines;
                SubPageLink = "Item No." = FIELD("Item No.");
                SubPageView = sorting("Vendor No.", "Vendor Item No.");
            }
        }
    }
    actions
    {
        addafter("Bin Contents")
        {
            action(ItemCardLink)
            {
                ApplicationArea = All;
                Image = Item;
                Caption = 'Item Card';
                RunObject = page "Item Card";
                RunPageLink = "No." = field("Item No.");
                Description = 'Go to the Item Card';
                ToolTip = 'Opens the item card for this line';
                Scope = Repeater;
                Visible = true;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        Item: Record "Item";
    begin
        if Rec."Item No." <> '' then begin
            if Item.Get(Rec."Item No.") then begin
                if Item."Replenishment System" = Item."Replenishment System"::Assembly then
                    Rec.AssemblyBOM := true
                else
                    Rec.AssemblyBOM := false;
            end
        end;
    end;
}