pageextension 50113 JobTasksLineSubformExt extends "Job Task Lines Subform"
{
    layout
    {
        modify("Job Task No.")
        {
            trigger OnAfterValidate()
            begin
                rec.Description := 'Labour re ' + LowerCase(rec.Description)
            end;
        }
        modify(Control1)
        { FreezeColumn = Description; }
    }
}