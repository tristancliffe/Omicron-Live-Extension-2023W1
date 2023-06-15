tableextension 50113 RequisitionWorksheetTableExt extends "Requisition Line"
{
    fields
    {
        field(50100; Instock_ReqLine; Decimal) //! I didn't test Calculate Plan before deploying, so stuck with this now...
        {
            ObsoleteState = Removed;
            ObsoleteReason = 'Breaks the Calculate Plan routine';
        }
    }
}