// This is a page extension for the "Assembly Order Subform".
// The extension modifies the layout of the page by adding a field for "Inventory", moving fields around and hiding the "Variant Code" field.
// There is also an action to open the item card for the selected line.
// There is a trigger that fires when a record is retrieved, and it calls a local procedure named "GetInventory".
// The "GetInventory" procedure retrieves the inventory of the item and sets the "Instock_AssemblyLine" field accordingly. If the item is non-inventory or a service, the field is set to 999.
pageextension 50160 AssemblyOrderExt extends "Assembly Order Subform"
{
    layout
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                GetInventory;
            end;
        }
        modify("Variant Code") { Visible = false; }
        addafter(Description)
        {
            field(Instock_AssemblyLine; Rec.Instock_AssemblyLine)
            {
                ApplicationArea = all;
                Caption = 'Inventory';
                Description = 'Quantity in stock';
                ToolTip = 'This column shows the quantity currently known to be in stock. Non-inventory and Service items show as 999';
                Editable = false;
                Style = StandardAccent;
                Width = 5;
                DecimalPlaces = 0 : 2;
            }
        }
        moveafter("Unit of Measure Code"; "Location Code")
        addafter("Unit of Measure Code")
        {
            field(ShelfNo_AssemblyLine; Rec.ShelfNo_AssemblyLine)
            {
                ApplicationArea = all;
                Caption = 'Shelf No.';
                Description = 'Shelf code in stores';
                Editable = false;
                DrillDown = false;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action(ItemCardLink)
            {
                ApplicationArea = All;
                Image = Item;
                Caption = 'Item Card';
                RunObject = page "Item Card";
                RunPageLink = "No." = field("No.");
                Description = 'Go to the Item Card';
                ToolTip = 'Opens the item card for this line';
                Scope = Repeater;
                Visible = true;
                Enabled = Rec.Type = Rec.Type::Item;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        GetInventory;
    end;

    local procedure GetInventory()
    var
        Item: Record Item;
    begin
        if Item.Get(Rec."No.") and (Item.Type = Item.Type::Inventory) then begin
            Item.CalcFields(Inventory, "Reserved Qty. on Inventory");
            // Rec.Instock_AssemblyLine := Item.Inventory;
            // Rec.Modify();
            Rec.Validate(Rec.Instock_AssemblyLine, Item.Inventory - Item."Reserved Qty. on Inventory");
            Rec.Modify();
            Commit();
        end
        else
            if Item.Get(Rec."No.") and ((Item.Type = Item.Type::"Non-Inventory") or (Item.Type = Item.Type::Service)) then begin
                // Rec.Instock_AssemblyLine := 999;
                // Rec.Modify()
                Rec.Validate(Instock_AssemblyLine, 999);
                Rec.Modify();
                Commit();
            end;
    end;
}