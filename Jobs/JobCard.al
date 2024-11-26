pageextension 50111 JobCardExt extends "Job Card"
{
    layout
    {
        modify(Description) { ShowMandatory = true; }
        addafter(Description)
        {
            field("Car Make/Model"; Rec."Car Make/Model") { MultiLine = false; ApplicationArea = All; ShowMandatory = true; }
            field("Project Notes"; Rec."Job Notes") { MultiLine = true; ApplicationArea = All; ShowCaption = false; QuickEntry = false; InstructionalText = 'Summary of job tasks required...'; }
        }
        modify(Status)
        {
            Style = Strong;
            trigger OnBeforeValidate()
            begin
                if rec.Status = rec.status::Completed then
                    if not confirm('Have you printed the Time Sheet Report for this project?', false) then
                        ERROR('Print the Time Sheet Report first');
            end;
        }
        addlast(General)
        {
            field("Parts Location"; Rec."Parts Location") { ApplicationArea = All; InstructionalText = 'Shelf Code'; }
            field("Vehicle Reg"; Rec."Vehicle Reg") { ApplicationArea = All; ToolTip = 'Vehicle registration number, where known'; ShowMandatory = true; InstructionalText = 'Reg. No.'; }
            field("Chassis No."; Rec.ChassisNo) { ApplicationArea = All; ShowMandatory = true; InstructionalText = 'Chassis No.'; }
            field("Engine No."; Rec.EngineNo) { ApplicationArea = All; ShowMandatory = true; InstructionalText = 'Engine No.'; }
            field(Mileage; Rec.Mileage) { ApplicationArea = All; ShowMandatory = true; InstructionalText = 'Mileage with units'; }
            field("Date of Arrival"; Rec."Date of Arrival") { ApplicationArea = All; ShowMandatory = true; }
            field("Customer Balance"; Rec."Customer Balance") { Caption = 'Customer Balance'; ApplicationArea = All; Editable = false; Importance = Standard; AutoFormatType = 1; BlankZero = true; }
            field("Job Customer Notes"; CustomerNotes)
            {
                MultiLine = true;
                Caption = 'Customer Notes';
                ShowCaption = false;
                InstructionalText = 'Customer Notes';
                ApplicationArea = All;
                Importance = Standard;
                ToolTip = 'This SHOULD be the customer notes brought across to the job';
                QuickEntry = false;
                Editable = true;

                trigger OnValidate()
                begin
                    RecCustomer."Customer Notes" := CustomerNotes;
                    RecCustomer.Modify()
                end;
            }
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
        addafter("Sell-to Customer Name")
        {
            field(ShowMap; ShowMapLbl)
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                ShowCaption = false;
                Style = StrongAccent;
                StyleExpr = TRUE;
                ToolTip = 'Specifies the customer''s address on your preferred map website.';

                trigger OnDrillDown()
                begin
                    CurrPage.Update(true);
                    Rec.DisplayMap();
                end;
            }
        }
        addfirst(factboxes)
        {
            part(CustomerPicture; "Customer Picture") { ApplicationArea = All; Caption = 'Picture'; SubPageLink = "No." = FIELD("Bill-to Customer No."); }
            part(SalesHistSelltoFactBox; "Sales Hist. Sell-to FactBox") { ApplicationArea = All; SubPageLink = "No." = field("Bill-to Customer No."); }
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
                ToolTip = 'Create project sales invoices report';
                Visible = true;

                trigger OnAction()
                begin
                    JobTask.SetFilter("Job No.", Rec."No.");
                    JobInvoice.SetTableView(JobTask);
                    JobInvoice.RunModal();
                    Clear(JobInvoice);
                end;
            }
            action(StockCard)
            {
                Caption = 'Stock Card';
                Image = ItemLines;
                ApplicationArea = All;
                RunObject = Page "Stock Card List";
                RunPageView = where(Entered = const(false));
                RunPageLink = "Job No." = field("No.");
                ToolTip = 'Opens the stock used list for the selected job';
                Visible = true;
            }
            action(JobJournal)
            {
                Caption = 'Project Journal';
                Image = JobJournal;
                ApplicationArea = All;
                RunObject = Page "Job Journal";
                ToolTip = 'Opens the project journal';
                Visible = true;
            }
            action(CustomerCard)
            {
                ApplicationArea = All;
                Image = Customer;
                Caption = 'Customer Card';
                RunObject = page "Customer Card";
                RunPageLink = "No." = field("Sell-to Customer No.");
                Description = 'Go to the Sell-To Customer''s Card';
                ToolTip = 'Opens the sell-to customer card for this project';
                Visible = true;
                Enabled = true;
            }
            action(SalesInvoiceList)
            {
                ApplicationArea = All;
                Image = SalesInvoice;
                Caption = 'Sales Invoices List';
                RunObject = page "Sales Invoice List";
                Description = 'Go to the list of all active Sales Invoice.';
                ToolTip = 'Opens the list of active sales invoices.';
                Visible = true;
                Enabled = true;
            }
            action("Report Timesheet Entries")
            {
                ApplicationArea = Suite;
                Caption = 'Time Sheet Report';
                Image = "Report";
                ToolTip = 'Open the Time Sheet report - print on Grey';

                trigger OnAction()
                begin
                    Job.SetFilter("No.", Rec."No.");
                    TimesheetReport.SetTableView(Job);
                    TimesheetReport.RunModal();
                    Clear(TimesheetReport);
                end;
            }
            action("Report Job Invoicing Excel")
            {
                ApplicationArea = Suite;
                Caption = 'Excel Invoice Planner';
                Image = "Report";
                ToolTip = 'Open the Excel worksheet for invoicing';

                trigger OnAction()
                begin
                    Job.SetFilter("No.", Rec."No.");
                    ExcelReport.SetTableView(Job);
                    ExcelReport.RunModal();
                    Clear(ExcelReport);
                end;
            }
            action("Job Card")
            {
                ApplicationArea = Suite;
                Caption = 'Job Card';
                Image = "Report";
                ToolTip = 'Produce a job card (Send to Word Document and save it in the job''s folder, and print on Orange)';

                trigger OnAction()
                begin
                    Job.SetFilter("No.", Rec."No.");
                    JobCard.SetTableView(Job);
                    JobCard.RunModal();
                    Clear(JobCard);
                end;
            }
            action("Job Invoice")
            {
                ApplicationArea = Suite;
                Caption = 'Job Invoice Template';
                Image = "Report";
                ToolTip = 'Produce a job invoice template (Send to Word document and save in the invoice folder)';

                trigger OnAction()
                begin
                    Job.SetFilter("No.", Rec."No.");
                    JobInvoiceTemplate.SetTableView(Job);
                    JobInvoiceTemplate.RunModal();
                    Clear(JobInvoiceTemplate);
                end;
            }
            action("Workshop Request")
            {
                ApplicationArea = Suite;
                Caption = 'Workshop Request Jobcard';
                Image = "Report";
                ToolTip = 'Produce the workshop request jobcard (Send to Word Document to edit, and print on Green paper)';

                trigger OnAction()
                begin
                    Job.SetFilter("No.", Rec."No.");
                    WorkshopRequest.SetTableView(Job);
                    WorkshopRequest.RunModal();
                    Clear(WorkshopRequest);
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref(StockCard_Promoted; StockCard) { }
            actionref(JobJournal_Promoted; JobJournal) { }
            actionref(JobPlanningLinesLink; JobPlanningLines) { }
            group(Invoicing)
            {
                ShowAs = SplitButton;
                actionref(CreateSalesInvoice_Promoted; CreateSalesInvoice) { }
                actionref(JobInvoices_Promoted; SalesInvoicesCreditMemos) { }
                actionref(SalesInvoiceList_Promoted; SalesInvoiceList) { }
            }
            actionref(CustomerCard_Promoted; CustomerCard) { }
            actionref(Dimensions_Promoted; "&Dimensions") { }
        }
        addfirst(Category_Process)
        {
            group(Reports)
            {
                ShowAs = SplitButton;
                Caption = 'Reports';
                ToolTip = 'Various Reports listed here.';
                actionref(ExcelJobInvoicing; "Report Job Invoicing Excel") { }
                actionref(PreviewQuote_Promoted; "Report Job Quote") { }
                actionref(SuggestedBilling_Promoted; "Job - Suggested Billing") { }
                actionref("Stock Card"; StockCard) { }
                actionref(JobCard; "Job Card") { }
                actionref(WorkshopRequest; "Workshop Request") { }
                actionref(JobInvoiceTemplate; "Job Invoice") { }
                actionref(TimesheetEntries; "Report Timesheet Entries") { }
            }
        }
        modify("Create Warehouse Pick_Promoted") { Visible = false; }
    }

    var
        Job: Record Job;
        JobTask: Record "Job Task";
        JobCard: Report "Service Instruction";
        JobInvoiceTemplate: Report "Job Invoice";
        WorkshopRequest: Report "Workshop Request";
        ExcelReport: Report "Job Billing Excel";
        TimesheetReport: Report "Timesheet Entries";
        JobInvoice: Report "Job Create Sales Invoice";
        ShowMapLbl: Label 'Show address on map';
        CustomerNotes: Text[2000];
        RecCustomer: Record Customer;

    procedure RunTimesheetReport()
    begin
        Job.SetFilter("No.", Rec."No.");
        TimesheetReport.SetTableView(Job);
    end;

    trigger OnInsertRecord(BelowXRec: Boolean): Boolean
    begin
        RecCustomer.SetRange("No.", Rec."Sell-to Customer No.");
        if RecCustomer.FindSet() then begin
            CustomerNotes := RecCustomer."Customer Notes";
            //MobileNo := RecCustomer."Mobile Phone No.";
        end;
    end;

    trigger OnOpenPage()
    begin
        RecCustomer.SetRange("No.", Rec."Sell-to Customer No.");
        if RecCustomer.FindSet() then begin
            CustomerNotes := RecCustomer."Customer Notes";
            //MobileNo := RecCustomer."Mobile Phone No.";
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        RecCustomer.SetRange("No.", Rec."Sell-to Customer No.");
        if RecCustomer.FindSet() then begin
            CustomerNotes := RecCustomer."Customer Notes";
            //MobileNo := RecCustomer."Mobile Phone No.";
        end;

    end;

    trigger OnAfterGetCurrRecord()
    begin
        RecCustomer.SetRange("No.", Rec."Sell-to Customer No.");
        if RecCustomer.FindSet() then begin
            CustomerNotes := RecCustomer."Customer Notes";
            //MobileNo := RecCustomer."Mobile Phone No.";
        end;
    end;
}