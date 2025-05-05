pageextension 50232 PostedSalesInvoiceLineExt extends "Posted Sales Invoice Lines"
{
    layout
    {
        addbefore("Document No.")
        {
            field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
        }
        addafter("Line Discount %")
        {
            field("Unit Cost"; Rec."Unit Cost") { ApplicationArea = All; }
        }
        addfirst(factboxes)
        {
            part(ItemPicture; "Item Picture")
            {
                ApplicationArea = All;
                Caption = 'Picture';
                SubPageLink = "No." = field("No.");
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Document No.");
        Rec.Ascending := false;
        Rec.FindFirst;
    end;
}