pageextension 50246 ItemPlanningFactboxExt extends "Item Planning FactBox"
{
    layout
    {
        addafter("No.")
        {
            field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
            { ApplicationArea = All; ToolTip = 'The quantity on sales orders for the item.'; Caption = 'Qty. on Sales Order'; }
            field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
            { ApplicationArea = All; ToolTip = 'The quantity on purchase orders for the item.'; Caption = 'Qty. on Purch. Order'; }
        }
    }
}
