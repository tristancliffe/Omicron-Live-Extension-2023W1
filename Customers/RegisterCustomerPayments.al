pageextension 50191 RegisterCustomerPaymentsExt extends "Payment Registration"
{
    layout
    {
        modify("Source No.")
        {
            Visible = true;
            Caption = 'Account No.';
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Due Date");
        Rec.Ascending(false);
    end;
}