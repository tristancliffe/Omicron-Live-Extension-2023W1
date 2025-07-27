page 50113 "Stock Card List"
{
    ApplicationArea = All;
    Caption = 'Project Stock Used List';
    PageType = List;
    SourceTable = "Stock Used";
    UsageCategory = Lists;
    AdditionalSearchTerms = 'Stock Card List, Job Stock List, Job Stock Used, Project Parts List';
    SourceTableView = sorting(Date, "Job No.", "Line No.") order(ascending);
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Entered; Rec.Entered) { Editable = Device; }
                field("Job No."; Rec."Job No.") { Editable = Posted; }
                field("Date"; Rec."Date") { Editable = Posted; }
                field("Item No."; Rec."Item No.") { ToolTip = 'Specifies the value of the Part No. field.', Comment = '%'; Editable = Posted; }
                field("Stock Name"; Rec."Stock Name") { Caption = 'Staff''s Description'; ToolTip = 'Technicians name for the item.'; Editable = Posted; }
                field(Description; Rec.Description) { Caption = 'System''s Description'; ToolTip = 'Specifies the value of the Description field.', Comment = '%'; Editable = Posted; }
                field(StockQty; Rec.StockQty) { ToolTip = 'Specifies the value of the Qty field.', Comment = '%'; Editable = Posted; }
                //field(LastOne; Rec.LastOne) { Editable = Posted; }
                field("Resource No."; Rec."Resource No.") { ToolTip = 'Specifies the value of the Resource No. field.', Comment = '%'; Editable = false; }
            }
            group(PlanningLines)
            {
                Caption = 'Project Planning Lines';
                ShowCaption = false;
                Visible = Device;
                part(ProjectPlanningLines; "Job Planning Lines Part")
                {
                    SubPageLink = "Job No." = field("Job No.");
                    SubPageView = sorting("Planning Date") order(Ascending) where("Unit of Measure Code" = const('<>HOUR'));
                    Editable = false;
                    Caption = 'Posted non-Labour Planning Lines';
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(JobJournal)
            {
                Caption = 'Project Journal';
                Image = JobJournal;
                ApplicationArea = All;
                RunObject = Page "Job Journal";
                ToolTip = 'Opens the project journal';
                Visible = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
            }
            action(JobLink)
            {
                ApplicationArea = All;
                Image = Job;
                Caption = 'Project Card';
                RunObject = page "Job Card";
                RunPageLink = "No." = field("Job No.");
                Description = 'Go to the Project card';
                ToolTip = 'Opens the Project Card for this line';
                Scope = Repeater;
                Visible = true;
                Enabled = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
            }
            action(JobPlanning)
            {
                ApplicationArea = All;
                Image = Job;
                Caption = 'Project Planning Lines';
                RunObject = page "Job Planning Lines";
                RunPageLink = "Job No." = field("Job No.");
                Description = 'Go to the Project Planning Lines list for this project';
                ToolTip = 'Opens the Project Planning Lines list for this line';
                Scope = Repeater;
                Visible = true;
                Enabled = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
            }
            action(ItemCardLink)
            {
                ApplicationArea = All;
                Image = Item;
                Caption = 'Item Card';
                RunObject = page "Item Card";
                RunPageLink = "No." = field("Item No.");
                Description = 'Go to the Item Card';
                ToolTip = 'Opens the item card for this line';
                Scope = Repeater;
                Visible = true;
                Enabled = Rec."Item No." <> '';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
            }
            action(ItemJournalLink)
            {
                ApplicationArea = All;
                Image = ItemWorksheet;
                Caption = 'Item Journal';
                RunObject = page "Item Journal";
                Description = 'Go to the Item Journal';
                ToolTip = 'Opens the item journal for entering second-hand stock';
                Promoted = true;
                PromotedCategory = Process;
                Visible = true;
                Enabled = true;
            }
        }
    }
    views
    {
        view(NotEntered) { Caption = 'Not Yet Entered'; Filters = where(Entered = const(false)); }
        view(BeenEntered) { Caption = 'Entered'; Filters = where(Entered = const(true)); }
    }
    var
        Device: Boolean;
        Posted: Boolean;

    trigger OnOpenPage()
    begin
        if (CurrentClientType = CurrentClientType::Phone) or (CurrentClientType = CurrentClientType::Tablet) then
            Device := false
        else
            Device := true;
        if not Rec.IsEmpty then
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
}
