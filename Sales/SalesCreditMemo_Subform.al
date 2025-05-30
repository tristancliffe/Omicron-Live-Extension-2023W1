pageextension 50175 SalesCreditMemoSubformExt extends "Sales Cr. Memo Subform"
{
    layout
    {
        modify(Description)
        { QuickEntry = true; }
        modify(Quantity)
        { style = Strong; }
        Modify("Qty. to Assign")
        { QuickEntry = true; }
        modify("Item Reference No.")
        { Visible = false; }
        addafter("Qty. Assigned")
        {
            field("Gen. Prod. Posting Group2"; Rec."Gen. Prod. Posting Group")
            { ApplicationArea = All; style = Ambiguous; }
            field("VAT Prod. Posting Group1"; Rec."VAT Prod. Posting Group")
            { ApplicationArea = All; style = AttentionAccent; }
        }
        addafter("Line Amount")
        {
            field("Amount Including VAT"; Rec."Amount Including VAT")
            { ApplicationArea = All; Visible = true; Editable = false; }
        }
        // modify("Total VAT Amount")
        // {
        //     trigger OnDrillDown()
        //     var
        //         SalesHeader: Record "Sales Header";
        //     begin
        //         if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then
        //             Page.Run(Page::"Sales Statistics", SalesHeader)
        //         else
        //             Error('The related Sales Header could not be found.');
        //     end;
        // }
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