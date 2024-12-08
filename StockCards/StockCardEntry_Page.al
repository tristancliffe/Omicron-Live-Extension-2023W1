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

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.") { Editable = false; Visible = false; }
                field("Job No."; Rec."Job No.") { Editable = Posted; }
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
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Scope = Repeater;
            }
        }
    }
    var
        Device: Boolean;
        Posted: Boolean;
        ManagerTimeSheet: Boolean;

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

    procedure SetManagerTimeSheetMode()
    begin
        ManagerTimeSheet := true;
    end;
}