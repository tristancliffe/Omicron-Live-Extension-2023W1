// It defines a page extension with ID 50137 for the "Item Lookup" page.
// The layout of the page is modified by adding fields and moving them around.
// Two fields are added after the "Description" field: "Inventory" and "Shelf No.1".
// The "Shelf No.1" field is moved after "Unit Price", and "Unit Price" is moved after "Unit Cost", which is moved after "Base Unit of Measure".
// Another field is added after "Base Unit of Measure": "Item Category Code1", which is a modified version of the "Item Category Code" field.
// The "Item Category Code1" field is moved after "Vendor No.".
// Another field is added after "Vendor No.": "Assembly Status", which is a modified version of the "Assembly BOM" field.
// The "Routing No." field is modified to make it not visible and remove quick entry.
// The "Vendor Item No." field is modified to make it not visible.
pageextension 50137 ItemLookupExt extends "Item Lookup"
{
    layout
    {
        addafter(Description)
        {
            field(Inventory; Rec.Inventory)
            { ApplicationArea = All; }
            field("Shelf No.1"; Rec."Shelf No.")
            { ApplicationArea = All; }
        }
        moveafter("Shelf No.1"; "Unit Price", "Unit Cost", "Base Unit of Measure")
        addafter("Base Unit of Measure")
        {
            field("Item Category Code1"; Rec."Item Category Code")
            { ApplicationArea = All; }
        }
        moveafter("Item Category Code1"; "Vendor No.")
        addafter("Vendor No.")
        {
            field("Assembly Status"; Rec."Assembly BOM")
            { ApplicationArea = All; }
        }
        modify("Routing No.")
        {
            QuickEntry = false;
            Visible = false;
        }
        modify("Vendor Item No.")
        { Visible = false; }
    }
    // trigger OnOpenPage()
    // var
    //     ItemList: Page "Item List";
    // begin
    //     ItemList.SetTableView(Rec);
    //     ItemList.SetRecord(Rec);
    //     ItemList.LookupMode := true;

    //     Commit();
    //     if ItemList.RunModal() = ACTION::LookupOK then begin
    //         ItemList.GetRecord(Rec);
    //         CurrPage.Close();
    //     end;
    // end;
}
