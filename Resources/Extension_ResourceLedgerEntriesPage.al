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

    analysisviews
    {
        addfirst
        {
            analysisview("Resource Ledger Entries with Work Done")
            {
                DefinitionFile = 'Analysis/Total Hours - Jules.analysis.json';
                Caption = 'Total Hours - Jules';
            }
            analysisview("Resource Ledger Entries Productivity")
            {
                DefinitionFile = 'Analysis/Productivity.analysis.json';
                Caption = 'Productivity';
            }

        }
    }
}