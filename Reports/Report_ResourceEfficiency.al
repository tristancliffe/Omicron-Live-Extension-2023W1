report 50102 ResourceEfficiency
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = ResourceEfficiency;
    Caption = 'Resource Efficiency';
    Description = 'Used to show resource efficiency';
    PreviewMode = PrintLayout;
    ExcelLayoutMultipleDataSheets = true;

    dataset
    {
        dataitem(Resource; Resource)
        {
            RequestFilterFields = "No.", "Use Time Sheet";
            column(Name; Name)
            { }
            dataitem(ResourceLedgerEntries; "Res. Ledger Entry")
            {
                DataItemLink = "Resource No." = FIELD("No.");
                DataItemTableView = SORTING("Resource No.", "Posting Date");
                RequestFilterFields = "Posting Date";
                column(JobNo; "Job No.")
                { }
                column(PostingDate; "Posting Date")
                { }
                column(Quantity; Quantity)
                { }
                column(Description; Description)
                { }
                column(Work_Done; "Work Done")
                { }

                trigger OnAfterGetRecord()
                begin
                    PrintSection := true;
                    if ("Entry Type" <> "Entry Type"::Usage) then begin
                        PrintSection := false;
                        CurrReport.Skip();
                    end;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                if (Blocked = true) or (Type = Type::Machine) then begin
                    PrintSection := false;
                    CurrReport.Skip();
                end;
            end;
        }
        dataitem("Employee Absence"; Resource)
        {
            RequestFilterFields = "No.", "Use Time Sheet";
            column(Name2; Name)
            { }
            dataitem("Absence Data"; "Employee Absence")
            {
                DataItemLink = "Employee No." = FIELD("No.");
                DataItemTableView = sorting("Employee No.", "From Date");
                RequestFilterFields = "From Date";
                column(Employee_Absence__Employee_No__; "Employee No.")
                { }
                column(Employee_Absence__From_Date_; Format("From Date"))
                { }
                column(Employee_Absence__Cause_of_Absence_Code_; "Cause of Absence Code")
                { }
                column(Employee_Absence_Description; Description)
                { }
                column(Employee_Absence_Quantity; Quantity)
                { }
                column(Employee_Absence__Unit_of_Measure_Code_; "Unit of Measure Code")
                { }
            }
        }
    }


    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            { }
        }

        actions
        { }
    }

    rendering
    {
        layout(ResourceEfficiency)
        {
            Type = Excel;
            LayoutFile = 'OmicronResourceEfficiency.xlsx';
            Caption = 'Omicron Resource Efficiency';
            Summary = 'Report of resource usage and efficiency';
        }
    }

    labels
    { }

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        JobsSetup.Get();
    end;

    trigger OnPreReport()
    begin
        ResourceFilter := Resource.GetFilters();
        ResourceLedgerFilter := ResourceLedgerEntries.GetFilters();
        DateFilter := ResourceLedgerEntries.GetFilters();
    end;

    var
        CompanyInfo: Record "Company Information";
        JobsSetup: Record "Jobs Setup";
        PrintSection: Boolean;
        ResourceFilter: Text;
        ResourceLedgerFilter: Text;
        DateFilter: Text;
}
