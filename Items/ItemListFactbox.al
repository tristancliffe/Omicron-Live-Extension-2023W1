page 50116 "Item Info FactBox"
{
    Caption = 'Item Details';
    PageType = CardPart;
    SourceTable = "Item";

    layout
    {
        area(content)
        {
            field("No."; Rec."No.") { ApplicationArea = Basic, Suite; Caption = 'Item No.'; Visible = false; }
            field("Shelf No."; Rec."Shelf No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Shelf';
                trigger OnDrillDown()
                var
                    Items: Record Item;
                begin
                    if Rec."Shelf No." = '' then
                        exit
                    else begin
                        Items.Reset();
                        Items.SetFilter("Shelf No.", Rec."Shelf No.");
                        if not Items.IsEmpty then
                            Page.Run(Page::"Item List", Items)
                    end;
                end;
            }
            field(Type; Rec.Type) { ApplicationArea = Basic, Suite; Caption = 'Type'; }
            field("Item Notes"; Rec."Item Notes") { ApplicationArea = Basic, Suite; ShowCaption = false; ToolTip = 'Item notes'; MultiLine = true; }
        }
    }
}