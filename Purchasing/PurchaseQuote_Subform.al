pageextension 50126 PurchQuoteSubformExt extends "Purchase Quote Subform"
{
    layout
    {
        modify("No.")
        {
            trigger OnAfterValidate() // Triggered when a new line is entered
            begin
                GetInventory();
            end;
        }
        modify(Description)
        { QuickEntry = true; StyleExpr = CommentStyle; }
        modify(Quantity)
        { style = Strong; }
        addafter(Description)
        {
            field("Vendor Item No."; Rec."Vendor Item No.")
            { ApplicationArea = All; }
        }
        addafter("Unit of Measure Code")
        {
            field(Instock_PurchLine; rec.Instock_PurchLine)
            {
                Editable = false;
                Caption = 'Qty in Stock';
                ApplicationArea = All;
                Visible = true;
                BlankZero = true;
                Style = StandardAccent;
                Width = 5;
                DecimalPlaces = 0 : 2;

                trigger OnDrillDown()
                var
                    ItemLedgerEntryRec: Record "Item Ledger Entry";
                    ItemLedgerEntryPageID: Integer;
                begin
                    ItemLedgerEntryPageID := Page::"Item Ledger Entries";
                    ItemLedgerEntryRec.SetRange("Item No.", Rec."No.");
                    PAGE.Run(ItemLedgerEntryPageID, ItemLedgerEntryRec);
                end;
            }
        }
        movebefore("Qty. to Assign"; "VAT Prod. Posting Group")
        modify("VAT Prod. Posting Group") { Visible = true; Style = AttentionAccent; }
        addafter("Qty. Assigned")
        {
            field("VAT Prod. Posting Group1"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = All;
                style = AttentionAccent;
            }
            field("Job No.1"; Rec."Job No.")
            {
                ApplicationArea = All;
                Width = 8;
                trigger OnValidate()
                begin
                    Rec.ValidateShortcutDimCode(3, Rec."Job No.");
                    // Rec.Modify()
                    //Rec."Shortcut Dimension 2 Code" := Rec."Job No.";
                end;
            }
            field("Job Task No.1"; Rec."Job Task No.")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    Rec.Validate("Job Line Type", Rec."Job Line Type"::Billable)
                end;
            }
            field("Job Line Type2"; Rec."Job Line Type")
            {
                ApplicationArea = All;
                ShowMandatory = true;
            }
            field("Job Unit Price2"; Rec."Job Unit Price")
            {
                ApplicationArea = All;
                Width = 8;
            }
            field("Job Line Amount (LCY)2"; Rec."Job Line Amount (LCY)")
            { ApplicationArea = All; }
        }
        moveafter("Qty. Assigned"; "Gen. Prod. Posting Group")
        modify("Gen. Prod. Posting Group")
        {
            Style = Ambiguous;
        }
        // addafter("Qty. Assigned")
        // {
        //     field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
        //     {
        //         ApplicationArea = All;
        //         Style = Ambiguous;
        //     }
        // }
        modify("Item Reference No.")
        { Visible = false; }
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
        moveafter("Direct Unit Cost"; "Unit Cost (LCY)", "Unit Price (LCY)")
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

    trigger OnAfterGetRecord()
    begin
        GetInventory;
        CommentStyle := SetCommentStyle();
    end;

    local procedure GetInventory()
    var
        Item: Record Item;
    begin
        if Rec.Type <> Rec.Type::Item then
            Rec.Instock_PurchLine := 0
        else
            if Item.Get(Rec."No.") and (Item.Type = Item.Type::Inventory) then begin
                Item.CalcFields(Inventory, "Reserved Qty. on Inventory");
                // Rec.Instock_PurchLine := Item.Inventory;
                // Rec.Modify();
                Rec.Validate(Instock_PurchLine, Item.Inventory - Item."Reserved Qty. on Inventory")
            end
            else
                if Item.Get(Rec."No.") and ((Item.Type = Item.Type::"Non-Inventory") or (Item.Type = Item.Type::Service)) then begin
                    // Rec.Instock_PurchLine := 999;
                    // Rec.Modify()
                    Rec.Validate(Instock_PurchLine, 999)
                end;
    end;

    procedure SetCommentStyle(): Text
    begin
        If Rec.Type = Rec.Type::" " then
            exit('Strong');
        exit('');
    end;
}