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
        modify("Substitution Available")
        { Visible = true; }
        modify(Description)
        { QuickEntry = true; StyleExpr = CommentStyle; }
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
                DecimalPlaces = 0 : 2;
            }
        }
        modify("Item Reference No.")
        { Visible = false; }
        moveafter("Qty. Assigned"; "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "VAT Bus. Posting Group", "VAT Prod. Posting Group")
        modify("Gen. Prod. Posting Group") { Style = Ambiguous; }
        modify("VAT Prod. Posting Group") { Style = AttentionAccent; }
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            begin
                GetInventory();
                CheckProfit();
            end;
        }
        moveafter("Line Discount %"; "Line Discount Amount")
        modify("Line Discount Amount") { Visible = true; }
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
        addafter("Unit Cost (LCY)")
        {
            field("Line Profit"; Rec."Line Amount" - (Rec.Quantity * Rec."Unit Cost (LCY)"))
            { ApplicationArea = all; Editable = false; Caption = 'Line Profit'; ToolTip = 'The amount of profit, including customer discount but not invoice discount, on this line compared to the displayed cost'; }
        }
        modify("Planned Shipment Date")
        { QuickEntry = false; }
        modify("Shortcut Dimension 1 Code")
        { QuickEntry = false; }
        modify("Shortcut Dimension 2 Code")
        { QuickEntry = false; }
        modify(ShortcutDimCode3)
        { QuickEntry = false; }
        modify(ShortcutDimCode4)
        { QuickEntry = false; }
        modify(ShortcutDimCode5)
        { QuickEntry = false; }
        modify(ShortcutDimCode6)
        { QuickEntry = false; }
        modify(ShortcutDimCode7)
        { QuickEntry = false; }
        modify(ShortcutDimCode8)
        { QuickEntry = false; }
        moveafter("Qty. to Assemble to Order"; WSB_AvailabilityIndicator)
        addafter(Description)
        {
            field("Attached Doc Count"; Rec."Attached Doc Count")
            {
                ApplicationArea = All;
                Caption = 'Files';
                ToolTip = 'Specified the number of files attached to this record. Click to open and then print. Can be brought into emails sent within Business Central.';
                Width = 2;
                BlankZero = true;

                trigger OnDrillDown()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal();
                end;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action(SummaryPage)
            {
                ApplicationArea = All;
                Caption = 'Summary';
                Image = CoupledSalesInvoice;
                RunObject = page "SalesOrderLineSummary";
                RunPageOnRec = true;
                RunPageView = sorting("Document Type", "Document No.", "Line No.");
                // RunPageLink = "No." = field("No.");
                Description = 'View a summary of this line';
                ToolTip = 'Opens the summary card for this line';
                Scope = Repeater;
                Visible = true;
            }
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
            action(ItemJournal)
            {
                Caption = 'Item Journal';
                Image = ItemRegisters;
                ApplicationArea = All;
                RunObject = Page "Item Journal";
                ToolTip = 'Takes the user to the item journal to add [secondhand] stock';
                Visible = true;
                Scope = Repeater;
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
            action(SelectItemSubstitution2)
            {
                AccessByPermission = TableData "Item Substitution" = R;
                ApplicationArea = Suite;
                Caption = 'Item Substitution';
                Image = SelectItemSubstitution;
                Scope = Repeater;
                ToolTip = 'Select another item that has been set up to be sold instead of the original item if it is unavailable.';

                trigger OnAction()
                begin
                    CurrPage.SaveRecord();
                    Rec.ShowItemSub();
                    CurrPage.Update(true);
                    if (Rec.Reserve = Rec.Reserve::Always) and (Rec."No." <> xRec."No.") then begin
                        Rec.AutoReserve();
                        CurrPage.Update(false);
                    end;
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
            action(DocAttach2)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal();
                end;
            }
        }
    }

    var
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";

    trigger OnAfterGetRecord()
    begin
        GetInventory;
        CommentStyle := SetCommentStyle();
    end;

    local procedure GetInventory()
    var
        Item: Record Item;
    begin
        if Rec.Type <> Rec.Type::Item then
            Rec.Instock_SalesLine := 0
        else
            if Item.Get(Rec."No.") and (Item.Type = Item.Type::Inventory) then begin
                Item.CalcFields(Inventory);
                // Rec.Instock_SalesLine := Item.Inventory;
                // Rec.Modify();
                Rec.Validate(Rec.Instock_SalesLine, Item.Inventory);
                Rec.Modify();
                Commit();
            end
            else
                if Item.Get(Rec."No.") and ((Item.Type = Item.Type::"Non-Inventory") or (Item.Type = Item.Type::Service)) then begin
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
        CommentStyle: Text;

    trigger OnOpenPage()
    var
        Order: Record "Sales Header";
    begin
        if Order.Status = Order.Status::Open then
            IsOpenOrder := true;
    end;

    procedure SetCommentStyle(): Text
    begin
        If Rec.Type = Rec.Type::" " then
            exit('Strong');
        exit('');
    end;
}