pageextension 50225 ShipmentPlanningExt extends WSB_ShipmentPlanningAI
{
    Caption = 'Shipment Planning';
    layout
    {
        addafter("No.")
        {
            field(Amount; Rec.Amount)
            { ApplicationArea = All; }
        }
        moveafter("No."; "Order Date", Status, AvailabilityIndicatorRed, AvailabilityIndicatorOrange, AvailabilityIndicatorGreen)
        moveafter("Sell-to Customer Name"; AvailabilityIndicatorShipment)
        moveafter("Shipment Date"; ShippingStatus, InvoiceStatus)
        modify(AvailabilityIndicatorGreen)
        { Width = 4; }
        modify(AvailabilityIndicatorRed)
        { Width = 4; }
        modify(AvailabilityIndicatorOrange)
        { Width = 4; }
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