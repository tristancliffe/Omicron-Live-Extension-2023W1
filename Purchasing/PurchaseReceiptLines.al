pageextension 50210 PurchaseReceiptLinesExt extends "Purch. Receipt Lines"
{
    layout
    {
        addafter("Document No.")
        {
            field("Posting Date"; Rec."Posting Date")
            { ApplicationArea = All; Caption = 'Date'; }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Posting Date", "Buy-from Vendor No.");
        Rec.Ascending(false);
        Rec.FindFirst
    end;
}