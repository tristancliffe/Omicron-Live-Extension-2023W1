pageextension 50229 PostedPurchaseLinesExt extends "Posted Purchase Invoice Lines"
{
    layout
    {
        addafter(Description)
        {
            field("Vendor Item No."; Rec."Vendor Item No.") { ApplicationArea = All; }
        }
        addafter("Document No.")
        {
            field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Document No.");
        Rec.Ascending := false;
        Rec.FindFirst;
    end;
}