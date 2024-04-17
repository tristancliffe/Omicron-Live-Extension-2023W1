page 50107 "Completed Job List"
{
    AdditionalSearchTerms = 'Completed Projects, Completed Projects List, Completed Jobs';
    ApplicationArea = Jobs;
    Caption = 'Completed Projects';
    CardPageID = "Job Card";
    Editable = false;
    PageType = List;
    SourceTable = Job;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                FreezeColumn = Description;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a short description of the project.';
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the customer who pays for the project.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a status for the current project. You can change the status for the project as it progresses. Final calculations can be made on completed projects.';
                }
                field("Car Make/Model"; Rec."Car Make/Model")
                { ApplicationArea = All; ToolTip = 'Car make/model'; }
                field("Vehicle Reg"; Rec."Vehicle Reg")
                { ApplicationArea = All; ToolTip = 'Registration No.'; }
                field("Job Notes"; Rec."Job Notes")
                { ApplicationArea = All; ToolTip = 'Project notes'; }
            }
        }
        area(factboxes)
        {
            part(Control1905650007; "Job WIP/Recognition FactBox")
            {
                ApplicationArea = Jobs;
                SubPageLink = "No." = field("No.");
            }
            part(Control1907234507; "Sales Hist. Bill-to FactBox")
            {
                ApplicationArea = Jobs;
                SubPageLink = "No." = field("Bill-to Customer No.");
            }
            part(Control1902018507; "Customer Statistics FactBox")
            {
                ApplicationArea = Jobs;
                SubPageLink = "No." = field("Bill-to Customer No.");
            }

            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(Database::Job),
                              "No." = field("No.");
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Job")
            {
                Caption = '&Project';
                Image = Job;
                action("Job Task &Lines")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Project Task &Lines';
                    Image = TaskList;
                    RunObject = Page "Job Task Lines";
                    RunPageLink = "Job No." = field("No.");
                    ToolTip = 'Plan how you want to set up your planning information. In this window you can specify the tasks involved in a project. To start planning a project or to post usage for a project, you must set up at least one project task.';
                }
                group("&Dimensions")
                {
                    Caption = '&Dimensions';
                    Image = Dimensions;
                    action("Dimensions-&Single")
                    {
                        ApplicationArea = Dimensions;
                        Caption = 'Dimensions-&Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = const(167),
                                      "No." = field("No.");
                        ShortCutKey = 'Alt+D';
                        ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
                    }
                    action("Dimensions-&Multiple")
                    {
                        AccessByPermission = TableData Dimension = R;
                        ApplicationArea = Dimensions;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;
                        ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';

                        trigger OnAction()
                        var
                            Job: Record Job;
                            DefaultDimensionsMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(Job);
                            DefaultDimensionsMultiple.SetMultiRecord(Job, Rec.FieldNo("No."));
                            DefaultDimensionsMultiple.RunModal();
                            Clear(DefaultDimensionsMultiple);
                        end;
                    }
                }
                action("&Statistics")
                {
                    ApplicationArea = Jobs;
                    Caption = '&Statistics';
                    Image = Statistics;
                    RunObject = Page "Job Statistics";
                    RunPageLink = "No." = field("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'View this project''s statistics.';
                }
                action(SalesInvoicesCreditMemos)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Sales &Invoices/Credit Memos';
                    Image = GetSourceDoc;
                    ToolTip = 'View sales invoices or sales credit memos that are related to the selected project.';

                    trigger OnAction()
                    var
                        JobInvoices: Page "Job Invoices";
                    begin
                        JobInvoices.SetPrJob(Rec);
                        JobInvoices.RunModal();
                        Clear(JobInvoices);
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = const(Job),
                                  "No." = field("No.");
                    ToolTip = 'View or add comments for the record.';
                }
            }
            group("W&IP")
            {
                Caption = 'W&IP';
                Image = WIP;
                action("&WIP Entries")
                {
                    ApplicationArea = Jobs;
                    Caption = '&WIP Entries';
                    Image = WIPEntries;
                    RunObject = Page "Job WIP Entries";
                    RunPageLink = "Job No." = field("No.");
                    RunPageView = sorting("Job No.", "Job Posting Group", "WIP Posting Date")
                                  order(Descending);
                    ToolTip = 'View entries for the project that are posted as work in process.';
                }
                action("WIP &G/L Entries")
                {
                    ApplicationArea = Jobs;
                    Caption = 'WIP &G/L Entries';
                    Image = WIPLedger;
                    RunObject = Page "Job WIP G/L Entries";
                    RunPageLink = "Job No." = field("No.");
                    RunPageView = sorting("Job No.")
                                  order(Descending);
                    ToolTip = 'View the project''s WIP G/L entries.';
                }
            }
