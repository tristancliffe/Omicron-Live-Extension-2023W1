pageextension 50118 ResourceCardExt extends "Resource Card"
{
    layout
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                Message('Please set the Dimension Codes for Department (Same Code) and Resource (Same Code).');
            end;
        }
        modify("Resource Group No.")
        { ShowMandatory = true; }
        modify("Gen. Prod. Posting Group")
        { ShowMandatory = true; }
        modify("VAT Prod. Posting Group")
        { ShowMandatory = true; }
        modify("Unit Cost")
        { ShowMandatory = true; }
        modify("Unit Price")
        { ShowMandatory = true; }
        modify("Base Unit of Measure")
        { ShowMandatory = true; }
        addafter("Search Name")
        {
            field("Resource Notes"; Rec."Resource Notes")
            { MultiLine = true; ApplicationArea = All; ToolTip = 'Resource notes'; }
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
                    Resource.SetFilter("No.", Rec."No.");
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
}