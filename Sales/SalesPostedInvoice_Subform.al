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
        moveafter("Deferral Code"; "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "VAT Bus. Posting Group")
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
    actions
    {
        addlast(processing)
        {
            action(ItemCardLink)
            {
                ApplicationArea = All;
                Image = Item;
                Caption = 'Item Card';
                RunObject = page "Item Card";
                RunPageLink = "No." = field("No.");
                Description = 'Go to the Item Card';
                ToolTip = 'Opens the item card for this line';
                Scope = Repeater;
                Visible = true;
                Enabled = Rec.Type = Rec.Type::Item;
            }
        }
    }
}