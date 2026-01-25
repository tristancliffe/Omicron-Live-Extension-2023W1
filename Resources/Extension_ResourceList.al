pageextension 50119 ResourceListExtension extends "Resource List"
{
    AboutTitle = 'Resource Colours';
    AboutText = 'Current, active resources are shown in **black**. Inactive resources are shown in **grey**.';
    layout
    {
        modify("No.") { StyleExpr = BlockedStyle; }
        modify(Name) { StyleExpr = BlockedStyle; }
        modify(Type) { StyleExpr = BlockedStyle; }
        modify("Base Unit of Measure") { StyleExpr = BlockedStyle; }
        modify("Unit Cost") { StyleExpr = BlockedStyle; }
        modify("Price/Profit Calculation") { StyleExpr = BlockedStyle; }
        modify("Profit %") { StyleExpr = BlockedStyle; }
        modify("Unit Price") { StyleExpr = BlockedStyle; }
        addafter(Type)
        {
            field(ResourceEfficiency30D; ResourceEfficiency30D)
            {
                ApplicationArea = All;
                Caption = 'Efficiency % (30D)';
                DecimalPlaces = 1 : 1;
                BlankZero = true;
                ToolTip = 'Efficiency percentage based on chargeable hours worked versus total hours worked in the last 30 days.';
                trigger OnDrillDown()
                var
                    PlanningLines: Record "Job Planning Line";
                begin
                    PlanningLines.Reset();
                    PlanningLines.SetRange("No.", Rec."No.");
                    PlanningLines.SetFilter("Planning Date", '%1..%2', CalcDate('<-D30>', WorkDate()), WorkDate());
                    PlanningLines.SetCurrentKey("Planning Date", "Job No.");
                    PlanningLines.Ascending(true);
                    Page.Run(Page::"Job Planning Lines", PlanningLines);
                end;
            }
            field(InvoiceEfficiency30D; InvoiceEfficiency30D)
            {
                ApplicationArea = All;
                Caption = 'Invoiceable % (60D)';
                DecimalPlaces = 1 : 1;
                BlankZero = true;
                ToolTip = 'Efficiency percentage based on invoiceable hours versus total hours worked in the last 60 days.';
                trigger OnDrillDown()
                var
                    PlanningLines: Record "Job Planning Line";
                begin
                    PlanningLines.Reset();
                    PlanningLines.SetRange("No.", Rec."No.");
                    PlanningLines.SetFilter("Planning Date", '%1..%2', CalcDate('<-D30>', WorkDate()), WorkDate());
                    PlanningLines.SetFilter("Line Type", 'Billable');
                    PlanningLines.SetCurrentKey("Planning Date", "Job No.");
                    PlanningLines.Ascending(true);
                    Page.Run(Page::"Job Planning Lines", PlanningLines);
                end;
            }
        }
    }
    actions
    {
        addlast(reporting)
        {
            action("Report Resource Efficiency")
            {
                ApplicationArea = Suite;
                Caption = 'Resource Efficiency';
                Image = "Report";
                ToolTip = 'Open the Excel worksheet for resource usage, profitability and efficiency';

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
        }
        addlast(Category_Report)
        {
            actionref(ResourceEfficiency; "Report Resource Efficiency")
            { }
        }
    }
    views
    {
        addfirst
        {
            view(ActiveResources)
            {
                Caption = 'Active';
                Filters = where("Blocked" = const(false));
            }
            view(InactiveResources)
            {
                Caption = 'Inactive';
                Filters = where("Blocked" = const(true));
            }
            view(CurrentStaff)
            {
                Caption = 'Current Staff';
                Filters = where("Search Name" = filter('<>LABOUR'), "Type" = const(Person), "Blocked" = const(false));
            }
            view(Equipment_Prices)
            {
                Caption = 'Equipment';
                Filters = where("Type" = const(Machine), "Blocked" = const(false));
            }
            view(Labour)
            {
                Caption = 'General Labour';
                Filters = where("Search Name" = filter('LABOUR'), "Blocked" = const(false), "Type" = const(Person));
            }
            view(Timesheets)
            {
                Caption = 'Time Sheet Users';
                Filters = where("Use Time Sheet" = const(true), "Blocked" = const(false));
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        Rec.Ascending(true);
        Rec.SetRange(Blocked, false);
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(ChargeableHoursWorked30D, TotalHoursWorked30D, InvoiceableHours30D);
        ResourceEfficiency30D := 100 * Rec.ChargeableHoursWorked30D / (Rec.TotalHoursWorked30D + 0.01);
        InvoiceEfficiency30D := 100 * Rec.InvoiceableHours30D / (Rec.ChargeableHoursWorked30D + 0.01);
        BlockedStyle := SetBlockedStyle();
    end;

    // trigger OnAfterGetCurrRecord()
    // begin
    //     SetBlockedStyle();
    // end;

    procedure SetBlockedStyle(): Text
    begin
        if Rec.Blocked = true then
            exit('Subordinate')
        else
            if Rec."Privacy Blocked" = true then
                exit('Ambiguous');
        exit('');

    end;

    var
        BlockedStyle: Text;
        ResourceEfficiency30D: Decimal;
        InvoiceEfficiency30D: Decimal;

    // trigger OnOpenPage()
    // begin
    //     Rec.SetCurrentKey("No.");
    //     Rec.Ascending(true);
    //     Rec.SetFilter("Blocked", 'No');
    //     //Rec.SetView(StrSubstNo('sorting ("No.") order(ascending) where ("Blocked" = filter (' '))'));
    // end;
}