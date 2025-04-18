pageextension 50147 PurchaseCreditSubformExt extends "Purch. Cr. Memo Subform"
{
    layout
    {
        addbefore(Type)
        {
            field(IsJobLine; IsJobLine)
            { ApplicationArea = all; Caption = 'Job Line'; Editable = false; QuickEntry = false; }
        }
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
            { ApplicationArea = All; Width = 8; }
            field("Job Line Amount (LCY)2"; Rec."Job Line Amount (LCY)")
            { ApplicationArea = All; }
        }
        modify("Item Reference No.")
        { Visible = false; }
        addafter(Description)
        {
            field("Vendor Item No."; Rec."Vendor Item No.")
            { ApplicationArea = All; Visible = true; }
        }
        // modify("Total VAT Amount")
        // {
        //     trigger OnDrillDown()
        //     var
        //         PurchHeader: Record "Purchase Header";
        //     begin
        //         if PurchHeader.Get(Rec."Document Type", Rec."Document No.") then
        //             Page.Run(Page::"Purchase Statistics", PurchHeader)
        //         else
        //             Error('The related Purchase Header could not be found.');
        //     end;
        // }
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