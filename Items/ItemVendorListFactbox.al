page 50106 "Item Vendor List Factbox"
{
    Caption = 'Item Vendor List';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Item Vendor";
    //SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(VendorList)
            {
                ShowCaption = false;
                field("Item No."; Rec."Item No.")
                { ApplicationArea = All; Visible = false; }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendor';
                    ToolTip = 'Specifies the account name of the vendor.';
                }
                field("Vendor Item No."; Rec."Vendor Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendor Item No.';
                    ToolTip = 'Specifies the vendor''s item number';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Edit)
            {
                ApplicationArea = All;
                Caption = 'Edit';
                Image = Edit;
                RunObject = Page "Item Vendor Catalog";
                RunPageLink = "Item No." = FIELD("Item No.");
                RunPageView = SORTING("Vendor No.", "Vendor Item No.");
                ToolTip = 'View the list of vendors who can supply the item, and at which lead time.';
            }
        }
    }

    trigger OnOpenPage()
    begin
    end;
}