page 50100 "Logged-In Users"
{
    Caption = 'Currently Logged In Users';
    PageType = List;
    SourceTable = "Active Session";
    SourceTableTemporary = true;
    UsageCategory = Lists;
    InsertAllowed = false;
    Editable = false;
    DeleteAllowed = false;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field';
                }
                field("Login Datetime"; Rec."Login Datetime")
                {
                    ToolTip = 'Specifies the value of the Login Datetime field';
                }
                field("Client Type"; Rec."Client Type")
                {
                    ToolTip = 'Specifies the value of the Client Type field';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        ActiveSession: Record "Active Session";
        LastUserID: Text[132];
    begin
        LastUserID := '';
        ActiveSession.Reset();
        ActiveSession.SetCurrentKey("User ID");
        ActiveSession.Ascending(true);
        if ActiveSession.FindSet() then
            repeat
                if not (ActiveSession."User ID" = LastUserID) then begin
                    Rec.Init();
                    Rec."Server Instance ID" := ActiveSession."Server Instance ID";
                    Rec."Session ID" := ActiveSession."Session ID";
                    Rec."User ID" := ActiveSession."User ID";
                    Rec."Login Datetime" := ActiveSession."Login Datetime";
                    Rec."Client Type" := ActiveSession."Client Type";
                    Rec.Insert();
                    LastUserID := ActiveSession."User ID";
                end;
            until ActiveSession.Next() = 0;
    end;
}
//?billable