page 50115 "Stock Entry List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Stock Used";
    Caption = 'Your Stock Card';
    DelayedInsert = true;
    AutoSplitKey = true;
    SourceTableView = sorting("Date", "Line No.") order(ascending);
    Editable = true;
    AnalysisModeEnabled = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.") { Editable = false; Visible = false; }
                field("Job No."; Rec."Job No.")
                {
                    Editable = Posted;

                    trigger OnDrillDown()
                    var
                        Job: Record Job;
                    begin
                        Job.Reset();
                        Job.SetFilter("No.", Rec."Job No.");
                        if Job.FindFirst() then
                            Message('%1 - %2 \ Reg. No.: %3 \ Chassis No.: %4 \ Engine No.: %5 \ Date Arrived: %6 \\ Notes: %7', Job."No.", Job.Description, Job."Vehicle Reg", Job.ChassisNo, Job.EngineNo, Job."Date of Arrival", Job."Job Notes")
                        else
                            Message('No job found for Job No. %1.', Rec."Job No.");
                    end;
                }
                field(Entered; Rec.Entered) { Visible = true; Editable = false; }
                field("Date"; Rec."Date") { Editable = Posted; Width = 12; }
                field(StockQty; Rec.StockQty)
                {
                    Editable = Posted;
                    ShowMandatory = true;
                    Width = 10;

                    trigger OnValidate()
                    begin
                        if format(rec.Date) = '' then
                            rec.date := Today();
                        CurrPage.SaveRecord();
                    end;
                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = Posted;
                    Width = 12;

                    trigger OnValidate()
                    begin
                        if format(rec.Date) = '' then
                            rec.date := Today();
                        CurrPage.SaveRecord();
                    end;
                }
                field("Stock Name"; Rec."Stock Name")
                {
                    Caption = 'Description of parts';
                    Editable = Posted;
                    InstructionalText = 'Description of part(s) used';
                    ShowMandatory = true;
                    Width = 70;

                    trigger OnValidate()
                    begin
                        if format(rec.Date) = '' then
                            rec.date := Today();
                        CurrPage.SaveRecord();
                    end;
                }
                field(Description; Rec.Description) { Editable = Posted; Style = Subordinate; Visible = false; }
                //field(LastOne; Rec.LastOne) { Editable = Posted; }
                field("Resource No."; Rec."Resource No.") { Editable = false; }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(StockCard)
            {
                Caption = 'Job Stock Card';
                Image = ItemLines;
                ApplicationArea = All;
                RunObject = Page "Stock Card Page";
                RunPageLink = "No." = field("Job No.");
                ToolTip = 'Takes the user to the Stock Card of the selected job as filled in by staff';
                Visible = true;
                // Promoted = true;
                // PromotedCategory = Process;
                // PromotedOnly = true;
                Scope = Repeater;
            }
            // action(JobCard)
            // {
            //     ApplicationArea = All;
            //     Caption = 'View Job Card';
            //     Image = Job;
            //     ToolTip = 'Go to the main job card for the project.';
            //     Scope = Repeater;
            //     RunObject = Page "Job Card";
            //     RunPageLink = "No." = field("Job No.");
            // }
        }
    }
    var
        Device: Boolean;
        Posted: Boolean;
        ManagerTimeSheet: Boolean;

    trigger OnOpenPage()
    begin
        if (CurrentClientType = CurrentClientType::Phone) or (CurrentClientType = CurrentClientType::Tablet) then
            Device := false
        else
            Device := true;
        // Rec.Find('-');
        Rec.FindLast();
    end;

    trigger OnInsertRecord(BelowXRec: Boolean): Boolean
    var
    begin
        Rec."Resource No." := USERID;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Posted := true;
        if Rec.Entered = true then Posted := false;
    end;

    procedure SetManagerTimeSheetMode()
    begin
        ManagerTimeSheet := true;
    end;
}