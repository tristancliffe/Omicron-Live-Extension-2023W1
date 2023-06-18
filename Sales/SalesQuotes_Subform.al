pageextension 50129 SalesQuoteFormExt extends "Sales Quote Subform"
{
    layout
    {
        modify("No.")
        {
            trigger OnAfterValidate() // Triggered when a new line is entered
            begin
                GetInventory();
                if (rec."Unit Price" < rec."Unit Cost (LCY)") and ((Rec.Type = Rec.Type::Item) or (Rec.Type = Rec.Type::Resource)) then
                    message('Selling price of %1 is less than cost price. Be sure to update selling price and any relevant sales orders', Rec."No.")
            end;
        }
        modify(Description)
        { QuickEntry = true; }
        modify(Quantity)
        { style = Strong; }
        Modify("Qty. to Assemble to Order")
        { BlankZero = true; }
        Modify("Qty. to Assign")
        { QuickEntry = true; }
        addafter("Unit of Measure Code")
        {
            field(ItemType; Rec.ItemType_SalesLine)
            {
                ApplicationArea = All;
                Caption = 'Type';
                Visible = true;
                DrillDown = false;
            }
            field(Instock_SalesLine; rec.Instock_SalesLine)
            {
                Editable = false;
                Caption = 'Qty in Stock';
                ToolTip = 'This column shows the quantity currently known to be in stock. Non-inventory and Service items show as 999';
                ApplicationArea = All;
                Visible = true;
                BlankZero = true;
                Style = StandardAccent;
                Width = 5;
            }
        }
        modify("Item Reference No.")
        { Visible = false; }
        addafter("Qty. Assigned")
        {
            field("Gen. Prod. Posting Group2"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                style = Ambiguous;
            }
            field("VAT Prod. Posting Group1"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = All;
                style = AttentionAccent;
            }
            // field("Job No.1"; Rec."Job No.")
            // {
            //     ApplicationArea = All;
            //     Width = 8;
            //     trigger OnValidate()
            //     begin
            //         Rec.ValidateShortcutDimCode(3, Rec."Job No.");
            //         Rec.Modify();
            //         //Rec."Shortcut Dimension 2 Code" := Rec."Job No.";
            //     end;
            // }
            // field("Job Task No.1"; Rec."Job Task No.")
            // { ApplicationArea = All; }
        }
        addafter("Line Amount")
        {
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = All;
                Visible = true;
                Editable = false;
            }
        }
        modify("Unit Cost (LCY)")
        {
            Visible = true;
            Style = Ambiguous;
            Editable = false;
            BlankZero = true;
        }
        moveafter("Qty. Assigned"; "Unit Cost (LCY)")
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
                Enabled = true;
            }
        }
    }
    trigger OnAfterGetRecord() // Triggered on page load to update inventory field
    begin
        GetInventory;
    end;

    local procedure GetInventory()
    var
        Items: Record Item;
    begin
        //if (Rec.Type::Item.AsInteger() = 0) and (Rec."No." <> '') then
        if Rec.Type <> Rec.Type::Item then
            Rec.Instock_SalesLine := 0
        else
            if (Items.Get(Rec."No.")) and (Items.Type = Items.Type::Inventory) then begin
                Items.CalcFields(Inventory);
                Rec.Instock_SalesLine := Items.Inventory;
                // Rec.Modify();
            end
            else
                if Items.Get(Rec."No.") and ((Items.Type = Items.Type::"Non-Inventory") or (Items.Type = Items.Type::Service)) then
                    Rec.Instock_SalesLine := 999;
    end;
}