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
        modify("Contract (Total Price)")
        { StyleExpr = InvoiceWarning; }
        modify("Usage (Total Cost)")
        { StyleExpr = LossWarning; }
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
        InvoiceWarning: Text;
        LossWarning: Text;

    trigger OnAfterGetRecord()
    var
        TaskDimensionRec: Record "Job Task Dimension";
    begin
        InvoiceWarning := SetInvoiceWarning();
        LossWarning := SetLossWarning();
        // Filter the "Job Task Dimension" record based on "Job Task No."
        TaskDimensionRec.SetRange("Job No.", rec."Job No.");
        TaskDimensionRec.SETRANGE("Job Task No.", rec."Job Task No.");
        TaskDimensionRec.SETRANGE("Dimension Code", 'DEPARTMENT');

        if TaskDimensionRec.FINDFIRST then begin
            TaskDimensionValue := TaskDimensionRec."Dimension Value Code";
        end;
    end;

    procedure SetInvoiceWarning(): Text
    begin
        if Rec."Contract (Total Price)" > Rec."Contract (Invoiced Price)" then
            exit('Attention');
        exit('');
    end;

    procedure SetLossWarning(): Text
    begin
        if Rec."Usage (Total Cost)" > Rec."Contract (Invoiced Price)" then
            exit('Attention');
        exit('');
    end;
}