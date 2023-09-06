pageextension 50113 JobTasksLineSubformExt extends "Job Task Lines Subform"
{
    layout
    {
        modify("Job Task No.")
        {
            trigger OnAfterValidate()
            begin
                rec.Description := 'Labour re ' + LowerCase(rec."Job Task No.")
            end;
        }
        modify(Control1)
        { FreezeColumn = Description; }
        addafter("Job Task Type")
        {
            field(TaskDimensionValue; TaskDimensionValue)
            { ApplicationArea = All; Caption = 'Dept.'; Editable = false; Style = Ambiguous; }
        }
    }
    // var
    //     TaskDimension: Record "Job Task Dimension";
    //     Task: Record "Job Task";
    //     TaskDimensionValue: Code[20];

    // trigger OnAfterGetRecord()
    // begin
    //     TaskDimension.Get('DEPARTMENT');
    //     TaskDimensionValue := TaskDimension."Dimension Value Code";
    // end;

    var
        TaskDimensionValue: Code[20];

    trigger OnAfterGetRecord()
    var
        TaskDimensionRec: Record "Job Task Dimension";
    begin
        // Filter the "Job Task Dimension" record based on "Job Task No."
        TaskDimensionRec.SetRange("Job No.", rec."Job No.");
        TaskDimensionRec.SETRANGE("Job Task No.", rec."Job Task No.");
        TaskDimensionRec.SETRANGE("Dimension Code", 'DEPARTMENT');

        if TaskDimensionRec.FINDFIRST then begin
            TaskDimensionValue := TaskDimensionRec."Dimension Value Code";
        end;
    end;

}