pageextension 50128 PurchOrderSubformExt extends "Purchase Order Subform"
{
    layout
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                GetInventory();
                if (rec."Unit Price (LCY)" < rec."Unit Cost (LCY)") and ((Rec.Type = Rec.Type::Item) or (Rec.Type = Rec.Type::Resource)) and ((Rec."No." <> 'JOB-PURCHASES') or (Rec."No." <> 'TEXT')) then
                    message('Selling price of %1 is less than cost price. Be sure to update selling price and any relevant sales orders', Rec."No.")
            end;
        }
        modify(Quantity)
        { style = Strong; }
        modify("Bin Code")
        { Visible = false; }
        addafter(Description)
        {
            field("Vendor Item No.40789"; Rec."Vendor Item No.")
            { ApplicationArea = All; }
        }
        addafter("Unit of Measure Code")
        {
            field(Instock_PurchLine; rec.Instock_PurchLine)
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
        addafter("Expected Receipt Date")
        {
            field("VAT Prod. Posting Group1"; Rec."VAT Prod. Posting Group")
            { ApplicationArea = All; style = AttentionAccent; }
            field("Job No.1"; Rec."Job No.")
            {
                ApplicationArea = All;
                Width = 8;
                trigger OnValidate()
                begin
                    Rec.ValidateShortcutDimCode(3, Rec."Job No.");
                    Rec.Modify();
                    JobPriceMandatory := true;
                    //Rec."Shortcut Dimension 2 Code" := Rec."Job No.";
                end;
            }
            field("Job Task No.1"; Rec."Job Task No.")
            {
                ApplicationArea = All;
                ShowMandatory = JobPriceMandatory;
                trigger OnValidate()
                begin
                    Rec.Validate("Job Line Type", Rec."Job Line Type"::Billable)
                end;
            }
            field("Job Line Type2"; Rec."Job Line Type")
            { ApplicationArea = All; ShowMandatory = true; }
            field("Job Unit Price2"; Rec."Job Unit Price")
            { ApplicationArea = All; Width = 8; ShowMandatory = JobPriceMandatory; }
            field("Job Line Amount (LCY)2"; Rec."Job Line Amount (LCY)")
            { ApplicationArea = All; }
        }
        moveafter("Expected Receipt Date"; "Gen. Prod. Posting Group")
        moveafter("Direct Unit Cost"; "Unit Cost (LCY)", "Unit Price (LCY)", "Line Discount Amount", "Line Discount %")
        modify("Gen. Prod. Posting Group")
        { Style = Ambiguous; Visible = true; }
        modify("Direct Unit Cost")
        {
            trigger OnAfterValidate()
            begin
                if (rec."Unit Price (LCY)" < rec."Unit Cost (LCY)") and ((Rec.Type = Rec.Type::Item) or (Rec.Type = Rec.Type::Resource)) then
                    message('Selling price of %1 is less than cost price. Be sure to update selling price and any relevant sales orders', Rec."No.")
            end;
        }
        modify("Unit Price (LCY)")
        {
            Visible = true;
            Style = Ambiguous;
            Editable = false;
            BlankZero = true;
        }
        modify("Unit Cost (LCY)")
        {
            Visible = true;
            Style = Ambiguous;
            Editable = false;
            BlankZero = true;
        }
        modify("Line Discount Amount")
        { BlankZero = true; Visible = true; }
        modify("Line Discount %")
        { BlankZero = true; Visible = true; }
        modify("Qty. to Assign")
        { QuickEntry = true; }
        addafter("Line Amount")
        {
            field(LineAmountInclVAT; Rec."Amount Including VAT")
            { ApplicationArea = All; Visible = true; Caption = 'Line Amount incl. VAT'; }
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
                Enabled = true;
            }
        }
    }

    var
        JobPriceMandatory: Boolean;

    trigger OnAfterGetRecord()
    begin
        GetInventory;
        JobPriceMandatory := false;
    end;

    local procedure GetInventory()
    var
        Items: Record Item;
    begin
        if Rec.Type <> Rec.Type::Item then
            Rec.Instock_PurchLine := 0
        else
            if Items.Get(Rec."No.") and (Items.Type = Items.Type::Inventory) then begin
                Items.CalcFields(Inventory);
                Rec.Instock_PurchLine := Items.Inventory;
                Rec.Modify();
            end
            else
                if Items.Get(Rec."No.") and ((Items.Type = Items.Type::"Non-Inventory") or (Items.Type = Items.Type::Service)) then begin
                    Rec.Instock_PurchLine := 999;
                    Rec.Modify()
                end;
    end;
}