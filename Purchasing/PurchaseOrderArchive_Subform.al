pageextension 50181 PurchOrderArchiveSubExt extends "Purchase Order Archive Subform"
{
    layout
    {
        modify("Item Reference No.")
        { Visible = false; }
        modify(Quantity)
        { Style = Strong; }
        addafter(Description)
        {
            field("Vendor Item No."; Rec."Vendor Item No.")
            {
                ApplicationArea = all;
                Caption = 'Vendor Item No.';
            }
        }
        addafter("Deferral Code")
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
            }
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
            {
                ApplicationArea = All;
                Width = 8;
            }
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
        moveafter("Direct Unit Cost"; "Unit Cost (LCY)")
        moveafter("Unit Cost (LCY)"; "Unit Price (LCY)")
    }
}