pageextension 50193 JobTaskLines extends "Job Task Lines"
{
    layout
    {
        modify("Job Task No.")
        {
            Caption = 'Job Task';
            ShowMandatory = true;

            trigger OnAfterValidate()
            begin
                Rec.Description := 'Labour re ' + text.LowerCase(Rec."Job Task No.")
            end;
        }
        modify(Description)
        { ShowMandatory = true; }
        modify("Job Task Type")
        { Visible = Device; }
        modify(Totaling)
        { Visible = Device; }
        modify("Job Posting Group")
        { Visible = Device; }
        modify("WIP-Total")
        { Visible = Device; }
        modify("WIP Method")
        { Visible = Device; }
        modify("Start Date")
        { Visible = Device; }
        modify("End Date")
        { Visible = Device; }
        modify("Schedule (Total Cost)")
        { Visible = Device; }
        modify("Schedule (Total Price)")
        { Visible = Device; }
        modify("Usage (Total Cost)")
        { Visible = Device; }
        modify("Usage (Total Price)")
        { Visible = Device; }
        modify("Contract (Total Cost)")
        { Visible = Device; }
        modify("Contract (Total Price)")
        { Visible = Device; }
        modify("Contract (Invoiced Cost)")
        { Visible = Device; }
        modify("Contract (Invoiced Price)")
        { Visible = Device; }
        modify("Remaining (Total Cost)")
        { Visible = Device; }
        modify("Remaining (Total Price)")
        { Visible = Device; }
        modify("EAC (Total Cost)")
        { Visible = Device; }
        modify("EAC (Total Price)")
        { Visible = Device; }
        modify("Global Dimension 1 Code")
        { Visible = Device; }
        modify("Global Dimension 2 Code")
        { Visible = Device; }
    }
    var
        Device: Boolean;

    trigger OnOpenPage()
    begin
        if (CurrentClientType = CurrentClientType::Phone) or (CurrentClientType = CurrentClientType::Tablet) then
            Device := false
        else
            Device := true;
    end;
}