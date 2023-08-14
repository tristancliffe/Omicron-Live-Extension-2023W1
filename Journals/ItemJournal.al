// The extension extends the "Item Journal" page
// The "AboutTitle" and "AboutText" properties provide information about the page
// The "Caption" property defines the page caption
// The "layout" section modifies the layout of the page
// The "actions" section adds an "Item Card" action to the page
// The "trigger OnOpenPage()" displays a message when the page is opened
// The "trigger OnAfterGetRecord()" calls the "GetInventory()" procedure
// The "procedure GetInventory()" retrieves inventory information for an item and sets the value of the "InStock_ItemJournalLine" field.
pageextension 50149 ItemJournalExt extends "Item Journal"
{
    AboutTitle = 'Item Journal for second-hand stock';
    AboutText = 'Use this to add stock, such as second-hand stock, to the inventory. The cost price is taken from the Item Card, but generally speaking a second-hand item has no ''cost'' price, so it ought to be zero. But sometimes we sell secondhand items of regular stock, in which case leave the cost price alone so as not to cause problems...';
    Caption = 'This is the item journal caption';
    layout
    {
        modify("Item No.")
        {
            trigger OnAfterValidate()
            begin
                GetInventory;
            end;
        }
        modify("Reason Code")
        { ShowMandatory = true; }
        modify("Location Code")
        { ShowMandatory = true; }
        addafter(Description)
        {
            field("Reason Code2"; Rec."Reason Code")
            {
                Visible = true;
                ApplicationArea = All;
                ShowMandatory = true;
            }
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                if Rec."Location Code" = '' then
                    Rec.Validate("Location Code", 'STORES')
            end;
        }
        addbefore(Quantity)
        {
            field(Instock_SalesLine; rec.Instock_ItemJournalLine)
            {
                Editable = false;
                Caption = 'In Stock';
                ToolTip = 'This column shows the quantity currently known to be in stock.';
                ApplicationArea = All;
                Visible = true;
                BlankZero = false;
                Style = StandardAccent;
                Width = 5;
                QuickEntry = false;
            }
        }
        modify("Price Calculation Method")
        { Visible = false; }
        modify("Bin Code")
        { Visible = false; }

    }
    actions
    {
        addlast("&Item")
        {
            action(ItemCardLink)
            {
                ApplicationArea = All;
                Image = Item;
                Caption = 'Item Card';
                RunObject = page "Item Card";
                RunPageLink = "No." = field("Item No.");
                Description = 'Go to the Item Card';
                ToolTip = 'Opens the item card for this line';
                Promoted = true;
                PromotedCategory = Process;
                Scope = Repeater;
                Visible = true;
                Enabled = true;
            }
        }
    }


    trigger OnOpenPage()
    begin
        message('Please don''t forget to set if positive or negative adjustment, rather than purchase or sale (unless it is).\ \For putting purchases into stock, please use Purchase Orders to record prices, suppliers, quantities etc.\ \Not following this rule may result in the death of a kitten.');
    end;

    trigger OnAfterGetRecord()
    begin
        GetInventory;
    end;

    local procedure GetInventory()
    var
        Items: Record Item;
    begin
        if Items.Get(Rec."Item No.") and (Items.Type = Items.Type::Inventory) then begin
            Items.CalcFields(Inventory);
            Rec.Instock_ItemJournalLine := Items.Inventory;
            //Rec.Modify();
        end;
    end;
}