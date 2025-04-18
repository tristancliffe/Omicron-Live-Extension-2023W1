pageextension 50171 PostedPurchInvoiceSubExt extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addbefore(Type)
        {
            field(IsJobLine; IsJobLine)
            { ApplicationArea = all; Caption = 'Job Line'; Editable = false; QuickEntry = false; }
        }
        modify("Item Reference No.")
        { Visible = false; }
        modify(Quantity)
        { Style = Strong; }
        addafter(Description)
        {
            field("Vendor Item No."; Rec."Vendor Item No.")
            { ApplicationArea = all; Caption = 'Vendor Item No.'; }
        }
        addafter("VAT %")
        {
            field("Gen. Prod. Posting Group2"; Rec."Gen. Prod. Posting Group")
            { ApplicationArea = All; style = Ambiguous; }
            field("VAT Prod. Posting Group1"; Rec."VAT Prod. Posting Group")
            { ApplicationArea = All; style = AttentionAccent; }
            field("Job No.1"; Rec."Job No.")
            { ApplicationArea = All; Width = 8; }
            field("Job Task No.1"; Rec."Job Task No.")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    Rec."Job Line Type" := Rec."Job Line Type"::Billable;

                end;
            }
            field("Job Line Type2"; Rec."Job Line Type")
            { ApplicationArea = All; }
            field("Job Unit Price2"; Rec."Job Unit Price")
            { ApplicationArea = All; Width = 8; }
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
            action(GLLedgerLink)
            {
                ApplicationArea = All;
                Image = GLJournal;
                Caption = 'G/L Ledger';
                RunObject = page "General Ledger Entries";
                RunPageLink = "G/L Account No." = field("No.");
                Description = 'See the G/L Ledger for this line';
                ToolTip = 'Opens the G/L Ledger for this line';
                Scope = Repeater;
                Visible = true;
                Enabled = Rec.Type = Rec.Type::"G/L Account";
            }
            action(VendorItems)
            {
                ApplicationArea = All;
                Image = ItemRegisters;
                Caption = 'Vendor Item List';
                Description = 'See the Vendor Item List for this line';
                ToolTip = 'Opens the Vendor Item List for this line';
                Visible = true;
                Enabled = Rec.Type = Rec.Type::Item;
                RunObject = Page "Item Vendor Catalog";
                RunPageLink = "Item No." = FIELD("No.");
                RunPageView = SORTING("Item No.");
            }
        }
    }

    var
        IsJobLine: Boolean;

    trigger OnAfterGetRecord()
    begin
        IsJobLineCheck();
    end;

    local procedure IsJobLineCheck()
    begin
        IsJobLine := false;
        if rec."Job No." <> '' then
            IsJobLine := true;
    end;
}