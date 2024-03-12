pageextension 50129 SalesQuoteFormExt extends "Sales Quote Subform"
{
    layout
    {
        modify("No.")
        {
            trigger OnAfterValidate() // Triggered when a new line is entered
            begin
                GetInventory();
                CheckProfit();
                AssemblyWarning();
            end;
        }
        modify("Substitution Available")
        { Visible = true; }
        modify(Description)
        { QuickEntry = true; StyleExpr = CommentStyle; }
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
                Visible = false;
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
                DecimalPlaces = 0 : 2;
            }
        }
        modify("Item Reference No.")
        { Visible = false; }
        addafter("Qty. Assigned")
        {
            field("Gen. Prod. Posting Group2"; Rec."Gen. Prod. Posting Group")
            { ApplicationArea = All; style = Ambiguous; }
            field("VAT Prod. Posting Group1"; Rec."VAT Prod. Posting Group")
            { ApplicationArea = All; style = AttentionAccent; }
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
        addafter("Unit Cost (LCY)")
        {
            field("Line Profit"; Rec."Line Amount" - (Rec.Quantity * Rec."Unit Cost (LCY)"))
            { ApplicationArea = all; Editable = false; Caption = 'Line Profit'; ToolTip = 'The amount of profit, including customer discount but not invoice discount, on this line compared to the displayed cost'; }
        }
        moveafter("Qty. to Assemble to Order"; WSB_AvailabilityIndicator)
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

    var
        CommentStyle: Text;

    trigger OnAfterGetRecord() // Triggered on page load to update inventory field
    begin
        GetInventory;
        CommentStyle := SetCommentStyle();
    end;

    local procedure GetInventory()
    var
        Item: Record Item;
    begin
        //if (Rec.Type::Item.AsInteger() = 0) and (Rec."No." <> '') then
        if Rec.Type <> Rec.Type::Item then
            Rec.Instock_SalesLine := 0
        else
            if (Item.Get(Rec."No.")) and (Item.Type = Item.Type::Inventory) then begin
                Item.CalcFields(Inventory, "Reserved Qty. on Inventory");
                // Rec.Instock_SalesLine := Item.Inventory;
                // Rec.Modify();
                Rec.Validate(Rec.Instock_SalesLine, Item.Inventory - Item."Reserved Qty. on Inventory");
                Rec.Modify();
                Commit();
            end
            else
                if Item.Get(Rec."No.") and ((Item.Type = Item.Type::"Non-Inventory") or (Item.Type = Item.Type::Service)) then begin
                    // Rec.Instock_SalesLine := 999;
                    // Rec.Modify()
                    Rec.Validate(Rec.Instock_SalesLine, 999);
                    Rec.Modify();
                    Commit();
                end
    end;

    local procedure CheckProfit()
    begin
        if (rec."Unit Price" < rec."Unit Cost (LCY)") and ((Rec.Type = Rec.Type::Item) or (Rec.Type = Rec.Type::Resource)) then
            message('Selling price of %1 is less than cost price. Be sure to update selling price and any relevant sales orders', Rec."No.");
    end;

    local procedure AssemblyWarning()
    var
        ItemRec: Record Item;
    begin
        if ItemRec.Get(Rec."No.") and (ItemRec."Replenishment System" = ItemRec."Replenishment System"::Assembly) and (Rec.Instock_SalesLine = 0) then begin
            if ItemRec."Assembly Policy" = ItemRec."Assembly Policy"::"Assemble-to-Stock" then
                message('This is an assemble-to-stock ASSEMBLY, and should be assembled manually via Assembly Orders.\ \Using this item journal will probably result in stock levels being incorrect afterwards.')
        end
    end;

    procedure SetCommentStyle(): Text
    begin
        if Rec.Type = Rec.Type::" " then
            exit('Strong');
        exit('');
    end;
}