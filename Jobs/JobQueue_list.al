page 50123 "Project Queue"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Project Enquiry";
    //CardPageId = "Project Enquiry Card";
    Editable = true;
    AdditionalSearchTerms = 'Project Enquiry List, Workshop Queue, Project Queue List';
    SourceTableView = sorting("In Progress", "Date of Enquiry", "Entry No.") order(ascending); // where("Done" = const(false));

    layout
    {
        area(Content)
        {
            repeater(List)
            {

                field("Date of Enquiry"; Rec."Date of Enquiry")
                {
                    ApplicationArea = All;
                    StyleExpr = LineStyle;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    StyleExpr = LineStyle;
                }
                field("Contact Details"; Rec."Contact Details")
                {
                    ApplicationArea = All;
                    StyleExpr = LineStyle;

                    trigger OnDrillDown()
                    begin
                        if Rec."Contact Details" <> '' then
                            Message(Rec."Contact Details");
                        exit;
                    end;
                }
                field("Location"; Rec."Location")
                {
                    ApplicationArea = All;
                    StyleExpr = LineStyle;
                }
                field("Car"; Rec."Car")
                {
                    ApplicationArea = All;
                    StyleExpr = LineStyle;
                }
                field("Requirements"; Rec."Requirements")
                {
                    ApplicationArea = All;
                    StyleExpr = LineStyle;

                    trigger OnDrillDown()
                    begin
                        If Rec.Requirements <> '' then
                            Message(Rec.Requirements);
                        exit;
                    end;
                }
                field("Date Contacted"; Rec."Date Contacted")
                {
                    ApplicationArea = All;
                    StyleExpr = LineStyle;
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    StyleExpr = LineStyle;

                    trigger OnDrillDown()
                    begin
                        if Rec.Notes <> '' then
                            Message(Rec.Notes);
                        exit;
                    end;
                }
                field(Postponed; Rec.Postponed)
                {
                    ApplicationArea = All;
                }
                field(Incoming; Rec.Incoming)
                {
                    ApplicationArea = All;
                }
                field("In Progress"; Rec."In Progress")
                {
                    ApplicationArea = All;
                }
                field("Done"; Rec."Done")
                {
                    ApplicationArea = All;
                }
                field("Cancelled"; Rec."Cancelled")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            group(Projects)
            {
                Caption = 'Projects';
                Image = Job;
                action(JobList)
                {

                    ApplicationArea = All;
                    Caption = 'Project List';
                    Image = Job;
                    ToolTip = 'Go to the main project list.';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Job List";

                }
                action("NewJob")
                {
                    AccessByPermission = TableData "Job" = IMD;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create New Project';
                    Promoted = true;
                    PromotedCategory = Process;
                    Image = ViewJob;
                    RunObject = Page "Job Card";
                    RunPageMode = Create;
                    ToolTip = 'Create a new project (J-job or P-job)';
                }
            }
        }
    }

    views
    {
        view(IsInQueue)
        {
            Caption = 'In Queue';
            Filters = where("In Progress" = const(false), Done = const(false), "Cancelled" = const(false), "Postponed" = const(false));
            OrderBy = Ascending("Date of Enquiry");
        }
        view(IsInProgress)
        {
            Caption = 'In Progress';
            Filters = where("In Progress" = const(true));
            OrderBy = Ascending("Date of Enquiry");
        }
        view(IsPostponed)
        {
            Caption = 'Postponed';
            Filters = where(Postponed = const(true));
            OrderBy = Ascending("Date of Enquiry");
        }
        view(IsCancelled)
        {
            Caption = 'Cancelled';
            Filters = where("Cancelled" = const(true));
            OrderBy = Ascending("Date of Enquiry");
        }
        view(Completed)
        {
            Caption = 'Completed';
            Filters = where(Done = const(true));
            OrderBy = Ascending("Date of Enquiry");
        }
    }

    var
        LineStyle: Text;

    trigger OnOpenPage()
    begin
        Rec.FindLast();
    end;

    trigger OnAfterGetRecord()
    begin
        LineStyle := SetLineStyle();
    end;

    local procedure SetLineStyle(): Text
    begin

        if Rec.Done then
            exit('Strong')
        else if Rec.Cancelled then
            exit('Ambiguous')
        else if Rec."In Progress" then
            exit('Favorable')
        else if Rec."Incoming" then
            exit('Attention')
        else
            exit('Standard');
    end;
}