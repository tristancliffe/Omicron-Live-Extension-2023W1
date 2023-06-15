pageextension 50139 "PostedSalesInvoiceSubform Ext" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter(Description)
        {
            field("Work Done"; Rec."Work Done")
            {
                ApplicationArea = Basic;
                AssistEdit = true;

                trigger OnAssistEdit()
                begin
                    Message(Rec."Work Done");
                end;
            }
        }
        moveafter("Deferral Code"; "VAT Bus. Posting Group")
        moveafter("Deferral Code"; "Gen. Prod. Posting Group")
        moveafter("Deferral Code"; "Gen. Bus. Posting Group")
        modify("Unit Cost (LCY)")
        {
            Visible = true;
            Style = Ambiguous;
            Editable = false;
            BlankZero = true;
        }
        moveafter("Unit Price"; "Unit Cost (LCY)")
        addafter("Line Amount")
        {
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = All;
                Visible = true;
                Editable = false;
            }
        }
    }
}