pageextension 50232 PostedSalesInvoiceLineExt extends "Posted Sales Invoice Lines"
{
    layout
    {
        addafter("Line Discount %")
        {
            field("Unit Cost"; Rec."Unit Cost")
            { ApplicationArea = All; }
        }
    }
}