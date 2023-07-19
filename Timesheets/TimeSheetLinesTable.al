tableextension 50200 "Time Sheet Line Ext" extends "Time Sheet Line"
{
    fields
    {
        modify(Type)
        {
            trigger OnAfterValidate()
            begin
                Case Type of
                    Type::Absence:
                        Chargeable := false;
                End;
            end;
        }
        modify("Job No.")
        {
            trigger OnBeforeValidate()
            begin
                Rec.Type := Rec.Type::Job;
            end;

            trigger OnAfterValidate()
            var
                i: Integer;
                match: Boolean;
                substring: Text[5];
            begin
                substring := 'ADMIN';
                match := true;
                i := 1;
                while (i <= 5) and match do begin
                    if "Job No."[i] <> substring[i] then
                        match := false;
                    i := i + 1;
                end;
                if match then
                    Chargeable := false;
            end;

        }
        modify("Job Task No.")
        { Caption = 'Job Task'; }
        field(50100; "Work Done"; Text[700])
        { CaptionML = ENG = 'Work Done', ENU = 'Work Done'; }
    }
}