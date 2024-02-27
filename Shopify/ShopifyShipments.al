pageextension 50221 ShopifyShipmentErrorsExt extends "Posted Sales Shipments"
{
    layout
    {
        addafter("No. Printed")
        {
            field("Shpfy Order No."; Rec."Shpfy Order No.")
            { ApplicationArea = All; }
            field("Shpfy Fulfillment Id"; Rec."Shpfy Fulfillment Id")
            { ApplicationArea = All; }
        }
    }
}