pageextension 50125 SalesInvSubformExt extends "Sales Invoice Subform"
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
                ToolTip = 'This column shows the quantity currently known to be in stock. Non-inventory and Service items show as 999';
                ApplicationArea = All;
                Visible = true;
                BlankZero = true;
                Style = StandardAccent;
                Width = 5;
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
        Items: Record Item;
    begin
        if Rec.Type <> Rec.Type::Item then
            Rec.Instock_SalesLine := 0
        else
            if Items.Get(Rec."No.") and (Items.Type = Items.Type::Inventory) then begin
                Items.CalcFields(Inventory);
                // Rec.Instock_SalesLine := Items.Inventory;
                // Rec.Modify();
                Rec.Validate(Instock_SalesLine, Items.Inventory);
                Rec.Modify();
                Commit();
            end
            else
                if Items.Get(Rec."No.") and ((Items.Type = Items.Type::"Non-Inventory") or (Items.Type = Items.Type::Service)) then begin
                    // Rec.Instock_SalesLine := 999;
                    // Rec.Modify();
                    Rec.Validate(Instock_SalesLine, 999);
                    Rec.Modify();
                    Commit();
                end
    end;
}