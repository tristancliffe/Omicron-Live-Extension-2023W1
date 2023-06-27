pageextension 50116 SalesInvoiceList extends "Sales Invoice List"
{
    layout
    {
        modify("External Document No.")
        { Visible = false; }
        modify("Location Code")
        { Visible = false; }
        modify("Sell-To Contact")
        { Visible = false; }
        addafter("Sell-to Customer Name")
        {
            field("Order Date98002"; Rec."Order Date")
            { ApplicationArea = All; }
            field("Your Reference50380"; Rec."Your Reference")
            {
                ApplicationArea = All;
                Width = 14;
            }
        }
        addafter("Your Reference50380")
        {
            field("Order Notes1"; Rec."Order Notes")
            { ApplicationArea = All; }
        }
        moveafter("Sell-to Customer Name"; Amount)
        addafter(Amount)
        {
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Incl. VAT';
            }
        }
        moveafter(Amount; Status)
        modify(Status)
        { Visible = true; }
        modify("Posting Date")
        { Visible = false; }
        modify("Due Date")
        { Visible = false; }
    }

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        Rec.Ascending(false);
    end;
}