pageextension 50229 PostedPurchaseLinesExt extends "Posted Purchase Invoice Lines"
{
    layout
    {
        addafter(Description)
        {
            field("Vendor Item No."; Rec."Vendor Item No.")
            { ApplicationArea = All; }
        }
    }
}