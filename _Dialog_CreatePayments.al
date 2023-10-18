pageextension 50200 CreatePaymentExt extends "Create Payment"
{
    layout
    {
        modify("Payment Type")
        { Visible = false; }
    }
}