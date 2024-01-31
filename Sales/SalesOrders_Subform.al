pageextension 50127 SalesOrderFormExt extends "Sales Order Subform"
{
    // Editable = IsOpenOrder;
    layout
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                GetInventory();
                CheckProfit();
                AssemblyWarning();
            end;
        }
        modify(Description)
        { QuickEntry = true; }
        modify(Quantity)
        { style = Strong; }
        Modify("Qty. to Assign")
        { QuickEntry = true; }
        Modify("Item Charge Qty. to Handle")
        { QuickEntry = true; }
        addafter("Unit of Measure Code")
        {
            field(Instock_SalesLine; rec.Instock_SalesLine)
            {
                Editable = false;
                Caption = 'Qty in Stock';
                ToolTip = 'This column shows the quantity currently known to be in stock. Non-inventory and Service items show as 999';
                ApplicationArea = All;
                Visible = true;
                BlankZero = true;
                Style = StandardAccent;
                Width = 5;
            }
        }
        modify("Item Reference No.")
        { Visible = false; }
        addafter("Qty. Assigned")
        {
            field("Gen. Prod. Posting Group2"; Rec."Gen. Prod. Posting Group")
            { ApplicationArea = All; style = Ambiguous; }
            field("VAT Prod. Posting Group1"; Rec."VAT Prod. Posting Group")
            { ApplicationArea = All; style = AttentionAccent; }
            // field("Job No.1"; Rec."Job No.")
            // {
            //     ApplicationArea = All;
            //     Width = 8;
            //     trigger OnValidate()
            //     begin
            //         Rec.ValidateShortcutDimCode(3, Rec."Job No.");
            //         Rec.Modify();
            //         //Rec."Shortcut Dimension 2 Code" := Rec."Job No.";
            //     end;
            // }
            // field("Job Task No.1"; Rec."Job Task No.")
            // { ApplicationArea = All; }
        }
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            begin
                GetInventory();
                CheckProfit();
            end;
        }
        moveafter("Qty. Assigned"; "Unit Cost (LCY)")
        modify("Unit Cost (LCY)")
        {
            Visible = true;
            Style = Ambiguous;
            Editable = false;
            BlankZero = true;
        }
        addafter("Line Amount")
        {
            field("Amount Including VAT"; Rec."Amount Including VAT")
            { ApplicationArea = All; Visible = true; Editable = false; }
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
            action(Reserve2)
            {
                ApplicationArea = Reservation;
                Caption = '&Reserve';
                Ellipsis = true;
                Image = Reserve;
                Enabled = Rec.Type = Rec.Type::Item;
                ToolTip = 'Reserve the quantity of the selected item that is required on the document line from which you opened this page. This action is available only for lines that contain an item.';
                Scope = Repeater;
                Visible = true;
                trigger OnAction()
                begin
                    Rec.Find();
                    Rec.ShowReservation();
                end;
            }
            action("BOM Level_Promoted")
            {
                AccessByPermission = TableData "BOM Buffer" = R;
                ApplicationArea = Assembly;
                Caption = 'BOM Level';
                Image = BOMLevel;
                ToolTip = 'View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.';

                trigger OnAction()
                begin
                    ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByBOM())
                end;
            }
        }
    }

    var
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";

    trigger OnAfterGetRecord()
    begin
        GetInventory;
    end;

    local procedure GetInventory()
    var
        Items: Record Item;
    begin
        if Rec.Type <> Rec.Type::Item then
            Rec.Instock_SalesLine := 0
        else
            if Items.Get(Rec."No.") and (Items.Type = Items.Type::Inventory) then begin
                Items.CalcFields(Inventory); //, "Reserved Qty. on Inventory");
                // Rec.Instock_SalesLine := Items.Inventory;
                // Rec.Modify();
                Rec.Validate(Rec.Instock_SalesLine, Items.Inventory);  // - Items."Reserved Qty. on Inventory");
                Rec.Modify();
                Commit();
            end
            else
                if Items.Get(Rec."No.") and ((Items.Type = Items.Type::"Non-Inventory") or (Items.Type = Items.Type::Service)) then begin
                    // Rec.Instock_SalesLine := 999;
                    // Rec.Modify()
                    Rec.Validate(Rec.Instock_SalesLine, 999);
                    Rec.Modify();
                    Commit();
                end;
    end;

    local procedure CheckProfit()
    begin
        if (rec."Unit Price" < rec."Unit Cost (LCY)") and ((Rec.Type = Rec.Type::Item) or (Rec.Type = Rec.Type::Resource)) then
            message('Selling price of %1 is less than cost price. Be sure to update selling price and any relevant sales orders', Rec."No.")
    end;

    local procedure AssemblyWarning()
    var
        ItemRec: Record Item;
    begin
        if ItemRec.Get(Rec."No.") and (ItemRec."Replenishment System" = ItemRec."Replenishment System"::Assembly) and (Rec.Instock_SalesLine = 0) then begin
            if ItemRec."Assembly Policy" = ItemRec."Assembly Policy"::"Assemble-to-Stock" then
                message('This is an assemble-to-stock ASSEMBLY, and should be assembled manually via Assembly Orders.\ \Using this item journal will probably result in stock levels being incorrect afterwards.')
        end
    end;

    var
        IsOpenOrder: Boolean;

    trigger OnOpenPage()
    var
        Order: Record "Sales Header";
    begin
        if Order.Status = Order.Status::Open then
            IsOpenOrder := true;
    end;
}