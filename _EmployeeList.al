pageextension 50108 EmployeeListExtension extends "Employee List"
{
    AboutTitle = 'Employee List Colours';
    AboutText = 'The colours on the list show if an employee is active (**standard**), inactive (**grey**) or terminated (**dark yellow**).';
    layout
    {
        modify("No.")
        { StyleExpr = BlockedStyleNo; }
        modify("First Name")
        { StyleExpr = BlockedStyle; }
        modify("Last Name")
        { StyleExpr = BlockedStyle; }
        modify("Job Title")
        { StyleExpr = BlockedStyle; }
        modify("Phone No.")
        { StyleExpr = BlockedStyleNo; CaptionML = ENG = 'Home Phone No.'; }
        addafter("Phone No.")
        {
            field("Mobile Phone No.1"; Rec."Mobile Phone No.")
            { ApplicationArea = All; StyleExpr = BlockedStyleNo; }
        }
        addafter("Search Name")
        {
            field("Employee Notes"; Rec."Employee Notes")
            { ApplicationArea = All; ToolTip = 'Employee notes'; }
        }
    }
    views
    {
        addfirst
        {
            view(ActiveEmployees)
            {
                Caption = 'Active';
                Filters = where(Status = const(Active));
            }
            view(InactiveEmployees)
            {
                Caption = 'Inactive';
                Filters = where("Status" = filter('Inactive|Terminated'));
            }
            view(PhoneNumbers)
            {
                Caption = 'Phone Numbers';
                SharedLayout = false;
                layout
                {
                    modify("Job Title")
                    { Visible = false; }
                    modify("E-Mail")
                    { Visible = false; }
                    modify("Search Name")
                    { Visible = false; }
                    modify(Comment)
                    { Visible = false; }
                    modify("Employee Notes")
                    { Visible = false; }
                }
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
        if Rec.Status = Rec.Status::Active then begin
            BlockedStyle := 'Standard';
            BlockedStyleNo := 'StandardAccent';
        end else
            if Rec.Status = Rec.Status::Inactive then begin
                BlockedStyle := 'Subordinate';
                BlockedStyleNo := 'Subordinate';
            end else
                if Rec.Status = Rec.Status::Terminated then begin
                    BlockedStyle := 'Ambiguous';
                    BlockedStyleNo := 'Ambiguous';
                end;
    end;

    var
        BlockedStyle: Text;
        BlockedStyleNo: Text;

    // trigger OnOpenPage()
    // begin
    //     Rec.SetCurrentKey("Last Name", "First Name");
    //     Rec.Ascending(true);
    //     Rec.SetFilter("Status", 'Active');
    //     //Rec.SetView(StrSubstNo('sorting ("No.") order(ascending) where ("Blocked" = filter (' '))'));
    // end;
}