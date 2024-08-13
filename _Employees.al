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
            }
        }
        modify("Phone No.")
        { CaptionML = ENG = 'Home Phone No.'; }
        modify("Phone No.2")
        { Visible = false; CaptionML = ENG = 'Home Phone No.'; }
        addafter("Grounds for Term. Code")
        {
            field("Employment Duration"; EmploymentDuration)
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'Employment Duration';
            }
        }
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
    var
        EmploymentDuration: Text;

    trigger OnAfterGetRecord()
    begin
        if Rec."Inactive Date" = 0D then
            EmploymentDuration := CalculateTimeBetweenTwoDate(Rec."Employment Date", Today)
        else
            EmploymentDuration := CalculateTimeBetweenTwoDate(Rec."Employment Date", Rec."Inactive Date")
    end;

    // local procedure CalculateTimeBetweenTwoDate(StartDate: Date; EndDate: Date): Text
    // var
    //     NoOfYears: Integer;
    //     NoOfMonths: Integer;
    //     NoOfDays: Integer;
    // begin
    //     //if Rec."Termination Date" <> 0D then EndDate := Today;
    //     NoOfYears := DATE2DMY(EndDate, 3) - DATE2DMY(StartDate, 3);
    //     NoOfMonths := DATE2DMY(EndDate, 2) - DATE2DMY(StartDate, 2);
    //     NoOfDays := DATE2DMY(EndDate, 1) - DATE2DMY(StartDate, 1);
    //     exit(format(NoOfYears+(NoOfMonths/12)+(NoOfDays/365)) + 'Y ');
    //     //exit((12 * NoOfYears) + NoOfMonths + (NoOfDays / 30));
    //     // exit(format(12 * NoOfYears) + ' years ' + format(NoOfMonths) + ' months ' + format(NoOfDays) + ' days');
    // end;

    local procedure CalculateTimeBetweenTwoDate(StartDate: Date; EndDate: Date): Text
    var
        NoOfYears: Integer;
        NoOfMonths: Integer;
        NoOfDays: Integer;
        DaysInMonth: Integer;
    begin
        if EndDate < StartDate then exit;

        // Calculate years difference
        NoOfYears := DATE2DMY(EndDate, 3) - DATE2DMY(StartDate, 3);
        // Calculate months difference
        NoOfMonths := DATE2DMY(EndDate, 2) - DATE2DMY(StartDate, 2);
        // Calculate days difference
        NoOfDays := DATE2DMY(EndDate, 1) - DATE2DMY(StartDate, 1);

        // Adjust for negative days
        if NoOfDays < 0 then begin
            // Get the number of days in the previous month
            DaysInMonth := CALCDATE('<+1M>', DMY2DATE(1, DATE2DMY(EndDate, 2) - 1, DATE2DMY(EndDate, 3))) - DMY2DATE(1, DATE2DMY(EndDate, 2) - 1, DATE2DMY(EndDate, 3));
            NoOfDays := NoOfDays + DaysInMonth;
            NoOfMonths := NoOfMonths - 1;
        end;

        // Adjust for negative months
        if NoOfMonths < 0 then begin
            NoOfMonths := NoOfMonths + 12;
            NoOfYears := NoOfYears - 1;
        end;

        exit(Format(NoOfYears) + ' years, ' + Format(NoOfMonths) + ' months, ' + Format(NoOfDays) + ' days');
    end;
}