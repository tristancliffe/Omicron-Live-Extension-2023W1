pageextension 50211 PostedPurchReceiptSubformExt extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addafter("No.")
        {
            field("Vendor Item No."; Rec."Vendor Item No.")
            { ApplicationArea = All; Visible = true; }
        }
        modify("Item Reference No.")
        { Visible = false; }
        addafter("Unit of Measure Code")
        {
            field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
            { ApplicationArea = All; Visible = true; }
        }
    }
}