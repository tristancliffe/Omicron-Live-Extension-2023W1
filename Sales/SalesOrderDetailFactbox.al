page 50118 "Sales Order Detail Factbox"
{
    Caption = 'Order Details';
    PageType = CardPart;
    SourceTable = "Sales Header";

    layout
    {
        area(content)
        {
            field("No."; Rec."No.") { ApplicationArea = Basic, Suite; Caption = 'Order No.'; }
            field("Your Reference"; Rec."Your Reference") { ApplicationArea = Basic, Suite; Caption = 'Your ref.'; }
            field("Assigned User ID"; Rec."Assigned User ID") { ApplicationArea = Basic, Suite; Caption = 'Assigned User'; }
            field("Shpfy Order No."; Rec."Shpfy Order No.") { ApplicationArea = Basic, Suite; Caption = 'Shopify No.'; }
            field("Order Notes"; Rec."Order Notes") { ApplicationArea = Basic, Suite; ShowCaption = false; ToolTip = 'Order notes'; MultiLine = true; }
            field("VAT Country/Region Code"; Rec."VAT Country/Region Code") { ApplicationArea = Basic, Suite; Caption = 'VAT Country'; }
        }
    }
}