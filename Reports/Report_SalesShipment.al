reportextension 50110 OmicronSalesShipment extends "Standard Sales - Shipment"
{
    dataset
    {
    }

    rendering
    {
        layout("./OmicronSalesShipment.docx")
        {
            Type = Word;
            LayoutFile = './OmicronSalesShipment.docx';
            Caption = 'Omicron Sales Shipment';
            Summary = 'Omicron Sales Shipment (Delivery Note)';
        }
    }
}