#if not CLEAN21
            group("&Prices")
            {
                Caption = '&Prices';
                Image = Price;
                Visible = not ExtendedPriceEnabled;
                ObsoleteState = Pending;
                ObsoleteReason = 'Replaced by the new implementation (V16) of price calculation.';
                ObsoleteTag = '17.0';
                action("&Resource")
                {
                    ApplicationArea = Jobs;
                    Caption = '&Resource';
                    Image = Resource;
                    Visible = not ExtendedPriceEnabled;
                    RunObject = Page "Job Resource Prices";
                    RunPageLink = "Job No." = field("No.");
                    ToolTip = 'View this project''s resource prices.';
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Replaced by the new implementation (V16) of price calculation.';
                    ObsoleteTag = '17.0';
                }
                action("&Item")
                {
                    ApplicationArea = Jobs;
                    Caption = '&Item';
                    Image = Item;
                    Visible = not ExtendedPriceEnabled;
                    RunObject = Page "Job Item Prices";
                    RunPageLink = "Job No." = field("No.");
                    ToolTip = 'View this project''s item prices.';
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Replaced by the new implementation (V16) of price calculation.';
                    ObsoleteTag = '17.0';
                }
                action("&G/L Account")
                {
                    ApplicationArea = Jobs;
                    Caption = '&G/L Account';
                    Image = JobPrice;
                    Visible = not ExtendedPriceEnabled;
                    RunObject = Page "Job G/L Account Prices";
                    RunPageLink = "Job No." = field("No.");
                    ToolTip = 'View this project''s G/L account prices.';
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Replaced by the new implementation (V16) of price calculation.';
                    ObsoleteTag = '17.0';
                }
            }
#endif
            group(Prices)
            {
                Caption = '&Prices';
                Image = Price;
                Visible = ExtendedPriceEnabled;
                action(SalesPriceLists)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Price Lists';
                    Image = Price;
                    Visible = ExtendedPriceEnabled;
                    ToolTip = 'View or set up sales price lists for products that you sell to the customer. A product price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';

                    trigger OnAction()
                    var
                        PriceUXManagement: Codeunit "Price UX Management";
                    begin
                        PriceUXManagement.ShowPriceLists(Rec, Enum::"Price Type"::Sale, Enum::"Price Amount Type"::Any);
                    end;
                }
                action(SalesPriceLines)
                {
                    AccessByPermission = TableData "Sales Price Access" = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Prices';
                    Image = Price;
                    Scope = Repeater;
                    Visible = ExtendedPriceEnabled;
                    ToolTip = 'View or set up sales price lines for products that you sell to the customer. A product price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';

                    trigger OnAction()
                    var
                        PriceSource: Record "Price Source";
                        PriceUXManagement: Codeunit "Price UX Management";
                    begin
                        Rec.ToPriceSource(PriceSource, Enum::"Price Type"::Sale);
                        PriceUXManagement.ShowPriceListLines(PriceSource, Enum::"Price Amount Type"::Price);
                    end;
                }
                action(SalesDiscountLines)
                {
                    AccessByPermission = TableData "Sales Discount Access" = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Discounts';
                    Image = LineDiscount;
                    Scope = Repeater;
                    Visible = ExtendedPriceEnabled;
                    ToolTip = 'View or set up different discounts for products that you sell to the customer. A product line discount is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';

                    trigger OnAction()
                    var
                        PriceSource: Record "Price Source";
                        PriceUXManagement: Codeunit "Price UX Management";
                    begin
                        Rec.ToPriceSource(PriceSource, Enum::"Price Type"::Sale);
                        PriceUXManagement.ShowPriceListLines(PriceSource, Enum::"Price Amount Type"::Discount);
                    end;
                }
