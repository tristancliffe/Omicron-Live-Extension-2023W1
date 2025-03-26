report 50101 "Job Billing Excel"
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "./OmicronJobBillingExcel.xlsx";
    Caption = 'Project Calculator';
    Description = 'Used to calculate handwritten invoices for projects';
    PreviewMode = PrintLayout;
    ExcelLayoutMultipleDataSheets = true;

    dataset
    {
        dataitem(Data; Job)
        {
            //PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            //, "Planning Date Filter";
            column(TodayFormatted; Format(Today, 0, 4)) { }
            column(Job_No; "No.") { }
            column(Job_Description; Description) { }
            dataitem("Job Planning Line"; "Job Planning Line")
            {
                DataItemLink = "Job No." = FIELD("No.");
                DataItemTableView = SORTING("Job No.", "Planning Date", "Line No.");
                RequestFilterFields = "Job Task No.", "Qty. to Transfer to Invoice", "Planning Date";
                //PrintOnlyIfDetail = true;
                column(JobPlanningLine_JobTaskNo; "Job Task No.") { }
                column(Number; "No.") { }
                column(JobPlanningLine_LineType; "Line Type") { }
                column(Planning_Date; "Planning Date") { }
                column(QtyInvoiced; "Qty. Invoiced") { }
                column(Quantity; Quantity) { }
                column(Type; "Type") { }
                column(Planning_Line_Description; "Job Planning Line".Description) { }
                column(Line_No_; "Line No.") { }
                column(WorkDone; "Work Done") { }
                column(Qty__to_Transfer_to_Invoice; "Qty. to Transfer to Invoice") { }
                column(Unit_Cost; "Unit Cost") { }
                column(InvoiceCost; InvoiceCost) { }
                column(Unit_Price; "Unit Price") { }
                column(InvoicePrice; InvoicePrice) { }
                column(VAT; VAT) { }
                column(InvoicePriceInclVAT; InvoicePriceInclVAT) { }
                column(QtyTransferredToInvoice; "Qty. Transferred to Invoice") { }

                trigger OnAfterGetRecord()
                begin
                    PrintSection := true;
                    if not BudgetLinesOnly then begin
                        if "Line Type" = "Line Type"::Budget then begin
                            PrintSection := false;
                            CurrReport.Skip();
                        end;
                    end
                    else if BudgetLinesOnly then begin
                        if "Line Type" <> "Line Type"::Budget then begin
                            PrintSection := false;
                            CurrReport.Skip();
                        end;
                    end;
                    if "Work Done" = '' then
                        WorkDoneDescription := "Job Planning Line".Description
                    else
                        WorkDoneDescription := "Work Done";
                    if AllLinesSelector then begin
                        if ("Qty. Invoiced" > 0) or ("Qty. Transferred to Invoice" > 0) then
                            "Qty. to Transfer to Invoice" := "Qty. Invoiced"
                        else
                            "Qty. to Transfer to Invoice" := "Qty. to Transfer to Invoice";
                        InvoicePrice := round(("Unit Price (LCY)" * "Qty. to Transfer to Invoice") - "Line Discount Amount (LCY)", 0.01);
                        VAT := round(InvoicePrice * 0.2, 0.01);
                        InvoicePriceInclVAT := round(InvoicePrice + VAT, 0.01);
                    end
                    else begin
                        if InvoicedSelector then begin
                            if "Qty. to Transfer to Invoice" > 0 then
                                CurrReport.Skip();
                            "Qty. to Transfer to Invoice" := "Qty. Invoiced";
                            InvoicePrice := round(("Unit Price (LCY)" * "Qty. Invoiced") - "Line Discount Amount (LCY)", 0.01);
                            VAT := round(InvoicePrice * 0.2, 0.01);
                            InvoicePriceInclVAT := round(InvoicePrice + VAT, 0.01);
                        end
                        else if AddedToInvoiceSelector then begin
                            if "Qty. Invoiced" > 0 then
                                CurrReport.Skip();
                            "Qty. to Transfer to Invoice" := "Qty. Transferred to Invoice";
                            InvoicePrice := round(("Unit Price (LCY)" * "Qty. to Transfer to Invoice") - "Line Discount Amount (LCY)", 0.01);
                            VAT := round(InvoicePrice * 0.2, 0.01);
                            InvoicePriceInclVAT := round(InvoicePrice + VAT, 0.01);
                        end
                        else if BudgetLinesOnly then begin
                            "Qty. to Transfer to Invoice" := Quantity;
                            InvoicePrice := round(("Unit Price (LCY)" * "Qty. to Transfer to Invoice") - "Line Discount Amount (LCY)", 0.01);
                            VAT := round(InvoicePrice * 0.2, 0.01);
                            InvoicePriceInclVAT := round(InvoicePrice + VAT, 0.01);
                        end
                        else begin
                            if ("Qty. Invoiced" <> 0) then
                                CurrReport.Skip();
                            if ("Qty. to Transfer to Invoice" = 0) then
                                CurrReport.Skip();
                        end;
                    end;
                end;
            }
        }
        dataitem(Job_info; Job)
        {
            RequestFilterFields = "No.";
            column(Make_Model; "Car Make/Model") { }
            column(Registration; "Vehicle Reg") { }
            column(Chassis_No; ChassisNo) { }
            column(Engine_No; EngineNo) { }
            column(Mileage; Mileage) { }
            column(Job_Number; "No.") { }

            trigger OnAfterGetRecord()
            begin
                if "No." <> Data."No." then CurrReport.Skip();
            end;
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(AllLinesOption; AllLinesSelector)
                {
                    ApplicationArea = All;
                    Caption = 'Include all billable lines.';
                    ToolTip = 'If this is selected then all lines will be added to the report.';
                }
                field(InvoiceOption; InvoicedSelector)
                {
                    ApplicationArea = All;
                    Caption = 'Only include invoiced lines?';
                    ToolTip = 'If this is selected, then the Quantity field will show the quantity invoiced if it has been invoiced. Otherwise it will only include the amount left to invoice.';
                }
                field(AddedToInvoiceOption; AddedToInvoiceSelector)
                {
                    ApplicationArea = All;
                    Caption = 'Only include lines added to current invoice';
                    ToolTip = 'If this is selected, then only lines and quantities added to a current invoice will be exported.';
                }
                field(BudgetLinesOnly; BudgetLinesOnly)
                {
                    ApplicationArea = all;
                    Caption = 'Only include budget lines';
                    ToolTip = 'If this is selected, then only budget lines will be included in the report.';
                }
            }
        }
    }

    rendering
    {
        layout("./OmicronJobBillingExcel.xlsx")
        {
            Type = Excel;
            LayoutFile = './OmicronJobBillingExcel.xlsx';
            Caption = 'Omicron Excel Project Invoice Calculator';
            Summary = 'Used to calculate and write handwritten project invoices and/or prepare quotes';
        }
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        JobsSetup.Get();
    end;

    trigger OnPreReport()
    begin
        JobFilter := Data.GetFilters();
        JobTaskFilter := "Job Planning Line".GetFilters();
        // JobBillableFilter := "Job Planning Line"."Line Type";
        // QtyToTransfer := "Job Planning Line"."Qty. to Transfer to Invoice";
        // QtyInvoiced := "Job Planning Line"."Qty. Invoiced";
    end;

    var
        CompanyInfo: Record "Company Information";
        JobsSetup: Record "Jobs Setup";
        FormatAddr: Codeunit "Format Address";
        JobFilter: Text;
        WorkDoneDescription: Text;
        JobTaskFilter: Text;
        JobBillableFilter: Enum "Job Planning Line Line Type";
        QtyToTransfer: Decimal;
        QtyInvoiced: Decimal;
        FirstLineHasBeenOutput: Boolean;
        PrintSection: Boolean;
        CurrReportPageNoCaptionLbl: Label 'Page';
        JobQuoteCaptLbl: Label 'Timesheet Entries';
        DescriptionCaptionLbl: Label 'Description';
        JobTaskNoCaptLbl: Label 'Project Task No.';
        QuantityLbl: Label 'Quantity';
        JobTaskTypeLbl: Label 'Project Task Type';
        NoLbl: Label 'No.';
        JobNoLbl: Label 'Project No.';
        JobDescriptionLbl: Label 'Description';
        NewTaskGroup: Integer;
        HeaderJobTaskNo: Text[250];
        HeaderJobTask: Text[250];
        InvoicedSelector: Boolean;
        AddedToInvoiceSelector: Boolean;
        AllLinesSelector: Boolean;
        BudgetLinesOnly: Boolean;
}
