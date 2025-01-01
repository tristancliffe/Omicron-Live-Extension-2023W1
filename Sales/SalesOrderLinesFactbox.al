page 50119 "Sales Order Lines Factbox"
{
    Caption = 'Order Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Sales Line";

    layout
    {
        area(content)
        {
            repeater(VendorList)
            {
                ShowCaption = false;
                field(Type; Rec.Type) { ApplicationArea = All; Visible = false; }
                field("No."; Rec."No.") { ApplicationArea = All; Visible = true; }
                field("Description"; Rec.Description) { ApplicationArea = Basic, Suite; }
            }
        }
    }
}