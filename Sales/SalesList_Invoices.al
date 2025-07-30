pageextension 50244 SalesInvoiceListExt extends "Sales List"
{
    layout
    {
        modify("External Document No.") { Visible = false; }
        modify("Location Code") { Visible = false; }
        addafter("Document Date")
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the invoice reference.';
                Visible = true;
            }
        }
    }
}
