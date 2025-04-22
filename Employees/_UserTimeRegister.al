pageextension 50157 UserTimeRegisterExt extends "User Time Registers"
{
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Date", "User ID");
        Rec.Ascending(false);
    end;
}