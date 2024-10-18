pageextension 50120 OmicronBusManagerRCExt extends "Business Manager Role Center"
{

    layout
    {
        modify("Intercompany Activities")
        { Visible = false; }
        modify("My Job Queue")
        { Visible = true; }
        //moveafter(Control16; Control46)
        //moveafter(Control16; ShpfyActivities)
        // addafter("User Tasks Activities")
        // {
        //     part(OtherCues; "Other Cues")
        //     {
        //         ApplicationArea = All;
        //         Visible = true;
        //     }
        // }
        addafter(Control46)
        {
            part(ProjectCues; "Project Manager Activities")
            { ApplicationArea = All; Visible = True; }
            part(JobCues; "Job Cues")
            { ApplicationArea = All; Visible = true; }
        }
        addafter(PowerBIEmbeddedReportPart3)
        {
            part(PowerBIEmbeddedReportPart4; "Power BI Embedded Report Part")
            {
                AccessByPermission = TableData "Power BI Context Settings" = I;
                ApplicationArea = Basic, Suite;
                SubPageView = where(Context = const('Power BI Part VI'));
                Visible = false;
            }
        }
        modify(SubBillingActivities)
        { Visible = false; }
        movelast(rolecenter; "Job Queue Tasks Activities", ApprovalsActivities)
    }
    actions
    {
        addbefore(Navigate)
        {
            action(ItemListView_Omicron)
            {
                ApplicationArea = All;
                RunObject = page "Item List";
                Caption = 'Item List';
                Image = Item;
                ToolTip = 'Opens the item list in an editable mode for quick "SuperSearch';
                Ellipsis = true;
            }
            action(CustomerList_Omicron)
            {
                ApplicationArea = All;
                RunObject = page "Customer List";
                Caption = 'Customers';
                Image = Customer;
                Tooltip = 'Go to the Customer List';
                Ellipsis = true;
            }
            action(VendorList_Omicron)
            {
                ApplicationArea = All;
                RunObject = page "Vendor List";
                Caption = 'Suppliers';
                Image = Customer;
                Tooltip = 'Go to the Vendor List';
                Ellipsis = true;
            }
            action(JobList_Omicron)
            {
                ApplicationArea = All;
                RunObject = page "Job List";
                //RunPageView = where(Status = filter(Open | Quote | Planning));
                Caption = 'Projects';
                Image = ViewJob;
                Tooltip = 'Show the list of current projects';
                Ellipsis = true;
            }
        }
        // modify(Items)
        // { Visible = false; }
        modify("Bank Accounts")
        { Visible = false; }
        modify("Chart of Accounts")
        { Visible = false; }
        addafter(Vendors)
        {
            action(JobsList)
            {
                ApplicationArea = All;
                Caption = 'Projects';
                Image = Job;
                RunObject = page "Job List";
                ToolTip = 'Show a list of active projects and their details.';
            }
        }
        addafter(Action131)
        {
            action("Req. Worksheet")
            {
                ApplicationArea = All;
                CaptionML = ENG = 'Requisition Worksheets', ENU = 'Requisition Worksheets';
                RunObject = page "Req. Worksheet";
                Image = Purchasing;
                ToolTip = 'The Requisition Worksheet page lists items that you want to order. Requisition worksheet lines contain detailed information about the items that need to be reordered. You can edit and delete the lines to adjust your replenishment plan.';
            }
        }
        moveafter("<Page Purchase Invoices>"; "Blanket Purchase Orders", "Incoming Documents")
        addlast(Action41)
        {
            action("Aged Creditors")
            {
                ApplicationArea = All;
                CaptionML = ENG = 'Aged Creditors';
                RunObject = report "Aged Accounts Payable";
                Image = Payables;
                ToolTip = 'Shows the Aged Creditors report';
            }
        }
        modify(PostedGeneralJournals)
        { Visible = false; }
        modify("VAT Returns")
        { Visible = false; }
        modify("VAT Statements")
        { Visible = false; }

        addlast(Action39)
        {
            group(VAT)
            {
                Caption = 'VAT';
                Visible = true;
                action(VATReturns)
                {
                    ApplicationArea = VAT;
                    Caption = 'VAT Returns';
                    RunObject = Page "VAT Report List";
                    ToolTip = 'Prepare the VAT Return report so you can submit VAT amounts to a tax authority.';
                }
                action(VATStatements)
                {
                    ApplicationArea = VAT;
                    Caption = 'VAT Statements';
                    RunObject = Page "VAT Statement Names";
                    ToolTip = 'View a statement of posted VAT amounts, calculate your VAT settlement amount for a certain period, such as a quarter, and prepare to send the settlement to the tax authorities.';
                }
                action(VATReturnPeriods)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'VAT Return Periods';
                    Image = PeriodEntries;
                    RunObject = page "VAT Return Period List";
                    Tooltip = 'Register new VAT return periods and see list of open/submitted/closed periods';
                }
                action(VATEntries)
                {
                    ApplicationArea = All;
                    Caption = 'VAT Entries';
                    Image = VATEntries;
                    RunObject = Page "VAT Entries";
                    ToolTip = 'Opens the list of VAT entries';
                }
                action(DaybooksVAT)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'VAT Day Books';
                    Image = VATLedger;
                    RunObject = Report "Day Book VAT Entry";
                    ToolTip = 'View VAT transactions over a given period';
                }
                action(VATSetup)
                {
                    ApplicationArea = All;
                    Caption = 'VAT Report Setup';
                    Image = VATPostingSetup;
                    RunObject = Page "VAT Report Setup";
                    ToolTip = 'Opens the VAT Report Setup screen to set up VAT reporting';
                }
            }

        }
        moveafter("Sales Invoices"; "Blanket Sales Orders")
        addafter("Sales Invoices")
        {
            action(ContactsList)
            {
                ApplicationArea = All;
                Caption = 'Contacts';
                Image = CustomerContact;
                RunObject = page "Contact List";
            }
        }
        addlast(Action40)
        {
            action(AssemblyOrders)
            {
                ApplicationArea = All;
                CaptionML = ENG = 'Assembly Orders';
                RunObject = page "Assembly Orders";
                Image = AssemblyOrder;
                ToolTip = 'View the list of assembly orders, and create new ones manually (for posting to project journals etc.';
            }
            action("Aged Debtors")
            {
                ApplicationArea = All;
                CaptionML = ENG = 'Aged Debtors';
                RunObject = report "Aged Accounts Receivable";
                Image = Receivables;
                ToolTip = 'Shows the Aged Debtors report';
            }
        }
        addafter(Action41)
        {
            group(Journals)
            {
                Caption = 'Journals';
                Image = Journals;
                ToolTip = 'Post financial transactions.';
                action(Action_GeneralJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'General Journals';
                    Image = Journal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(General),
                                        Recurring = CONST(false));
                    ToolTip = 'Post financial transactions directly to general ledger accounts and other accounts, such as bank, customer, vendor, and employee accounts. Posting with a general journal always creates entries on general ledger accounts. This is true even when, for example, you post a journal line to a customer account, because an entry is posted to a general ledger receivables account through a posting group.';
                }
                action(ItemJournal)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item Journal';
                    Image = ItemWorksheet;
                    RunObject = Page "Item Journal";
                    ToolTip = 'Open the Item Journal for adjusting stock - for example adding secondhand items found for customers';
                }
                action("<Action3>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Recurring General Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(General),
                                        Recurring = CONST(true));
                    ToolTip = 'Define how to post transactions that recur with few or no changes to general ledger, bank, customer, vendor, or fixed asset accounts';
                }
                action(PurchaseJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Purchase Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Purchases),
                                        Recurring = CONST(false));
                    ToolTip = 'Post any purchase-related transaction directly to a vendor, bank, or general ledger account instead of using dedicated documents. You can post all types of financial purchase transactions, including payments, refunds, and finance charge amounts. Note that you cannot post item quantities with a purchase journal.';
                }
                action(SalesJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Sales),
                                        Recurring = CONST(false));
                    ToolTip = 'Post any sales-related transaction directly to a customer, bank, or general ledger account instead of using dedicated documents. You can post all types of financial sales transactions, including payments, refunds, and finance charge amounts. Note that you cannot post item quantities with a sales journal.';
                }
                action(PaymentJournals2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Payment Journals';
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Payments),
                                        Recurring = CONST(false));
                    ToolTip = 'Register payments to vendors. A payment journal is a type of general journal that is used to post outgoing payment transactions to G/L, bank, customer, vendor, employee, and fixed assets accounts. The Suggest Vendor Payments functions automatically fills the journal with payments that are due. When payments are posted, you can export the payments to a bank file for upload to your bank if your system is set up for electronic banking. You can also issue computer checks from the payment journal.';
                }
                action(CashJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cash Receipt Journals';
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST("Cash Receipts"),
                                        Recurring = CONST(false));
                    ToolTip = 'Register received payments by manually applying them to the related customer, vendor, or bank ledger entries. Then, post the payments to G/L accounts and thereby close the related ledger entries.';
                }
                action("ActionJobJournalsRoleCentre")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Project Journals';
                    Image = JobJournal;
                    RunObject = Page "Job Journal Batches";
                    ToolTip = 'Project Journal view';
                }
                action(AssetJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Fixed Asset Journals';
                    Image = FixedAssets;
                    RunObject = Page "FA Journal Batches";
                    ToolTip = 'Post entries related to Fixed Assets';
                }
                action(PaymentRecJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Payment Rec. Journals';
                    Image = ApplyEntries;
                    RunObject = Page "Pmt. Reconciliation Journals";
                    ToolTip = 'Reconcile unpaid documents automatically with their related bank transactions by importing a bank statement feed or file. In the payment reconciliation journal, incoming or outgoing payments on your bank are automatically, or semi-automatically, applied to their related open customer or vendor ledger entries. Any open bank account ledger entries related to the applied customer or vendor ledger entries will be closed when you choose the Post Payments and Reconcile Bank Account action. This means that the bank account is automatically reconciled for payments that you post with the journal.';
                }
                // action(ICGeneralJournals)
                // {
                //     ApplicationArea = Basic, Suite;
                //     Caption = 'IC General Journals';
                //     RunObject = Page "General Journal Batches";
                //     RunPageView = WHERE("Template Type" = CONST(Intercompany),
                //                         Recurring = CONST(false));
                //     ToolTip = 'Post intercompany transactions. IC general journal lines must contain either an IC partner account or a customer or vendor account that has been assigned an intercompany partner code.';
                // }
                // action(Action1102601002)
                // {
                //     ApplicationArea = BasicEU;
                //     Caption = 'Intrastat Journals';
                //     Image = "Report";
                //     RunObject = Page "Intrastat Jnl. Batches";
                //     ToolTip = 'Summarize the value of your purchases and sales with business partners in the EU for statistical purposes and prepare to send it to the relevant authority.';
                // }
                action(Action_PostedGeneralJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted General Journals';
                    RunObject = Page "Posted General Journal";
                    ToolTip = 'Open the list of posted general journal lines.';
                }
                action(PhysicalInvtJournal)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Physical Inventory Journal';
                    Image = InventoryCalculation;
                    RunObject = Page "Phys. Inventory Journal";
                    ToolTip = 'Open the Physical Inventory Journal for stock taking processes';
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                ToolTip = 'View the posting history for sales, shipments, and inventory.';
                action("Action_Posted Sales Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                    ToolTip = 'Open the list of posted sales invoices.';
                }
                action("PostedSalesShipments")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Shipments';
                    Image = Shipment;
                    RunObject = Page "Posted Sales Shipments";
                    ToolTip = 'Open the list of posted sales shipments.';
                }
                action("Action_Posted Sales Credit Memos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                    ToolTip = 'Open the list of posted sales credit memos.';
                }
                action("Posted Purchase Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                    ToolTip = 'Open the list of posted purchase invoices.';
                }
                action("PostedPurchaseReceipts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Purchase Receipts';
                    Image = Receipt;
                    RunObject = Page "Posted Purchase Receipts";
                    ToolTip = 'Open the list of posted purchase receipts.';
                }
                action("Posted Purchase Credit Memos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                    ToolTip = 'Open the list of posted purchase credit memos.';
                }
                action("Action_Issued Reminders")
                {
                    ApplicationArea = Suite;
                    Caption = 'Issued Reminders';
                    Image = OrderReminder;
                    RunObject = Page "Issued Reminder List";
                    ToolTip = 'Open the list of issued reminders.';
                }
                action("Issued Fin. Charge Memos")
                {
                    ApplicationArea = Suite;
                    Caption = 'Issued Fin. Charge Memos';
                    Image = PostedMemo;
                    RunObject = Page "Issued Fin. Charge Memo List";
                    ToolTip = 'Open the list of issued finance charge memos.';
                }
                action("G/L Registers")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'G/L Registers';
                    Image = GLRegisters;
                    RunObject = Page "G/L Registers";
                    ToolTip = 'View auditing details for all general ledger entries. Every time an entry is posted, a register is created in which you can see the first and last number of its entries in order to document when entries were posted.';
                }
                action(PostedGenJournals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted General Journals';
                    Image = PostedOrder;
                    RunObject = Page "Posted General Journal";
                    ToolTip = 'Open the list of posted general journal lines.';
                }
                action("Posted Bank Deposits")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Bank Deposits';
                    Image = PostedDeposit;
                    RunObject = codeunit "Open P. Bank Deposits L. Page";
                    ToolTip = 'View the posted deposit header, deposit header lines, deposit comments, and deposit dimensions.';
                }
                action("Cost Accounting Registers")
                {
                    ApplicationArea = CostAccounting;
                    Caption = 'Cost Accounting Registers';
                    RunObject = Page "Cost Registers";
                    ToolTip = 'View auditing details for all cost accounting entries. Every time an entry is posted, a register is created in which you can see the first and last number of its entries in order to document when entries were posted.';
                }
                action("Cost Accounting Budget Registers")
                {
                    ApplicationArea = CostAccounting;
                    Caption = 'Cost Accounting Budget Registers';
                    RunObject = Page "Cost Budget Registers";
                    ToolTip = 'View auditing details for all cost accounting budget entries. Every time an entry is posted, a register is created in which you can see the first and last number of its entries in order to document when entries were posted.';
                }
                action(SalesOrderArchives)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Order Archive';
                    RunObject = Page "Sales Order Archives";
                    ToolTip = 'List of archived sales orders, including versions when printed and the archive option was selected';
                }
            }
            group("Projects")
            {
                Caption = 'Projects';
                Image = Job;
                ToolTip = 'Tools to manage projects, timesheets, resources etc';
                //ShowAs = SplitButton;
                action("ActionJobs")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Projects';
                    Image = Job;
                    RunObject = Page "Job List";
                    RunPageView = where(Status = filter(Open | Quote | Planning));
                    ToolTip = 'See and edit the list of projects, and then go to card list';
                }
                action("ActionTimeSheets")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Time Sheets';
                    Image = Timesheet;
                    RunObject = Page "Time Sheet List";
                    ToolTip = 'View current time sheets';
                }
                action("ActionManagerTimeSheets")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Manager Time Sheets';
                    Image = Timesheet;
                    RunObject = Page "Manager Time Sheet List";
                    ToolTip = 'Manager Time Sheets view';
                }
                action("ActionJobJournals")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Project Journals';
                    Image = JobJournal;
                    RunObject = Page "Job Journal Batches";
                    ToolTip = 'Project Journal view';
                }
                action("ActionResources")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Resources';
                    Image = Resource;
                    RunObject = Page "Resource List";
                    ToolTip = 'View resources (staff, machines etc.)';
                }
                action("ActionResourceJournal")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Resource Journal';
                    Image = ResourceJournal;
                    RunObject = Page "Resource Journal";
                    ToolTip = 'Resource Journal view';
                }
                action("ActionResourceLedger")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Resource Ledger';
                    Image = ResourceLedger;
                    RunObject = Page "Resource Ledger Entries";
                    ToolTip = 'Resource Ledger Entries list';
                }
                action("Absences")
                {
                    AccessByPermission = TableData "Employee Absence" = IMD;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Employee Absences';
                    Image = Absence;
                    RunObject = Page "Absence Registration";
                    ToolTip = 'See list of resource absences (time sheet users)';
                }
                action("EmployeeList")
                {
                    AccessByPermission = TableData Employee = IMD;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Employees';
                    Image = Employee;
                    RunObject = Page "Employee List";
                    ToolTip = 'See list of employees';
                }
                action("Report Timesheet Entries")
                {
                    ApplicationArea = Suite;
                    Caption = 'Time Sheet Report';
                    Image = "Report";
                    ToolTip = 'Open the Time Sheet report.';
                    RunObject = Report "Timesheet Entries";
                }
                action("Report Job Invoicing Excel")
                {
                    ApplicationArea = Suite;
                    Caption = 'Excel Invoicing Report';
                    Image = "Report";
                    ToolTip = 'Open the Excel worksheet for invoicing';
                    RunObject = Report "Job Billing Excel";
                }
            }
            group(Stock)
            {
                Caption = 'Stock';
                Image = Travel;
                ToolTip = 'Stock Control';
                action("ItemsExt")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Items';
                    Image = Item;
                    RunObject = Page "Item List";
                    ToolTip = 'View list of items (incl. non-inventory and service items).';
                }
                action("ItemCharges")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item Charges';
                    Image = ItemCosts;
                    RunObject = Page "Item Charges";
                    ToolTip = 'View list of item charges.';
                }
                action("ItemJournals")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item Journals';
                    Image = ItemLedger;
                    RunObject = Page "Item Journal";
                    ToolTip = 'View item journals for modifying stock levels for second-hand parts (but NOT purchases).';
                }
                action("ItemCategories")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item Categories';
                    Image = ItemGroup;
                    RunObject = Page "Item Categories";
                    ToolTip = 'View item categories (Shortname in old system).';
                }
                action("PhysicalInvJournals")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Physical Inventory Journals';
                    Image = InventoryJournal;
                    RunObject = Page "Phys. Inventory Journal";
                    ToolTip = 'View physical inventory journals for stocktaking purposes';
                }
                action("AssemblyOrdersExt")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Assembly Orders';
                    Image = AssemblyOrder;
                    RunObject = Page "Assembly Orders";
                    ToolTip = 'View assembly orders - both generated by sales orders and manually when necessary for assembly-to-stock';
                }
                action("RequisitionWorksheet")
                {
                    ApplicationArea = All;
                    CaptionML = ENG = 'Requisition Worksheets', ENU = 'Requisition Worksheets';
                    RunObject = page "Req. Worksheet";
                    Image = ItemWorksheet;
                    ToolTip = 'The Requisition Worksheet page lists items that you want to order. Requisition worksheet lines contain detailed information about the items that need to be reordered. You can edit and delete the lines to adjust your replenishment plan.';
                }
                action(ItemVendorCatalogue)
                {
                    ApplicationArea = all;
                    Caption = 'Item Vendor Catalogue';
                    Image = CoupledItem;
                    Tooltip = 'Opens the complete Item Vendor Catalogue';
                    RunObject = Page "Item Vendor Catalog";
                }
                action(VendorItemCatalogue)
                {
                    ApplicationArea = all;
                    Caption = 'Vendor Item Catalogue';
                    Image = CoupledItem;
                    Tooltip = 'Opens the complete Vendor Item Catalogue';
                    RunObject = Page "Vendor Item Catalog";
                }
            }
        }
        addlast(sections)
        {
            group(Utilities)
            {
                Caption = 'Utilities';
                Image = Setup;
                ToolTip = 'Various tools for managing Business Central';

                action("User Time Registers")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'User Time Registers';
                    Image = User;
                    RunObject = Page "User Time Registers";
                    ToolTip = 'User activity log, minutes per user per day';
                }
                action(LoggedInUsers)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Logged-in Users';
                    Image = UserSetup;
                    RunObject = Page "Logged-In Users";
                    ToolTip = 'See currently logged-in users';
                }
                action(Users)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Users';
                    Image = User;
                    RunObject = Page Users;
                    ToolTip = 'Manage system users';
                }
                action("ActionCreateTimeSheets")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Time Sheets';
                    Image = Timesheet;
                    RunObject = report "Create Time Sheets";
                    ToolTip = 'Create or schedule creation of new time sheets';
                }
                action(DimensionConfig)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page Dimensions;
                    Tooltip = 'Configure Dimensions and Default Dimension settings';

                }
                action(ConfigPacks)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Config. Packages';
                    Image = Setup;
                    RunObject = Page "Config. Packages";
                    ToolTip = 'Configuration packages for import and export of data en-masse';
                }
                action(ExtensionManagement)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Extensions';
                    Image = User;
                    RunObject = Page "Extension Management";
                    ToolTip = 'Manage installed extensions';
                }
                action(CueSetup)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cue Setup';
                    Image = User;
                    RunObject = Page "Cue Setup Administrator";
                    ToolTip = 'Cue Setup';
                }
                action(JobQueue)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Job Queue';
                    Image = User;
                    RunObject = Page "Job Queue Entries";
                    ToolTip = 'Manage the job queue for scheduled tasks';
                }
                action(ChangeLog)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Change Log';
                    Image = User;
                    RunObject = Page "Change Log Entries";
                    ToolTip = 'See the change log for recorded fields';
                }
                // action(PhoneNumbers)
                // {
                //     ApplicationArea = Basic, Suite;
                //     Caption = 'Phone Numbers';
                //     Image = ElectronicNumber;
                //     RunObject = Page "Phone Number Lists";
                //     ToolTip = 'Lists of phone numbers';
                // }

                // action(ShopifyLogs)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Shopify Logs';
                //     Image = Log;
                //     RunObject = Page "Shpfy Log Entries";
                //     ToolTip = 'Shopify log entries to see what''s working and what''s broken';
                // }
                action(PhoneNumberReport)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Phone Numbers';
                    Image = ContactPerson;
                    RunObject = report "Phone Numbers";
                    ToolTip = 'Export phone numbers for active customers, vendors and employees';
                }
            }
        }
        addafter(Action3)
        {
            action(GeneralLedgerEntries)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'General Ledger Entries';
                Image = GeneralLedger;
                RunObject = page "General Ledger Entries";
                Tooltip = 'View a list of all general ledger entries - note, filtering will be necessary to make sense of it all';
            }
        }
        addfirst(sections)
        { }
        addafter("Balance Sheet")
        {
            action("Trial Balance")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Trial Balance';
                Image = "Report";
                RunObject = Report "Trial Balance";
                ToolTip = 'View your company''s trial balance (other trial balance reports are available)';
            }
        }
        addlast(Payments)
        {
            action(BankRecs)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Bank Reconciliations';
                Image = BankAccountRec;
                RunObject = Page "Bank Acc. Reconciliation List";
                ToolTip = 'Reconcile bank account statements with posted payments and receipts';
            }
        }
        addlast(New)
        {
            action("NewJob")
            {
                AccessByPermission = TableData "Job" = IMD;
                ApplicationArea = Basic, Suite;
                Caption = 'Project';
                Image = ViewJob;
                RunObject = Page "Job Card";
                RunPageMode = Create;
                ToolTip = 'Create a new project (J-job or P-job)';
            }
        }
        addfirst(Reports)
        {
            group(FinancialReports)
            {
                Caption = 'Financial Reports';
                Image = CalculateCost;
                action(DayCust)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer Day Books';
                    Image = CustomerRating;
                    RunObject = Report "Day Book Cust. Ledger Entry";
                    ToolTip = 'View customer transactions over a given period';
                }
                action(DayVend)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendor Day Books';
                    Image = VendorLedger;
                    RunObject = Report "Day Book Vendor Ledger Entry";
                    ToolTip = 'View supplier transactions over a given period';
                }
                action(DayVAT)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'VAT Day Books';
                    Image = VATLedger;
                    RunObject = Report "Day Book VAT Entry";
                    ToolTip = 'View VAT transactions over a given period';
                }
                action(JobSuggestedBilling)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Project Suggested Billing';
                    Image = JobListSetup;
                    RunObject = Report "Job Suggested Billing";
                    ToolTip = 'View suggested billing for projects';
                }
                action(AgedDebtors)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Aged Debtors/Payables/Customers Report';
                    Image = CustomerCode;
                    RunObject = Report "Aged Accounts Receivable";
                    ToolTip = 'View aged (i.e. due) account receivables (customers owing)';
                }
                action(AgedCreditors)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Aged Creditors/Receivables/Vendors Report';
                    Image = VendorCode;
                    RunObject = Report "Aged Accounts Payable";
                    ToolTip = 'View aged (i.e. due) account payables (suppliers owed)';
                }
            }
        }
        addlast(Shpfy)
        {
            action(ShpfyLog)
            {
                ApplicationArea = All;
                Caption = 'Log';
                Image = Log;
                RunObject = page "Shpfy Log Entries";
                ToolTip = 'View the logged, raw transaction entries for the Shopify connector';
            }
        }
    }
}