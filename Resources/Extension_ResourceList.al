pageextension 50119 ResourceListExtension extends "Resource List"
{
    AboutTitle = 'Resource Colours';
    AboutText = 'Current, active resources are shown in **black**. Inactive resources are shown in **grey**.';
    layout
    {
        modify("No.")
        { StyleExpr = BlockedStyleNo; }
        modify(Name)
        { StyleExpr = BlockedStyle; }
        modify(Type)
        { StyleExpr = BlockedStyle; }
        modify("Base Unit of Measure")
        { StyleExpr = BlockedStyle; }
        modify("Unit Cost")
        { StyleExpr = BlockedStyle; }
        modify("Price/Profit Calculation")
        { StyleExpr = BlockedStyle; }
        modify("Profit %")
        { StyleExpr = BlockedStyle; }
        modify("Unit Price")
        { StyleExpr = BlockedStyle; }
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

    trigger OnAfterGetRecord()
    begin
        SetBlockedStyle();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetBlockedStyle();
    end;

    procedure SetBlockedStyle()
    begin
        if Rec.Blocked = false then begin
            BlockedStyle := 'Standard';
            BlockedStyleNo := 'StandardAccent';
        end else
            if Rec.Blocked = true then begin
                BlockedStyle := 'Subordinate';
                BlockedStyleNo := 'Subordinate';
            end else
                if Rec."Privacy Blocked" = true then begin
                    BlockedStyle := 'Ambiguous';
                    BlockedStyleNo := 'Ambiguous';
                end;
    end;

    var
        BlockedStyle: Text;
        BlockedStyleNo: Text;

    // trigger OnOpenPage()
    // begin
    //     Rec.SetCurrentKey("No.");
    //     Rec.Ascending(true);
    //     Rec.SetFilter("Blocked", 'No');
    //     //Rec.SetView(StrSubstNo('sorting ("No.") order(ascending) where ("Blocked" = filter (' '))'));
    // end;
}