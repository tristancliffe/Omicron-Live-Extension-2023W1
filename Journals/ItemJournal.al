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
                AssemblyWarning;
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
                    Rec.Validate("Location Code", 'STORES');
                PurchaseWarning;
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
            action(JobLink)
            {
                ApplicationArea = All;
                Image = Job;
                Caption = 'Job Card';
                RunObject = page "Job Card";
                RunPageLink = "No." = field("Job No.");
                Description = 'Go to the Job card';
                ToolTip = 'Opens the Job Card for this line';
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

    local procedure AssemblyWarning()
    var
        ItemRec: Record Item;
    begin
        if ItemRec.Get(Rec."Item No.") and (ItemRec."Replenishment System" = ItemRec."Replenishment System"::Assembly) then begin
            if ItemRec."Assembly Policy" = ItemRec."Assembly Policy"::"Assemble-to-Order" then
                message('This is an assemble-to-order ASSEMBLY, and should be assembled automatically when posting an invoice, or can be done manually via Assembly Orders.\ \Using this item journal will probably result in stock levels being incorrect afterwards.');
            if ItemRec."Assembly Policy" = ItemRec."Assembly Policy"::"Assemble-to-Stock" then
                message('This is an assemble-to-stock ASSEMBLY, and should be assembled manually via Assembly Orders.\ \Using this item journal will probably result in stock levels being incorrect afterwards.')
        end
    end;

    local procedure PurchaseWarning()
    begin
        if (Rec."Entry Type" = Rec."Entry Type"::Purchase) or (Rec."Entry Type" = Rec."Entry Type"::Sale) then
            message('Make sure you change the entry type to Positive or Negative Adj. unless you really intend to use type Purchase')
    end;
}