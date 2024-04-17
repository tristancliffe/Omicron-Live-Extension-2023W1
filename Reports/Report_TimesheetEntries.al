report 50100 "Timesheet Entries"
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "OmicronTimeSheetRecords.docx";
    Caption = 'Timesheet Entries';
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
            column(RegNo; "Vehicle Reg")
            { }
            column(ChassisNo; ChassisNo)
            { }
            column(EngineNo; EngineNo)
            { }
            dataitem("Job Planning Line"; "Job Planning Line")
            {
                DataItemLink = "Job No." = FIELD("No.");
                DataItemTableView = SORTING("Job No.", "Planning Date", "Line No.");
                RequestFilterFields = "Job Task No.", "Planning Date";
                //PrintOnlyIfDetail = true;
                column(JobTask; "Job Task No.")
                { }
                column(No; "No.")
                { }
                column(LineType; "Line Type")
                { }
                column(PlanningDate; Format("Planning Date", 0, 1))
                { }
                column(QtyInvoiced; "Qty. Invoiced")
                { }
                column(Quantity; Quantity)
                { }
                column(Type; "Type")
                { }
                column(WorkDone; WorkDoneDescription)
                { }
                column(Line_Description; "Job Planning Line".Description)
                { }
                column(Line_No_; "Line No.")
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
            { }
        }

        actions
        { }
    }

    rendering
    {
        layout("OmicronTimeSheetRecords.docx")
        {
            Type = Word;
            LayoutFile = 'OmicronTimeSheetRecords.docx';
            Caption = 'Omicron Timesheet Entries';
            Summary = 'Omicron Timesheet and stock entries for a project for historical archiving';
        }
    }

    labels
    {
        JobNoLbl = 'Project No.';
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
    end;

    var
        CompanyInfo: Record "Company Information";
        JobsSetup: Record "Jobs Setup";
        FormatAddr: Codeunit "Format Address";
        JobFilter: Text;
        WorkDoneDescription: Text;
        JobTaskFilter: Text;
        FirstLineHasBeenOutput: Boolean;
        PrintSection: Boolean;
        CurrReportPageNoCaptionLbl: Label 'Page';
        JobQuoteCaptLbl: Label 'Timesheet Entries';
        DescriptionCaptionLbl: Label 'Description';
        JobTaskNoCaptLbl: Label 'Prpject Task No.';
        QuantityLbl: Label 'Quantity';
        JobTaskTypeLbl: Label 'Project Task Type';
        NoLbl: Label 'No.';
        NewTaskGroup: Integer;
        HeaderJobTaskNo: Text[250];
        HeaderJobTask: Text[250];
}
