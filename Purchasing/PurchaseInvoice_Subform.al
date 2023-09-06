pageextension 50130 PurchInvSubformExt extends "Purch. Invoice Subform"
{
    layout
    {
        modify("Item Reference No.")
        { Visible = false; }
        modify(Quantity)
        { Style = Strong; }
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
            field("Job No.1"; Rec."Job No.")
            {
                ApplicationArea = All;
                Width = 8;
                trigger OnValidate()
                begin
                    Rec.ValidateShortcutDimCode(3, Rec."Job No.");
                    //Rec.Modify();
                    JobPriceMandatory := true;
                    if (Rec.Type = Rec.Type::"G/L Account") and (Rec."No." <> '1115') then
                        message('Using this G/L Account will probably result in the job invoice line not posting to a sales account. \Consider using ''Item: Job-Purchases'' instead.')
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
            { ApplicationArea = All; }
            field("Job Unit Price2"; Rec."Job Unit Price")
            { ApplicationArea = All; Width = 8; ShowMandatory = JobPriceMandatory; }
            field("Job Line Amount (LCY)2"; Rec."Job Line Amount (LCY)")
            { ApplicationArea = All; }
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
        moveafter("Direct Unit Cost"; "Unit Cost (LCY)", "Unit Price (LCY)")
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
}