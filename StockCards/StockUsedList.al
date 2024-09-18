page 50113 "Stock Card List"
{
    ApplicationArea = All;
    Caption = 'Project Stock Used List';
    PageType = List;
    SourceTable = "Stock Used";
    UsageCategory = Lists;
    SourceTableView = sorting("Date", "Job No.", "Line No.") order(ascending);

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Entered; Rec.Entered)
                {
                    ToolTip = 'Specifies the value of the Entered to Project field.', Comment = '%';
                    Visible = Device;
                }
                field("Job No."; Rec."Job No.")
                {
                    ToolTip = 'Specifies the value of the Project No. field.', Comment = '%';
                    Editable = false;
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.', Comment = '%';
                    Editable = Posted;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Part No. field.', Comment = '%';
                    Editable = Posted;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    Editable = Posted;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Qty field.', Comment = '%';
                    Editable = Posted;
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ToolTip = 'Specifies the value of the Resource No. field.', Comment = '%';
                    Editable = false;
                }
            }
        }
    }
    var
        Device: Boolean;
        Posted: Boolean;

    trigger OnOpenPage()
    begin
        Rec.FindLast();
        if (CurrentClientType = CurrentClientType::Phone) or (CurrentClientType = CurrentClientType::Tablet) then
            Device := false
        else
            Device := true;
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
