pageextension 50222 PostedPurchaseReceiptLines extends "Posted Purchase Receipt Lines"
{
    layout
    {
        addfirst(Control1)
        {
            field("Posting Date"; Rec."Posting Date")
            { ApplicationArea = All; }
        }
        addlast(Control1)
        {
            field("Unit Cost"; Rec."Unit Cost")
            { ApplicationArea = All; }
        }
        moveafter("Unit Cost"; "Order No.", "Job No.")
        modify("Order No.")
        { Visible = true; }
        modify("Job No.")
        { Visible = true; }
    }
}