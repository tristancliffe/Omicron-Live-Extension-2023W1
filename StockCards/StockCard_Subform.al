page 50112 "Stock Used Subform"
{
    ApplicationArea = All;
    Caption = 'Stock Used Subform';
    PageType = ListPart;
    SourceTable = "Stock Used";
    DelayedInsert = true;
    AutoSplitKey = true;
    SourceTableView = sorting("Date", "Line No.") order(ascending);

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                { Editable = false; Visible = false; }
                field("Job No."; Rec."Job No.")
                { Editable = false; Visible = false; }
                field(Entered; Rec.Entered)
                {
                    ToolTip = 'Specifies the value of the Entered to Project field.', Comment = '%';
                    Visible = Device;
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.', Comment = '%';
                    Editable = Posted;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Quantity used', Comment = '%';
                    Editable = Posted;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Item part number, if known', Comment = '%';
                    Editable = Posted;

                    trigger OnValidate()
                    var
                        Item: Record Item;
                    begin
                        if Item.Get(Rec."Item No.") then begin
                            Rec.Validate(Description, Item.Description);
                        end;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Part description - can be changed by the user.', Comment = '%';
                    Editable = Posted;
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ToolTip = 'Will auto populate when a line is entered.', Comment = '%';
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