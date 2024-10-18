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
        modify(Control1) { FreezeColumn = Description; }
        addafter("Job Task Type")
        {
            field(TaskDimensionValue; TaskDimensionValue) { ApplicationArea = All; Caption = 'Dept.'; Editable = false; Style = Ambiguous; }
        }
        modify("Contract (Total Price)") { StyleExpr = InvoiceWarning; }
        modify("Usage (Total Cost)") { StyleExpr = LossWarning; }
        addafter("Schedule (Total Cost)")
        {
            field("Usage (Total Hours)"; Rec."Usage (Total Hours)") { ApplicationArea = Jobs; }
        }
        addafter("Contract (Invoiced Price)")
        {
            field(ToInvoice; Rec.ToInvoice)
            {
                ApplicationArea = All;
                Caption = 'To Invoice';
                Editable = False;
                BlankZero = true;
            }
            field("% Completed"; PercentCompleted)
            {
                ApplicationArea = Jobs;
                Caption = '%';
                Editable = false;
                StyleExpr = CompletedWarning;
                BlankZero = true;
                ToolTip = 'Specifies the percentage of the task''s estimated resource usage that has been posted as used.';
                DecimalPlaces = 0 : 0;
            }
            field("Budget Delta"; BudgetDelta)
            {
                ApplicationArea = All;
                Caption = 'Delta to Budget';
                Editable = false;
                StyleExpr = CompletedWarning;
                BlankZero = true;
                ToolTip = 'Specifies the amount above or below the task''s budget that has been posted';
                DecimalPlaces = 0 : 0;
            }
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
        InvoiceWarning: Text;
        LossWarning: Text;
        CompletedWarning: Text;
        PercentCompleted: Decimal;
        BudgetDelta: Decimal;

    trigger OnAfterGetRecord()
    var
        TaskDimensionRec: Record "Job Task Dimension";
    begin
        CompletedWarning := PercentCompletedCalc();
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

    procedure PercentCompletedCalc(): Text
    begin
        if (Rec."Schedule (Total Price)" = 0) or (Rec."Usage (Total Price)" = 0) then begin
            PercentCompleted := 0;
            BudgetDelta := 0;
        end
        else begin
            PercentCompleted := 100 * Rec."Usage (Total Price)" / rec."Schedule (Total Price)";
            BudgetDelta := Rec."Usage (Total Price)" - rec."Schedule (Total Price)";
            if PercentCompleted > 95 then
                exit('Unfavorable');
            exit('');
        end;
    end;
}