page 50117 "Purchase Order Detail Factbox"
{
    Caption = 'Order Details';
    PageType = CardPart;
    SourceTable = "Purchase Header";

    layout
    {
        area(content)
        {
            field("No."; Rec."No.") { ApplicationArea = Basic, Suite; Caption = 'Order No.'; }
            field("Your Reference"; Rec."Your Reference") { ApplicationArea = Basic, Suite; Caption = 'Your ref.'; }
            field("Vendor Invoice No."; Rec."Vendor Invoice No.") { ApplicationArea = Basic, Suite; Caption = 'Invoice No.'; }
            field("Order Notes"; Rec."Order Notes") { ApplicationArea = Basic, Suite; ShowCaption = false; ToolTip = 'Order notes'; MultiLine = true; }
            field("Prepayment %"; Rec."Prepayment %") { ApplicationArea = Basic, Suite; Caption = 'Prepayment %'; }
        }
    }
}