#if not CLEAN21
                action(SalesPriceListsDiscounts)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Price Lists (Discounts)';
                    Image = LineDiscount;
                    Visible = false;
                    ToolTip = 'View or set up different discounts for products that you sell to the customer. A product line discount is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Action SalesPriceLists shows all sales price lists with prices and discounts';
                    ObsoleteTag = '18.0';

                    trigger OnAction()
                    var
                        PriceUXManagement: Codeunit "Price UX Management";
                        AmountType: Enum "Price Amount Type";
                        PriceType: Enum "Price Type";
                    begin
                        PriceUXManagement.ShowPriceLists(Rec, PriceType::Sale, AmountType::Discount);
                    end;
                }
#endif
                action(PurchasePriceLists)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Purchase Price Lists';
                    Image = ResourceCosts;
                    Visible = ExtendedPriceEnabled;
                    ToolTip = 'View or set up purchase price lists for products that you buy from the vendor. An product price is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.';

                    trigger OnAction()
                    var
                        PriceUXManagement: Codeunit "Price UX Management";
                    begin
                        PriceUXManagement.ShowPriceLists(Rec, Enum::"Price Type"::Purchase, Enum::"Price Amount Type"::Any);
                    end;
                }
                action(PurchPriceLines)
                {
                    AccessByPermission = TableData "Purchase Price Access" = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Purchase Prices';
                    Image = Price;
                    Scope = Repeater;
                    Visible = ExtendedPriceEnabled;
                    ToolTip = 'View or set up purchase price lines for products that you buy from the vendor. A product price is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.';

                    trigger OnAction()
                    var
                        PriceSource: Record "Price Source";
                        PriceUXManagement: Codeunit "Price UX Management";
                    begin
                        Rec.ToPriceSource(PriceSource, Enum::"Price Type"::Purchase);
                        PriceUXManagement.ShowPriceListLines(PriceSource, Enum::"Price Amount Type"::Price);
                    end;
                }
                action(PurchDiscountLines)
                {
                    AccessByPermission = TableData "Purchase Discount Access" = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Purchase Discounts';
                    Image = LineDiscount;
                    Scope = Repeater;
                    Visible = ExtendedPriceEnabled;
                    ToolTip = 'View or set up different discounts for products that you buy from the vendor. A product line discount is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.';

                    trigger OnAction()
                    var
                        PriceSource: Record "Price Source";
                        PriceUXManagement: Codeunit "Price UX Management";
                    begin
                        Rec.ToPriceSource(PriceSource, Enum::"Price Type"::Purchase);
                        PriceUXManagement.ShowPriceListLines(PriceSource, Enum::"Price Amount Type"::Discount);
                    end;
                }
#if not CLEAN21
                action(PurchasePriceListsDiscounts)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Purchase Price Lists (Discounts)';
                    Image = LineDiscount;
                    Visible = false;
                    ToolTip = 'View or set up different discounts for products that you buy from the vendor. An product discount is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.';
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Action PurchasePriceLists shows all purchase price lists with prices and discounts';
                    ObsoleteTag = '18.0';

                    trigger OnAction()
                    var
                        PriceUXManagement: Codeunit "Price UX Management";
                        AmountType: Enum "Price Amount Type";
                        PriceType: Enum "Price Type";
                    begin
                        PriceUXManagement.ShowPriceLists(Rec, PriceType::Purchase, AmountType::Discount);
                    end;
                }
