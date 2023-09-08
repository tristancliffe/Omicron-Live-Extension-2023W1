pageextension 50107 EmployeeCardExt extends "Employee Card"
{
    layout
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                Message('Please set the Resource No. field to the relevant resource, and set Dimension Codes for Department (Code Mandatory) and Resource (Same Code).');
            end;
        }
        modify("E-Mail")
        { ShowMandatory = true; }
        modify("Mobile Phone No.")
        { ShowMandatory = true; }
        addafter("Search Name")
        {
            field("Employee Notes"; Rec."Employee Notes")
            {
                MultiLine = true;
                ApplicationArea = All;
                ToolTip = 'Notes about this employee.';
            }
        }
        modify("Phone No.")
        { CaptionML = ENG = 'Home Phone No.'; }
        modify("Phone No.2")
        { Visible = false; CaptionML = ENG = 'Home Phone No.'; }
    }
    actions
    {
        addlast("E&mployee")
        {
            action(ResourceLink)
            {
                ApplicationArea = All;
                Image = Resource;
                Caption = 'Resource Card';
                RunObject = page "Resource Card";
                RunPageLink = "No." = field("Resource No.");
                Description = 'Go to the Resource Card';
                ToolTip = 'Opens the resource card for this employee';
                Visible = true;
                Enabled = true;
                // Promoted = true;
                // PromotedCategory = Process;
            }
        }
        addlast(Category_Process)
        {
            actionref(Dimensions_Promoted2; Dimensions)
            { }
            actionref(ResourceLink_Promoted; ResourceLink)
            { }
            actionref(Absenses_Promoted; "A&bsences")
            { }
        }
    }
}