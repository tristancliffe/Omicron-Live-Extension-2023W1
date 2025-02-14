pageextension 50112 JobListExtension extends "Job List"
{
    layout
    {
        modify(Control1) { FreezeColumn = Description; }
        modify("No.") { StyleExpr = JobTypeStyle; }
        moveafter("Search Description"; "Status")
        modify("Search Description") { Visible = false; }
        modify("Status") { Visible = true; }
        addafter(Status)
        {
            field("Car Make/Model"; Rec."Car Make/Model") { ApplicationArea = All; ToolTip = 'Car make/model'; }
            field("Vehicle Reg"; Rec."Vehicle Reg") { ApplicationArea = All; }
            field("Project Notes"; Rec."Job Notes") { ApplicationArea = All; ToolTip = 'Project notes'; }
            field("Customer Balance"; Rec."Customer Balance") { Caption = 'Customer Balance'; ApplicationArea = All; Editable = false; Importance = Standard; AutoFormatType = 1; BlankZero = true; StyleExpr = BalanceStyle; }
            field("Date of Arrival"; Rec."Date of Arrival") { ApplicationArea = All; }
            field(TotalHours; Rec.TotalHours) { ApplicationArea = All; BlankZero = true; Width = 8; }
            field(InvoicedHours; Rec.InvoicedHours) { ApplicationArea = All; BlankZero = true; Width = 8; }
            field(ToInvoice; Rec.ToInvoice) { ApplicationArea = All; StyleExpr = InvoiceStyle; BlankZero = true; }
            field(TotalValue; Rec.TotalValue) { ApplicationArea = All; Visible = false; Caption = 'Total Cost, £'; }
            field(InvoicedValue; Rec.InvoicedValue) { ApplicationArea = All; Visible = false; Caption = 'Total Invoiced, £'; }
            field(ProfitToDate; -(Rec.TotalValue + Rec.InvoicedValue)) { ApplicationArea = All; StyleExpr = ProfitStyle; BlankZero = true; Visible = false; Caption = 'Profit to date, £'; ToolTip = 'The profit made so far'; }
            field(PercentCompleted; Rec.PercentCompleted) { ApplicationArea = All; BlankZero = true; Caption = '% Complete'; }
        }
        moveafter("Date of Arrival"; "Person Responsible")
        modify("Person Responsible") { Visible = false; ToolTip = 'Whom is ''doing'' the project, or whom is responsible for it.'; }
        moveafter(Control1905650007; Control1907234507, Control1902018507)
        modify(Control1907234507) { Visible = true; }
        modify(Control1902018507) { Visible = true; }
    }
    actions
    {
        addafter("Create Job &Sales Invoice")
        {
            action(CreateSalesInvoice)
            {
                ApplicationArea = Jobs;
                Caption = 'Create Project &Sales Invoice';
                Image = JobSalesInvoice;
                ToolTip = 'Use a batch job to help you create project sales invoices for the involved project planning lines.';
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
                Caption = 'Project Journal';
                Image = JobJournal;
                ApplicationArea = All;
                RunObject = Page "Job Journal";
                ToolTip = 'Open the Project Journal for posting to projects';
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
                Caption = 'Active Project List';
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
                ToolTip = 'Produce a job card (Send to Word Document, save in the project''s folder, and print on Orange)';
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
                Caption = 'Project &Planning Lines';
                Image = JobLines;
                ToolTip = 'View all planning lines for the project. You use this window to plan what items, resources, and general ledger expenses that you expect to use on a project (Budget) or you can specify what you actually agreed with your customer that he should pay for the project (Billable).';
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
            view(CurrentJobs) { Caption = 'Current Projects'; Filters = where("Status" = filter('Planning|Quote|Open|Paused')); }
            view(AllJobs) { Caption = 'All Projects'; Filters = where("Status" = filter('Planning|Completed|Quote|Open|Paused')); }
            view(JJobs) { Caption = 'Current J Jobs'; Filters = where("No." = filter('@j*'), "Status" = filter('Planning|Quote|Open|Paused')); }
            view(PJobs) { Caption = 'Current P Jobs'; Filters = where("No." = filter('@p*'), "Status" = filter('Planning|Quote|Open|Paused')); }
            view(CompletedJobs) { Caption = 'Completed Projects'; Filters = where("Status" = filter('Completed')); }
            view("WIP to Post") { Caption = 'WIP entries'; Filters = where("Status" = filter('Planning|Completed|Quote|Open|Paused'), "WIP Entries Exist" = const(true)); }
            view(RecentJobs) { Caption = 'Recent Projects'; Filters = where("Starting Date" = filter('Today-364D..')); }
        }
    }

    var
        InvoiceStyle: Text;
        ProfitStyle: Text;
        BalanceStyle: Text;
        JobTypeStyle: Text;

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        Rec.Ascending(true);
        Rec.SetFilter("Status", 'Planning|Quote|Open|Paused');
    end;

    trigger OnAfterGetRecord()
    begin
        JobTypeStyle := SetJobTypeStyle();
        InvoiceStyle := SetInvoiceStyle();
        ProfitStyle := SetProfitStyle();
        BalanceStyle := SetBalanceStyle();
    end;

    procedure SetInvoiceStyle(): Text
    begin
        if Rec.ToInvoice > 5000 then exit('Unfavorable');
        If Rec.ToInvoice > 3000 then exit('Attention');
        exit('');
    end;

    procedure SetProfitStyle(): Text
    begin
        if -(Rec.TotalValue + Rec.InvoicedValue) < 0 then exit('Attention');
        exit('');
    end;

    procedure SetBalanceStyle(): Text
    begin
        if Rec."Customer Balance" > 0 then exit('Attention');
        exit('');
    end;

    procedure SetJobTypeStyle(): Text
    begin
        if StrPos(rec."No.", 'J') = 1 then exit('StrongAccent');
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