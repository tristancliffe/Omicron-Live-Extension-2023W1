pageextension 50223 TimesheetArchiveListExt extends "Time Sheet Archive List"
{
    layout
    {
        addafter(Description)
        {
            field(Quantity; Rec.Quantity)
            {
                ApplicationArea = All;
                Visible = true;
                StyleExpr = QuantityStyle;

                trigger OnDrillDown()
                var
                    Timesheet: Record "Time Sheet Header Archive";
                    TimesheetCard: Page "Time Sheet Archive Card";
                begin
                    if Timesheet.Get(Rec."No.") then begin
                        Timesheet.SetRecFilter();
                        TimesheetCard.SetTableView(Timesheet);
                        TimesheetCard.Run();
                    end
                end;
            }
        }
    }

    var
        QuantityStyle: Text;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(Quantity);
        QuantityStyle := 'Standard';
        if Rec.Quantity > 40 then
            QuantityStyle := 'Favorable';
        if Rec.Quantity < 40 then
            QuantityStyle := 'Attention';
    end;
}