pageextension 50125 SalesInvSubformExt extends "Sales Invoice Subform"
{
    layout
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                GetInventory();
                AssemblyWarning();
            end;
        }
        modify(Quantity)
        { Style = Strong; }
        addafter(Description)
        {
            field("Work Done"; Rec."Work Done")
            {
                ApplicationArea = All;
                AssistEdit = true;

                trigger OnAssistEdit()
                var
                    Dialog: Page "Work Done Dialog";
                begin
                    Dialog.GetText(rec."Work Done");
                    if Dialog.RunModal() = Action::OK then
                        rec."Work Done" := Dialog.SaveText()
                end;
            }
        }
        addafter("Unit of Measure Code")
        {
            field(Instock_SalesLine; rec.Instock_SalesLine)
            {
                Editable = false;
                Caption = 'Qty in Stock';
                ApplicationArea = All;
                Visible = true;
                BlankZero = true;
                Style = StandardAccent;
                Width = 5;
                DecimalPlaces = 0 : 2;
            }
        }
        modify("Gen. Prod. Posting Group")
        { style = Ambiguous; }
        modify("VAT Prod. Posting Group")
        { style = AttentionAccent; }
        addafter(FilteredTypeField)
        {
            field("Job Task No.1"; Rec."Job Task No.")
            { ApplicationArea = All; }
            field("Job No.1"; Rec."Job No.")
            {
                ApplicationArea = All;
                Width = 8;
                trigger OnValidate()
                begin
                    Rec.ValidateShortcutDimCode(3, Rec."Job No.");
                    // Rec.Modify();
                    //Rec."Shortcut Dimension 2 Code" := Rec."Job No.";
                end;
            }
        }
        modify("Item Reference No.")
        { Visible = false; }
        modify("Unit Cost (LCY)")
        {
            Visible = true;
            Style = Ambiguous;
            Editable = false;
            BlankZero = true;
        }
        moveafter("Qty. Assigned"; "Unit Cost (LCY)")
        addafter("Line Amount")
        {
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = All;
                Visible = true;
                Editable = false;
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
        if Rec.Type <> Rec.Type::Item then
            Rec.Instock_SalesLine := 0
        else
            if Item.Get(Rec."No.") and (Item.Type = Item.Type::Inventory) then begin
                Item.CalcFields(Inventory);
                // Rec.Instock_SalesLine := Item.Inventory;
                // Rec.Modify();
                Rec.Validate(Instock_SalesLine, Item.Inventory);
                Rec.Modify();
                Commit();
            end
            else
                if Item.Get(Rec."No.") and ((Item.Type = Item.Type::"Non-Inventory") or (Item.Type = Item.Type::Service)) then begin
                    // Rec.Instock_SalesLine := 999;
                    // Rec.Modify();
                    Rec.Validate(Instock_SalesLine, 999);
                    Rec.Modify();
                    Commit();
                end
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
}