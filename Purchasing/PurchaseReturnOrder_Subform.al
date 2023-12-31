pageextension 50148 PurchaseReturnOrderSubformExt extends "Purchase Return Order Subform"
{
    layout
    {
        addafter("Qty. Assigned")
        {
            field("Gen. Prod. Posting Group2"; Rec."Gen. Prod. Posting Group")
            { ApplicationArea = All; }
            field("VAT Prod. Posting Group1"; Rec."VAT Prod. Posting Group")
            { ApplicationArea = All; }
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
            { ApplicationArea = All; }
            field("Job Line Type2"; Rec."Job Line Type")
            { ApplicationArea = All; }
            field("Job Unit Price2"; Rec."Job Unit Price")
            {
                ApplicationArea = All;
                Width = 8;
            }
            field("Job Line Amount (LCY)2"; Rec."Job Line Amount (LCY)")
            { ApplicationArea = All; }
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
}