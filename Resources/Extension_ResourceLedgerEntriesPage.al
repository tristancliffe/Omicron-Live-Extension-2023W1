pageextension 50203 "Resource Ledger Entries Ext" extends "Resource Ledger Entries"
{
    layout
    {
        movebefore(Description; "Job No.")
        modify("Job No.")
        { Visible = true; ApplicationArea = All; }
        addafter(Description)
        {
            field("Work Done"; Rec."Work Done")
            {
                ApplicationArea = all;
                AssistEdit = true;

                trigger OnAssistEdit()
                begin
                    Message(Rec."Work Done");
                end;
            }
        }
    }
}