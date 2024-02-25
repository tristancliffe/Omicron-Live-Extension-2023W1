pageextension 50219 FixedAssetCardExt extends "Fixed Asset Card"
{
    layout
    {
        addafter("Responsible Employee")
        {
            field("Asset Notes"; Rec."Asset Notes")
            {
                MultiLine = true;
                Visible = true;
                ApplicationArea = All;

                trigger OnAssistEdit()
                begin
                    message(Rec."Asset Notes");
                end;
            }
        }
        modify(Inactive)
        { Importance = Standard; }
        modify(Blocked)
        { Importance = Standard; }
        modify(Acquired)
        { Importance = Standard; }
    }
}