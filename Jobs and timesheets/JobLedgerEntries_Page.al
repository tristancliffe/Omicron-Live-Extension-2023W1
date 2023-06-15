pageextension 50202 "Job Ledger Entries Ext" extends "Job Ledger Entries"
{
    layout
    {
        movebefore(Description; "Job No.")
        movebefore(Description; "Job Task No.")
        modify("Job No.")
        {
            Visible = true;
            ApplicationArea = All;
        }
        modify("Job Task No.")
        {
            Visible = true;
            ApplicationArea = All;
        }
        addafter(Description)
        {
            field("Work Done"; Rec."Work Done")
            {
                ApplicationArea = all;
                AssistEdit = true;

                trigger OnAssistEdit()
                var
                    Dialog: Page "Work Done Dialog";
                begin
                    Dialog.GetText(rec."Work Done");
                    if Dialog.RunModal() = Action::OK then
                        rec."Work Done" := Dialog.SaveText()
                end;
            }
        }
    }
}