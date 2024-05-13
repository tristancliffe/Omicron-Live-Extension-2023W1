pageextension 50234 SalesOrderStatisticsExt extends "Sales Order Statistics"
{
    layout
    {
        modify(NoOfVATLines_Invoicing)
        { Importance = Standard; }
    }
}