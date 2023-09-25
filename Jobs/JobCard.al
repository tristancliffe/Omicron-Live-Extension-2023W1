pageextension 50111 JobCardExt extends "Job Card"
{
    layout
    {
        modify(Description)
        { ShowMandatory = true; }
        addafter(Description)
        {
            field("Car Make/Model"; Rec."Car Make/Model")
            {
                MultiLine = false;
                ApplicationArea = All;
                ToolTip = 'Make & model of car in for work';
                ShowMandatory = true;
            }
            field("Job Notes"; Rec."Job Notes")
            {
                MultiLine = true;
                ApplicationArea = All;
                ToolTip = 'Notes about the job';
            }
        }
        modify(Status)
        {
            Style = Strong;
            trigger OnBeforeValidate()
            begin
                if rec.Status = rec.status::Completed then
                    message('Don''t forget to print the timesheet report for filing.')
            end;
        }
        addlast(General)
        {
            field("Parts Location"; Rec."Parts Location")
            { ApplicationArea = All; ToolTip = 'Where at Omicron have the parts been stored - area, shelf number etc'; }
            field("Vehicle Reg"; Rec."Vehicle Reg")
            { ApplicationArea = All; ToolTip = 'Vehicle registration number, where known'; ShowMandatory = true; }
            field("Chassis No."; Rec.ChassisNo)
            { ApplicationArea = All; ToolTip = 'Chassis number, if known'; ShowMandatory = true; }
            field("Engine No."; Rec.EngineNo)
            { ApplicationArea = All; ToolTip = 'Engine number, if known'; ShowMandatory = true; }
            field(Mileage; Rec.Mileage)
            { ApplicationArea = All; ToolTip = 'Recording mileage on arrival'; ShowMandatory = true; }
            field("Date of Arrival"; Rec."Date of Arrival")
            { ApplicationArea = All; ToolTip = 'Date of arrival at Omicron'; ShowMandatory = true; }
        }
        moveafter("No."; Status)
        modify("Bill-to County") { Importance = Additional; }
        modify("Sell-to Customer No.") { Importance = Standard; ShowMandatory = true; }
        modify(SellToPhoneNo) { Importance = Standard; }
        modify(SellToMobilePhoneNo) { Importance = Standard; }
        modify(SellToEmail) { Importance = Standard; }
        modify("Search Description") { Importance = Standard; }
        modify("External Document No.") { Visible = true; Importance = Standard; }
        modify("Your Reference") { Visible = true; Importance = Standard; }
        // addafter(SellToPhoneNo)
        // {
        //     field("Sell-to Mobile Number"; Rec."Sell-to Mobile Number")
        //     { ApplicationArea = All; Importance = Standard; }
        // }
        addafter("Payment Method Code")
        {
            field("Next Invoice Date"; Rec."Next Invoice Date")
            { ApplicationArea = All; Importance = Promoted; }
        }
        addfirst(factboxes)
        {
            part(CustomerPicture; "Customer Picture")
            {
                ApplicationArea = All;
                Caption = 'Picture';
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
            }
        }
    }
    actions
    {
        addlast("&Job")
        {
            action(CreateSalesInvoice)
            {
                Caption = 'Create Sales Invoice';
                Image = SalesInvoice;
                ApplicationArea = All;
                //RunObject = Report "Job Create Sales Invoice";
                ToolTip = 'Create job sales invoices report';
                Visible = true;

                trigger OnAction()
                var
                    JobTask: Record "Job Task";
                    JobInvoice: Report "Job Create Sales Invoice";
                begin
                    JobTask.SetFilter("Job No.", Rec."No.");
                    JobInvoice.SetTableView(JobTask);
                    JobInvoice.RunModal();
                end;
            }
            action(JobJournal)
            {
                Caption = 'Job Journal';
                Image = JobJournal;
                ApplicationArea = All;
                RunObject = Page "Job Journal";
                ToolTip = 'Opens the job journal';
                Visible = true;
            }
            action(CustomerCard)
            {
                ApplicationArea = All;
                Image = Item;
                Caption = 'Customer Card';
                RunObject = page "Customer Card";
                RunPageLink = "No." = field("Sell-to Customer No.");
                Description = 'Go to the Sell-To Customer''s Card';
                ToolTip = 'Opens the sell-to customer card for this job';
                Visible = true;
                Enabled = true;
            }
            action(SalesInvoiceList)
            {
                ApplicationArea = All;
                Image = SalesInvoice;
                Caption = 'Sales Invoices List';
                RunObject = page "Sales Invoice List";
                Description = 'Go to the Sales Invoice list.';
                ToolTip = 'Opens the list of sales invoices.';
                Visible = true;
                Enabled = true;
            }
            action("Report Timesheet Entries")
            {
                ApplicationArea = Suite;
                Caption = 'Time Sheet Report';
                Image = "Report";
                ToolTip = 'Open the Time Sheet report.';

                trigger OnAction()
                var
                    Job: Record Job;
                    TimesheetReport: Report "Timesheet Entries";
                begin
                    Job.SetFilter("No.", Rec."No.");
                    TimesheetReport.SetTableView(Job);
                    TimesheetReport.RunModal();
                end;
            }
            action("Report Job Invoicing Excel")
            {
                ApplicationArea = Suite;
                Caption = 'Excel Invoice Planner';
                Image = "Report";
                ToolTip = 'Open the Excel worksheet for invoicing';

                trigger OnAction()
                var
                    Job: Record Job;
                    TimesheetReport: Report "Job Billing Excel";
                begin
                    Job.SetFilter("No.", Rec."No.");
                    TimesheetReport.SetTableView(Job);
                    TimesheetReport.RunModal();
                end;
            }
            action("Job Card")
            {
                ApplicationArea = Suite;
                Caption = 'Job Card';
                Image = "Report";
                ToolTip = 'Produce a job card';

                trigger OnAction()
                var
                    Job: Record Job;
                    JobCard: Report "Service Instruction";
                begin
                    Job.SetFilter("No.", Rec."No.");
                    JobCard.SetTableView(Job);
                    JobCard.RunModal();
                end;
            }
            action("Workshop Request")
            {
                ApplicationArea = Suite;
                Caption = 'Workshop Request Jobcard';
                Image = "Report";
                ToolTip = 'Produce the workshop request jobcard';

                trigger OnAction()
                var
                    Job: Record Job;
                    WorkshopRequest: Report "Workshop Request";
                begin
                    Job.SetFilter("No.", Rec."No.");
                    WorkshopRequest.SetTableView(Job);
                    WorkshopRequest.RunModal();
                end;
                //     ReportParameters: text;
                //     TempBlob: Codeunit "Temp Blob";
                //     FileManagement: Codeunit "File Management";
                //     OStream: OutStream;
                // begin
                //     Clear(ReportParameters);
                //     Clear(OStream);
                //     Job.SetFilter("No.", Rec."No.");
                //     WorkshopRequest.SetTableView(Job);
                //     ReportParameters := Report.RunRequestPage(50103);
                //     TempBlob.CreateOutStream(OStream);
                //     Report.SaveAs(50103, ReportParameters, ReportFormat::Word, OStream);
                //     FileManagement.BLOBExport(TempBlob, Format(Job."No.") + '_' + 'WorkshopRequest' + '_' + Format(CURRENTDATETIME, 0, '<Day,2><Month,2><Year4>') + '.docx', true);
                // end;
            }
        }
        // addafter("Report Job Quote")
        // {
        //     action("Excel Report")
        //     {
        //         ApplicationArea = All;
        //         Caption = 'Excel Report';
        //         Description = 'Downloads an excel report for this job to analyse costs and prices for writing the invoice.';
        //         Image = Excel;

        //         trigger OnAction()
        //         var
        //             ReportSelection: Record "Report Layout Selection";
        //             JobHeader: Record Job;
        //         begin
        //             CurrPage.SetSelectionFilter(JobHeader);
        //             ReportSelection.SetTempLayoutSelected('1016-000006');
        //             Report.Run(Report::"Job Quote", true, true, JobHeader)
        //         end;
        //     }
        // }
        addlast(Category_Process)
        {
            actionref(JobJournal_Promoted; JobJournal)
            { }
            actionref(JobPlanningLinesLink; JobPlanningLines)
            { }
            group(Invoicing)
            {
                ShowAs = SplitButton;
                actionref(CreateSalesInvoice_Promoted; CreateSalesInvoice)
                { }
                actionref(SalesInvoiceList_Promoted; SalesInvoiceList)
                { }
            }
            actionref(CustomerCard_Promoted; CustomerCard)
            { }
            actionref(Dimensions_Promoted; "&Dimensions")
            { }
        }
        addfirst(Category_Process)
        {
            group(Reports)
            {
                ShowAs = SplitButton;
                Caption = 'Reports';
                ToolTip = 'Various Reports listed here.';
                actionref(ExcelJobInvoicing; "Report Job Invoicing Excel")
                { }
                actionref(PreviewQuote_Promoted; "Report Job Quote")
                { }
                actionref(SuggestedBilling_Promoted; "Job - Suggested Billing")
                { }
                actionref(JobCard; "Job Card")
                { }
                actionref(WorkshopRequest; "Workshop Request")
                { }
                actionref(TimesheetEntries; "Report Timesheet Entries")
                { }
            }
            // actionref(ExcelReport_Promoted; "Excel Report")
            // { }
        }
        modify("Create Warehouse Pick_Promoted")
        { Visible = false; }
    }
}