#endif
            }
            group("Plan&ning")
            {
                Caption = 'Plan&ning';
                Image = Planning;
                action("Resource &Allocated per Job")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource &Allocated per Project';
                    Image = ViewJob;
                    RunObject = Page "Resource Allocated per Job";
                    ToolTip = 'View this project''s resource allocation.';
                }
                action("Res. Group All&ocated per Job")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Res. Group All&ocated per Project';
                    Image = ViewJob;
                    RunObject = Page "Res. Gr. Allocated per Job";
                    ToolTip = 'View the project''s resource group allocation.';
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Ledger E&ntries")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    RunObject = Page "Job Ledger Entries";
                    RunPageLink = "Job No." = field("No.");
                    RunPageView = sorting("Job No.", "Job Task No.", "Entry Type", "Posting Date")
                                  order(Descending);
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
            }
        }
        area(processing)
        {
            group("<Action9>")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(CopyJob)
                {
                    ApplicationArea = Jobs;
                    Caption = '&Copy Project';
                    Ellipsis = true;
                    Image = CopyFromTask;
                    ToolTip = 'Copy a project and its project tasks, planning lines, and prices.';

                    trigger OnAction()
                    var
                        CopyJob: Page "Copy Job";
                    begin
                        CopyJob.SetFromJob(Rec);
                        CopyJob.RunModal();
                        Clear(CopyJob);
                    end;
                }
                action("Create Job &Sales Invoice")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Create Project &Sales Invoice';
                    Image = JobSalesInvoice;
                    RunObject = Report "Job Create Sales Invoice";
                    ToolTip = 'Use a batch project to help you create project sales invoices for the involved project planning lines.';
                }
                group(Action7)
                {
                    Caption = 'W&IP';
                    Image = WIP;
                    action("<Action151>")
                    {
                        ApplicationArea = Jobs;
                        Caption = '&Calculate WIP';
                        Ellipsis = true;
                        Image = CalculateWIP;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        ToolTip = 'Run the Project Calculate WIP batch project.';

                        trigger OnAction()
                        var
                            Job: Record Job;
                            JobCalculateWIP: Report "Job Calculate WIP";
                        begin
                            Rec.TestField("No.");
                            Job.Copy(Rec);
                            Job.SetRange("No.", Rec."No.");
                            JobCalculateWIP.SetTableView(Job);
                            JobCalculateWIP.Run();
                        end;
                    }
                    action("<Action152>")
                    {
                        ApplicationArea = Jobs;
                        Caption = '&Post WIP to G/L';
                        Ellipsis = true;
                        Image = PostOrder;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        ToolTip = 'Run the Project Post WIP to G/L batch projects.';

                        trigger OnAction()
                        var
                            Job: Record Job;
                        begin
                            Rec.TestField("No.");
                            Job.Copy(Rec);
                            Job.SetRange("No.", Rec."No.");
                            REPORT.RunModal(REPORT::"Job Post WIP to G/L", true, false, Job);
                        end;
                    }
                }
            }
        }
        area(reporting)
        {
            action("Job Actual to Budget")
            {
                ApplicationArea = Jobs;
                Caption = 'Project Actual to Budget';
                Image = "Report";
                RunObject = Report "Job Actual To Budget";
                ToolTip = 'Compare budgeted and usage amounts for selected projects. All lines of the selected project show quantity, total cost, and line amount.';
            }
            action("Job Analysis")
            {
                ApplicationArea = Jobs;
                Caption = 'Project Analysis';
                Image = "Report";
                RunObject = Report "Job Analysis";
                ToolTip = 'Analyze the project, such as the budgeted prices, usage prices, and contract prices, and then compares the three sets of prices.';
            }
            action("Job - Planning Lines")
            {
                ApplicationArea = Jobs;
                Caption = 'Project - Planning Lines';
                Image = "Report";
                RunObject = Report "Job - Planning Lines";
                ToolTip = 'View all planning lines for the project. You use this window to plan what items, resources, and general ledger expenses that you expect to use on a project (budget) or you can specify what you actually agreed with your customer that he should pay for the project (billable).';
            }
            action("Job - Suggested Billing")
            {
                ApplicationArea = Jobs;
                Caption = 'Project - Suggested Billing';
                Image = "Report";
                RunObject = Report "Job Suggested Billing";
                ToolTip = 'View a list of all projects, grouped by customer, how much the customer has already been invoiced, and how much remains to be invoiced, that is, the suggested billing.';
            }
            action("Jobs per Customer")
            {
                ApplicationArea = Jobs;
                Caption = 'Projects per Customer';
                Image = "Report";
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Jobs per Customer";
                ToolTip = 'Run the Projects per Customer report.';
            }
            action("Items per Job")
            {
                ApplicationArea = Jobs;
                Caption = 'Items per Project';
                Image = "Report";
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Items per Job";
                ToolTip = 'View which items are used for a specific project.';
            }
            action("Jobs per Item")
            {
                ApplicationArea = Jobs;
                Caption = 'Projects per Item';
                Image = "Report";
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Jobs per Item";
                ToolTip = 'Run the Projects per item report.';
            }
            action("Report Job Quote")
            {
                ApplicationArea = Jobs;
                Caption = 'Preview Project Quote';
                Image = "Report";
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                ToolTip = 'Open the Project Quote report.';

                trigger OnAction()
                var
                    Job: Record Job;
                begin
                    Job := Rec;
                    CurrPage.SetSelectionFilter(Job);
                    Job.PrintRecords(true);
                end;
            }
            action("Send Job Quote")
            {
                ApplicationArea = Jobs;
                Caption = 'Send Project Quote';
                Image = SendTo;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                ToolTip = 'Send the project quote to the customer. You can change the way that the document is sent in the window that appears.';

                trigger OnAction()
                begin
                    CODEUNIT.Run(CODEUNIT::"Jobs-Send", Rec);
                end;
            }
            group("Financial Management")
            {
                Caption = 'Financial Management';
                Image = "Report";
                action("Job WIP to G/L")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Project WIP to G/L';
                    Image = "Report";
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Job WIP To G/L";
                    ToolTip = 'View the value of work in process on the projects that you select compared to the amount that has been posted in the general ledger.';
                }
            }
            group(Action23)
            {
                Caption = 'History';
                Image = "Report";
                action("Jobs - Transaction Detail")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Projects - Transaction Detail';
                    Image = "Report";
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Job - Transaction Detail";
                    ToolTip = 'View all postings with entries for a selected project for a selected period, which have been charged to a certain project. At the end of each project list, the amounts are totaled separately for the Sales and Usage entry types.';
                }
                action("Job Register")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Project Register';
                    Image = "Report";
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Report "Job Register";
                    ToolTip = 'View one or more selected project registers. By using a filter, you can select only those register entries that you want to see. If you do not set a filter, the report can be impractical because it can contain a large amount of information. On the project journal template, you can indicate that you want the report to print when you post.';
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(CopyJob_Promoted; CopyJob)
                {
                }
                actionref("Create Job &Sales Invoice_Promoted"; "Create Job &Sales Invoice")
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'Job', Comment = 'Generated from the PromotedActionCategories property index 4.';

                group(Category_Dimensions)
                {
                    Caption = 'Dimensions';
                    ShowAs = SplitButton;

                    actionref("Dimensions-&Multiple_Promoted"; "Dimensions-&Multiple")
                    {
                    }
                    actionref("Dimensions-&Single_Promoted"; "Dimensions-&Single")
                    {
                    }
                }
                actionref("&Statistics_Promoted"; "&Statistics")
                {
                }
                actionref("Co&mments_Promoted"; "Co&mments")
                {
                }
                actionref(SalesInvoicesCreditMemos_Promoted; SalesInvoicesCreditMemos)
                {
                }
                actionref("Job Task &Lines_Promoted"; "Job Task &Lines")
                {
                }
                actionref("Ledger E&ntries_Promoted"; "Ledger E&ntries")
                {
                }
            }
            group(Category_WIP)
            {
                Caption = 'WIP';

                actionref("<Action151>_Promoted"; "<Action151>")
                {
                }
                actionref("<Action152>_Promoted"; "<Action152>")
                {
                }
                actionref("&WIP Entries_Promoted"; "&WIP Entries")
                {
                }
                actionref("WIP &G/L Entries_Promoted"; "WIP &G/L Entries")
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("Job - Planning Lines_Promoted"; "Job - Planning Lines")
                {
                }
                actionref("Job Actual to Budget_Promoted"; "Job Actual to Budget")
                {
                }
                actionref("Job Analysis_Promoted"; "Job Analysis")
                {
                }
                actionref("Job - Suggested Billing_Promoted"; "Job - Suggested Billing")
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        PriceCalculationMgt: Codeunit "Price Calculation Mgt.";
    begin
        ExtendedPriceEnabled := PriceCalculationMgt.IsExtendedPriceCalculationEnabled();
    end;

    var
        ExtendedPriceEnabled: Boolean;
}

