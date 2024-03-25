pageextension 50227 PostedCreditMemoSubformExt extends "Posted Purch. Cr. Memo Subform"
{
    layout
    {
        addbefore(Type)
        {
            field(IsJobLine; IsJobLine)
            { ApplicationArea = all; Caption = 'Job Line'; Editable = false; }
        }
    }
    var
        IsJobLine: Boolean;

    trigger OnAfterGetRecord()
    begin
        IsJobLineCheck();
    end;

    local procedure IsJobLineCheck()
    begin
        IsJobLine := false;
        if rec."Job No." <> '' then
            IsJobLine := true;
    end;
}