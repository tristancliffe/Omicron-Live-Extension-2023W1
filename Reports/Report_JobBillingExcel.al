report 50101 "Job Billing Excel"
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "./OmicronJobBillingExcel.xlsx";
    Caption = 'Job Calculator';
    Description = 'Used to calculate handwritten invoices for jobs';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Job; Job)
        {
            //PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";//, "Planning Date Filter";
            column(TodayFormatted; Format(Today, 0, 4))
            { }
            column(Job_No; "No.")
            { }
            column(Job_Description; Description)
            { }
            dataitem("Job Planning Line"; "Job Planning Line")
            {
                DataItemLink = "Job No." = FIELD("No.");
                DataItemTableView = SORTING("Job No.", "Planning Date", "Line No.");
                RequestFilterFields = "Job Task No.", "Contract Line", "Qty. to Transfer to Invoice", "Planning Date";
                //PrintOnlyIfDetail = true;
                column(JobPlanningLine_JobTaskNo; "Job Task No.")
                { }
                column(Number; "No.")
                { }
                column(JobPlanningLine_LineType; "Line Type")
                { }
                column(Planning_Date; "Planning Date")
                { }
                column(QtyInvoiced; "Qty. Invoiced")
                { }
                column(Quantity; Quantity)
                { }
                column(Type; "Type")
                { }
                column(Planning_Line_Description; "Job Planning Line".Description)
                { }
                column(Line_No_; "Line No.")
                { }
                column(WorkDone; "Work Done")
                { }
                column(Qty__to_Transfer_to_Invoice; "Qty. to Transfer to Invoice")
                { }
                column(Unit_Cost; "Unit Cost")
                { }
                column(InvoiceCost; InvoiceCost)
                { }
                column(Unit_Price; "Unit Price")
                { }
                column(InvoicePrice; InvoicePrice)
                { }
                column(VAT; VAT)
                { }
                column(InvoicePriceInclVAT; InvoicePriceInclVAT)
                { }

                trigger OnAfterGetRecord()
                begin
                    PrintSection := true;
                    if "Line Type" = "Line Type"::Budget then begin
                        PrintSection := false;
                        CurrReport.Skip();
                    end;
                    if "Work Done" = '' then
                        WorkDoneDescription := "Job Planning Line".Description
                    else
                        WorkDoneDescription := "Work Done";
                    if (InvoicedSelector = true) and ("Qty. to Transfer to Invoice" = 0) then begin
                        "Qty. to Transfer to Invoice" := "Qty. Invoiced";
                        // if "Qty. to Transfer to Invoice" = 0 then
                        //     CurrReport.Skip();
                    end;
                    if (InvoicedSelector = false) and ("Qty. Invoiced" <> 0) then
                        CurrReport.Skip();
                    if Quantity <> 0 then
                        InvoicePrice := round(("Line Amount" / Quantity) * "Qty. to Transfer to Invoice", 0.01);
                    InvoiceCost := round("Unit Cost" * "Qty. to Transfer to Invoice", 0.01);
                    VAT := round(InvoicePrice * 0.2, 0.01);
                    InvoicePriceInclVAT := round(InvoicePrice + VAT, 0.01);
                end;
            }
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(InvoiceOption; InvoicedSelector)
                {
                    ApplicationArea = All;
                    Caption = 'Include Invoiced Lines';
                    ToolTip = 'If this is selected, then the Quantity field will show the quantity invoiced if it has been invoiced. Otherwise it will only include the amount left to invoice.';
                }
            }
        }

        actions
        { }
    }

    rendering
    {
        layout("./OmicronJobBillingExcel.xlsx")
        {
            Type = Excel;
            LayoutFile = './OmicronJobBillingExcel.xlsx';
            Caption = 'Excel Job Invoice Calculator';
            Summary = 'Used to calculate and write handwritten job invoices and/or prepare quotes';
        }
    }

    labels
    {
        JobNoLbl = 'Job No.';
        JobDescriptionLbl = 'Description';
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        JobsSetup.Get();
    end;

    trigger OnPreReport()
    begin
        JobFilter := Job.GetFilters();
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
        JobTaskNoCaptLbl: Label 'Job Task No.';
        QuantityLbl: Label 'Quantity';
        JobTaskTypeLbl: Label 'Job Task Type';
        NoLbl: Label 'No.';
        NewTaskGroup: Integer;
        HeaderJobTaskNo: Text[250];
        HeaderJobTask: Text[250];
        InvoicedSelector: Boolean;
}
