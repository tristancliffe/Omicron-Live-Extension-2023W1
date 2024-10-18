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
                    Visible = Device;
                }
                field("Date"; Rec."Date")
                {
                    Editable = Posted;
                }
                field(StockQty; Rec.StockQty)
                {
                    Editable = Posted;
                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = Posted;

                    // trigger OnValidate()
                    // var
                    //     Item: Record Item;
                    // begin
                    //     if Item.Get(Rec."Item No.") then begin
                    //         Rec.Validate(Description, Item.Description);
                    //     end;
                    // end;
                }
                field("Stock Name"; Rec."Stock Name")
                {
                    Editable = Posted;
                    InstructionalText = 'Description of parts used';
                }
                field(Description; Rec.Description)
                {
                    Editable = Posted;
                    InstructionalText = 'Description of parts used';
                    Style = Subordinate;
                }
                field("Resource No."; Rec."Resource No.")
                {
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