report 50110 "Resource Admin Hours"
{
    ApplicationArea = All;
    Caption = 'Resource Admin Proportions';
    UsageCategory = ReportsAndAnalysis;
    Description = 'Resource Admin Proportion';
    ExcelLayoutMultipleDataSheets = true;
    DefaultRenderingLayout = "./OmicronResourceAdminProportion.xlsx";

    dataset
    {
        dataitem(JobPlanningLine; "Job Planning Line")
        {
            RequestFilterFields = "Planning Date";
            column(JobNo_JobPlanningLine; "Job No.") { }
            column(JobTaskNo_JobPlanningLine; "Job Task No.") { }
            column(LineType_JobPlanningLine; "Line Type") { }
            column(PlanningDate_JobPlanningLine; "Planning Date") { }
            column(Type_JobPlanningLine; "Type") { }
            column(No_JobPlanningLine; "No.") { }
            column(WorkDone_JobPlanningLine; "Work Done") { }
            column(Quantity_JobPlanningLine; Quantity) { }
            column(UnitCost_JobPlanningLine; "Unit Cost") { }
            column(TotalCost_JobPlanningLine; "Total Cost") { }
            column(UnitPrice_JobPlanningLine; "Unit Price") { }
            column(LineAmount_JobPlanningLine; "Line Amount") { }
            column(QtytoTransfertoInvoice_JobPlanningLine; "Qty. to Transfer to Invoice") { }
            column(QtyTransferredtoInvoice_JobPlanningLine; "Qty. Transferred to Invoice") { }
            column(InvoicePrice_JobPlanningLine; InvoicePrice) { }

            trigger OnAfterGetRecord()
            begin
                if Type <> Type::Resource then
                    CurrReport.Skip();
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
        // layout
        // {
        //     area(Content)
        //     {
        //         group(GroupName)                {                }
        //     }
        // }
        // actions
        // {
        //     area(Processing)            {            }
        // }
    }
    rendering
    {
        layout("./OmicronResourceAdminProportion.xlsx")
        {
            Type = Excel;
            LayoutFile = './OmicronResourceAdminProportion.xlsx';
            Caption = 'Resource Admin Proportions';
            Summary = 'Shows Proportion of Worked Hours spend on admin vs billable jobs';
        }
    }
}
