pageextension 50112 JobListExtension extends "Job List"
{
    layout
    {
        modify(Control1)
        { FreezeColumn = Description; }
        moveafter("Search Description"; "Status")
        modify("Status")
        { Visible = true; }
        addafter(Status)
        {
            field("Car Make/Model"; Rec."Car Make/Model")
            {
                ApplicationArea = All;
                ToolTip = 'Car make/model';
            }
            field("Vehicle Reg"; Rec."Vehicle Reg")
            {
                ApplicationArea = All;
                ToolTip = 'Registration No.';
            }
            field("Job Notes"; Rec."Job Notes")
            {
                ApplicationArea = All;
                ToolTip = 'Job notes';
            }
            field("Date of Arrival"; Rec."Date of Arrival")
            {
                ApplicationArea = All;
                ToolTip = 'Date of arrival at Omicron';
            }
        }
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
                end;
            }
            action(ManagerTimeSheet)
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
                end;
            }
        }
    }
    views
    {
        addfirst
        {
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
                Filters = where("Status" = const(Completed));
            }
            view("WIP to Post")
            {
                Caption = 'WIP entries';
                Filters = where("Status" = filter('Planning|Completed|Quote|Open'), "WIP Entries Exist" = const(true));
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        Rec.Ascending(true);
        Rec.SetFilter("Status", 'Planning|Quote|Open');
        // Rec.SetView(StrSubstNo('sorting ("No.") order(ascending) where ("Status" = filter (Planning|Open|Quote))'));
    end;
}