pageextension 50108 EmployeeListExtension extends "Employee List"
{
    AboutTitle = 'Employee List Colours';
    AboutText = 'The colours on the list show if an employee is active (**standard**), inactive (**grey**) or terminated (**dark yellow**).';
    layout
    {
        modify("No.") { StyleExpr = BlockedStyle; }
        modify("First Name") { StyleExpr = BlockedStyle; }
        modify("Last Name") { StyleExpr = BlockedStyle; }
        modify("Job Title") { StyleExpr = BlockedStyle; }
        modify("Phone No.") { Visible = true; StyleExpr = BlockedStyle; CaptionML = ENG = 'Home Phone No.'; }
        modify("Mobile Phone No.") { Visible = true; StyleExpr = BlockedStyle; }
        modify("E-Mail") { Visible = true; StyleExpr = BlockedStyle; }
        moveafter("Phone No."; "Mobile Phone No.", "E-Mail")
        addafter("Search Name")
        {
            field("Employee Notes"; Rec."Employee Notes") { ApplicationArea = All; }
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
                    modify("Job Title") { Visible = false; }
                    modify("E-Mail") { Visible = false; }
                    modify("Search Name") { Visible = false; }
                    modify(Comment) { Visible = false; }
                    modify("Employee Notes") { Visible = false; }
                    modify("Balance (LCY)") { Visible = false; }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        BlockedStyle := SetBlockedStyle();
    end;

    procedure SetBlockedStyle(): Text
    begin
        if Rec.Status = Rec.Status::Inactive then
            exit('Subordinate')
        else
            if Rec.Status = Rec.Status::Terminated then
                exit('Ambiguous');
        exit('');
    end;

    var
        BlockedStyle: Text;

    // trigger OnOpenPage()
    // begin
    //     Rec.SetCurrentKey("Last Name", "First Name");
    //     Rec.Ascending(true);
    //     Rec.SetFilter("Status", 'Active');
    //     //Rec.SetView(StrSubstNo('sorting ("No.") order(ascending) where ("Blocked" = filter (' '))'));
    // end;
}