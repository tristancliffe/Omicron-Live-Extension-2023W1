pageextension 50172 "ItemVendorCatalogExt" extends "Item Vendor Catalog"
{
    layout
    {
        modify("Item No.")
        { Visible = true; }
        modify("Variant Code")
        { Visible = false; }
        addafter("Item No.")
        {
            field(ItemDescription; Rec.ItemDescription)
            {
                Description = 'Item description';
                Caption = 'Item description';
                ToolTip = 'Item description from the item card record';
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
    views
    {
        // addfirst
        // {
        //     view(ItemsFromVendors)
        //     {
        //         Caption = 'Vendor List';
        //         OrderBy = ascending("Item No.");
        //         Filters = where("Vendor No." = field("No."));
        //     }
        // }
    }

    trigger OnAfterGetRecord()
    var
        LineItem: Record Item;
    begin
        if LineItem.Get(Rec."Item No.") then begin
            Rec.ItemDescription := LineItem.Description;
        end;
    end;
}