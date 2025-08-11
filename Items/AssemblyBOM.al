// It defines a page extension named "AssemblyBOMExt" which extends "Assembly BOM" page.
// It adds an action named "Edit" at the last position of the "processing" action group.
// The action has some properties like ApplicationArea, Caption, Image, ToolTip, etc.
// The action is triggered on click and it retrieves the selected item or resource record based on their types.
// If the selected record is an item, it opens the "Item Card" page, otherwise, it opens the "Resource Card" page.
pageextension 50164 AssemblyBOMExt extends "Assembly BOM"
{
    actions
    {
        addlast(processing)
        {
            action(Edit)
            {
                ApplicationArea = Assembly;
                Caption = 'Item Card';
                Image = Item;
                ToolTip = 'View and modify the selected component.';
                Scope = Repeater;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    Item: Record Item;
                    Resource: Record Resource;
                begin
                    case Rec.Type of
                        Rec.type::Item:
                            begin
                                Item.Get(Rec."No.");
                                PAGE.Run(PAGE::"Item Card", Item)
                            end;
                        Rec.Type::Resource:
                            begin
                                Resource.Get(rec."No.");
                                PAGE.Run(PAGE::"Resource Card", Resource);
                            end;
                    end;
                end;
            }
        }
    }
}