reportextension 50115 RequisitionWorksheetExt extends "Calculate Plan - Req. Wksh."
{
    dataset
    {
        modify(Item)
        { RequestFilterFields = "Vendor No.", "Reorder Quantity", "Qty. on Purch. Order"; }
    }
}