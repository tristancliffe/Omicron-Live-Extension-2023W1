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
        modify(AvailabilityIndicatorGreen) { Width = 4; Tooltip = 'Has lines that can be shipped now'; }
        modify(AvailabilityIndicatorRed) { Width = 4; ToolTip = 'Has lines that cannot be shipped yet (no stock availability)'; }
        modify(AvailabilityIndicatorOrange) { Width = 4; ToolTip = 'Has lines that will soon be available to shop (purchase in progress)'; }
        modify(ShippingStatus) { Width = 4; }
        modify(InvoiceStatus) { Width = 4; }
    }
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        Rec.Ascending(false);
        Rec.FindFirst
    end;
}

pageextension 50245 ShipmentPlanningSubExt extends WSB_ShipmentPlanningSubPageAI
{
    layout
    {
        addafter(WSB_AvailabilityIndicator)
        {
            field(Instock_SalesLine; Rec.Instock_SalesLine)
            {
                ApplicationArea = All;
                ToolTip = 'Indicates if the item is in stock';
                Editable = false;
                Caption = 'Qty in Stock';
                Visible = true;
                BlankZero = true;
                Style = StandardAccent;
                Width = 5;
                DecimalPlaces = 0 : 2;

                trigger OnDrillDown()
                var
                    ItemLedgerEntryRec: Record "Item Ledger Entry";
                    ItemLedgerEntryPageID: Integer;
                begin
                    ItemLedgerEntryPageID := Page::"Item Ledger Entries";
                    ItemLedgerEntryRec.SetRange("Item No.", Rec."No.");
                    PAGE.Run(ItemLedgerEntryPageID, ItemLedgerEntryRec);
                end;
            }
        }
    }
}