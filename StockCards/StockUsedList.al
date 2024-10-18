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
                    Editable = Device;
                }
                field("Job No."; Rec."Job No.")
                {
                    Editable = false;
                }
                field("Date"; Rec."Date")
                {
                    Editable = Posted;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Part No. field.', Comment = '%';
                    Editable = Posted;
                }
                field("Stock Name"; Rec."Stock Name")
                {
                    ToolTip = 'Technicians name for the item.';
                    Editable = Posted;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    Editable = Posted;
                }
                field(StockQty; Rec.StockQty)
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
