pageextension 50112 JobListExtension extends "Job List"
{
    layout
    {
        modify(Control1)
        { FreezeColumn = Description; }
        moveafter("Search Description"; "Status")
        modify("Search Description")
        { Visible = false; }
        modify("Status")
        { Visible = true; }
        addafter(Status)
        {
            field("Car Make/Model"; Rec."Car Make/Model")
            { ApplicationArea = All; ToolTip = 'Car make/model'; }
            field("Vehicle Reg"; Rec."Vehicle Reg")
            { ApplicationArea = All; ToolTip = 'Registration No.'; }
            field("Job Notes"; Rec."Job Notes")
            { ApplicationArea = All; ToolTip = 'Job notes'; }
            field("Date of Arrival"; Rec."Date of Arrival")
            { ApplicationArea = All; ToolTip = 'Date of arrival at Omicron'; }
            field(TotalHours; Rec.TotalHours)
            { ApplicationArea = All; BlankZero = true; ToolTip = 'The total number of HOURS entered against the job, regardless of adjustments and invoicing'; Width = 8; }
            field(InvoicedHours; Rec.InvoicedHours)
            { ApplicationArea = All; BlankZero = true; ToolTip = 'The total number of INVOICED HOURS entered against the job'; Width = 8; }
            field(ToInvoice; Rec.ToInvoice)
            { ApplicationArea = All; StyleExpr = InvoiceStyle; BlankZero = true; }
            field(TotalValue; Rec.TotalValue)
            { ApplicationArea = All; Visible = false; Caption = 'Total Cost, £'; ToolTip = 'The value committed to the job so far.'; }
            field(InvoicedValue; Rec.InvoicedValue)
            { ApplicationArea = All; Visible = false; Caption = 'Total Invoiced, £'; ToolTip = 'The value invoiced to date.'; }
            field(ProfitToDate; -(Rec.TotalValue + Rec.InvoicedValue))
            { ApplicationArea = All; StyleExpr = ProfitStyle; BlankZero = true; Visible = false; Caption = 'Profit to date, £'; ToolTip = 'The profit made so far'; }
        }
        moveafter("Date of Arrival"; "Person Responsible")
        modify("Person Responsible")
        { Visible = false; ToolTip = 'Whom is ''doing'' the job, or whom is responsible for it.'; }
        moveafter(Control1905650007; Control1907234507, Control1902018507)
        modify(Control1907234507)
        { Visible = true; }
        modify(Control1902018507)
        { Visible = true; }
    }
    actions
    {
        addafter("Create Job &Sales Invoice")
        {
            action(CreateSalesInvoice)
            {
                ApplicationArea = Jobs;
                Caption = 'Create Job &Sales Invoice';
                Image = JobSalesInvoice;
                ToolTip = 'Use a batch job to help you create job sales invoices for the involved job planning lines.';
                Visible = true;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    JobTask: Record "Job Task";
                    JobInvoice: Report "Job Create Sales Invoice";
                begin
                    JobTask.SetFilter("Job No.", Rec."No.");
                    JobInvoice.SetTableView(JobTask);
                    JobInvoice.RunModal();
                    Clear(JobInvoice);
                end;
            }
            action(SalesInvoiceList)
            {
                Caption = 'Sales Invoices';
                Image = SalesInvoice;
                ApplicationArea = All;
                RunObject = Page "Sales Invoice List";
                ShortcutKey = 'Shift+Ctrl+I';
                ToolTip = 'Takes the user to the Sales Invoices list page';
                Visible = true;
                Promoted = true;
                PromotedCategory = Process;
            }
            action(JobJournal)
            {
                Caption = 'Job Journal';
                Image = JobJournal;
                ApplicationArea = All;
                RunObject = Page "Job Journal";
                ToolTip = 'Open the Job Journal for posting to jobs';
                Visible = true;
                Promoted = true;
                PromotedCategory = Process;
            }
        }
        modify("Create Job &Sales Invoice")
        { Visible = false; }
        addlast(reporting)
        {
            action("Report Resource Efficiency")
            {
                ApplicationArea = Suite;
                Caption = 'Resource Efficiency';
                Image = HumanResources;
                ToolTip = 'Open the Excel worksheet for resource usage, profitability and efficiency';
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    Resource: Record Resource;
                    TimesheetReport: Report ResourceEfficiency;
                begin
                    //Resource.SetFilter("No.", Rec."No.");
                    TimesheetReport.SetTableView(Resource);
                    TimesheetReport.RunModal();
                    Clear(TimesheetReport);
                end;
            }
            action("Report Timesheet Entries")
            {
                ApplicationArea = Suite;
                Caption = 'Time Sheet Report';
                Image = "Report";
                ToolTip = 'Open the Time Sheet report - print on Grey';
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    Job: Record Job;
                    TimesheetReport: Report "Timesheet Entries";
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
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    Job: Record Job;
                    TimesheetReport: Report "Job Billing Excel";
                begin
                    Job.SetFilter("No.", Rec."No.");
                    TimesheetReport.SetTableView(Job);
                    TimesheetReport.RunModal();
                    Clear(TimesheetReport);
                end;
            }
            action("Active Jobs")
            {
                ApplicationArea = Jobs;
                Caption = 'Active Job List';
                Image = "Report";
                RunObject = Report "Active Jobs";
                ToolTip = 'View a list of all active J-jobs (use the filter ''J*|P*'')';
                Promoted = true;
                PromotedCategory = Report;
            }
            action("Job Card")
            {
                ApplicationArea = Suite;
                Caption = 'Job Card';
                Image = "Report";
                ToolTip = 'Produce a job card (Send to Word Document, save in the job''s folder, and print on Orange)';
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    Job: Record Job;
                    JobCard: Report "Service Instruction";
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
                ToolTip = 'Produce a job invoice template (Send to Word Document, and save to invoices folder)';
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    Job: Record Job;
                    JobInvoiceTemplate: Report "Job Invoice";
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
                ToolTip = 'Produce the workshop request jobcard (Send to Word Document, edit, then print on Green)';
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    Job: Record Job;
                    WorkshopRequest: Report "Workshop Request";
                begin
                    Job.SetFilter("No.", Rec."No.");
                    WorkshopRequest.SetTableView(Job);
                    WorkshopRequest.RunModal();
                    Clear(WorkshopRequest);
                end;
            }
        }
        addafter(CopyJob)
        {
            action(JobPlanningLines)
            {
                ApplicationArea = Jobs;
                Caption = 'Job &Planning Lines';
                Image = JobLines;
                ToolTip = 'View all planning lines for the job. You use this window to plan what items, resources, and general ledger expenses that you expect to use on a job (Budget) or you can specify what you actually agreed with your customer that he should pay for the job (Billable).';
                PromotedCategory = Process;
                Promoted = true;
                PromotedOnly = true;
                Scope = Repeater;

                trigger OnAction()
                var
                    JobPlanningLine: Record "Job Planning Line";
                    JobPlanningLines: Page "Job Planning Lines";
                    IsHandled: Boolean;
                begin
                    IsHandled := false;
                    OnBeforeJobPlanningLinesAction(Rec, IsHandled);
                    if IsHandled then
                        exit;

                    Rec.TestField("No.");
                    JobPlanningLine.FilterGroup(2);
                    JobPlanningLine.SetRange("Job No.", Rec."No.");
                    JobPlanningLine.FilterGroup(0);
                    JobPlanningLines.SetJobTaskNoVisible(true);
                    JobPlanningLines.SetTableView(JobPlanningLine);
                    JobPlanningLines.Editable := true;
                    JobPlanningLines.Run();
                end;
            }
        }
    }
    views
    {
        addfirst
        {
            view(CurrentJobs)
            {
                Caption = 'Current Jobs';
                Filters = where("Status" = filter('Planning|Quote|Open'));
            }
            view(AllJobs)
            {
                Caption = 'All Jobs';
                Filters = where("Status" = filter('Planning|Completed|Quote|Open'));
            }
            view(JJobs)
            {
                Caption = 'Current J Jobs';
                Filters = where("No." = filter('@j*'), "Status" = filter('Planning|Quote|Open'));
            }
            view(PJobs)
            {
                Caption = 'Current P Jobs';
                Filters = where("No." = filter('@p*'), "Status" = filter('Planning|Quote|Open'));
            }
            view(CompletedJobs)
            {
                Caption = 'Completed Jobs';
                Filters = where("Status" = filter('Completed'));
            }
            view("WIP to Post")
            {
                Caption = 'WIP entries';
                Filters = where("Status" = filter('Planning|Completed|Quote|Open'), "WIP Entries Exist" = const(true));
            }
        }
    }

    var
        InvoiceStyle: Text;
        ProfitStyle: Text;

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        Rec.Ascending(true);
        Rec.SetFilter("Status", 'Planning|Quote|Open|Paused');
    end;

    trigger OnAfterGetRecord()
    begin
        InvoiceStyle := SetInvoiceStyle();
        ProfitStyle := SetProfitStyle();
    end;

    procedure SetInvoiceStyle(): Text
    begin
        If Rec.ToInvoice > 3000 then
            exit('Attention');
        exit('');
    end;

    procedure SetProfitStyle(): Text
    begin
        if -(Rec.TotalValue + Rec.InvoicedValue) < 0 then
            exit('Attention');
        exit('');
    end;

    // trigger OnAfterGetRecord()
    // var
    //     UpdateJobPlanningLines: Codeunit UpdateJobPlanningLines;
    //     PlanningLine: Record "Job Planning Line";
    // begin
    //     UpdateJobPlanningLines.UpdateLines(PlanningLine);
    // end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeJobPlanningLinesAction(var Job: Record Job; var IsHandled: Boolean)
    begin
    end;
}