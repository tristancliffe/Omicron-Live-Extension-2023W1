pageextension 50225 ShipmentPlanningExt extends WSB_ShipmentPlanningAI
{
    Caption = 'Shipment Planning';
    layout
    {
        addafter("No.")
        {
            field("Shpfy Order No."; Rec."Shpfy Order No.")
            { ApplicationArea = All; ToolTip = 'Shows if the order was received via Shopify'; }
            field(Amount; Rec.Amount)
            { ApplicationArea = All; ToolTip = 'The value of the order excluding VAT'; }
        }
        moveafter("Shpfy Order No."; "Order Date", Status, AvailabilityIndicatorRed, AvailabilityIndicatorOrange, AvailabilityIndicatorGreen)
        moveafter("Sell-to Customer Name"; AvailabilityIndicatorShipment)
        moveafter("Shipment Date"; ShippingStatus, InvoiceStatus)
        modify(AvailabilityIndicatorGreen)
        { Width = 4; Tooltip = 'Has lines that can be shipped now'; }
        modify(AvailabilityIndicatorRed)
        { Width = 4; ToolTip = 'Has lines that cannot be shipped yet (no stock availability)'; }
        modify(AvailabilityIndicatorOrange)
        { Width = 4; ToolTip = 'Has lines that will soon be available to shop (purchase in progress)'; }
        modify(ShippingStatus)
        { Width = 4; }
        modify(InvoiceStatus)
        { Width = 4; }
    }
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        Rec.Ascending(false);
        Rec.FindFirst
    end;
}


// ,
//     {
//       "id": "6e269270-915c-4c53-919c-126cfcad6a76",
//       "name": "Inventory Availability Indicators",
//       "version": "1.52.0.0",
//       "publisher": "Apportunix"
//     }