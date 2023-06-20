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
}