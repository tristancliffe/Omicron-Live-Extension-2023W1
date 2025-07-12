pageextension 50241 AvailabilitybyBOMext extends "Item Availability by BOM Level"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field(ShelfNo; "Shelf No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the shelf number for the item.';
                Caption = 'Shelf No.';
                Width = 3;
            }
        }
        modify("Unit of Measure Code") { Width = 3; }
        modify("Qty. per Parent") { Width = 3; }
    }
    var
        "Shelf No.": code[10];

    trigger OnAfterGetRecord()
    var
        Item: Record Item;
    begin
        if Rec."No." <> '' then begin
            Item.Get(Rec."No.");
            "Shelf No." := Item."Shelf No.";
        end else
            "Shelf No." := '';
    end;
}