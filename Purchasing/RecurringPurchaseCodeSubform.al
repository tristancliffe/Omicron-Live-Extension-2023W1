pageextension 50224 PurchaseCodeSubformExt extends "Standard Purchase Code Subform"
{
    layout
    {
        moveafter(Quantity; "Amount Excl. VAT")
        modify("Amount Excl. VAT")
        { Visible = true; }
    }
}