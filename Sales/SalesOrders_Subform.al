pageextension 50127 SalesOrderFormExt extends "Sales Order Subform"
{
    // Editable = IsOpenOrder;
    layout
    {
        modify("No.")
        {
            StyleExpr = LineStatusStyle;

            trigger OnAfterValidate()
            begin
                GetInventory();
                CheckProfit();
                AssemblyWarning();
            end;
        }
        modify("Substitution Available") { Visible = true; }
        modify(Description) { QuickEntry = true; StyleExpr = CommentStyle; }
        modify(Quantity) { StyleExpr = QuantityStyle; }
        Modify("Qty. to Assign") { QuickEntry = true; }
        Modify("Item Charge Qty. to Handle") { QuickEntry = true; }
        modify("Unit of Measure Code") { StyleExpr = LineStatusStyle; }
        modify("Location Code") { StyleExpr = LineStatusStyle; }
        moveafter(Description; "Unit Price", Quantity, "Unit of Measure Code", "Qty. to Assemble to Order", "Reserved Quantity")
        moveafter("Total Amount Incl. VAT"; "Location Code")
        moveafter("Qty. Assigned"; "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "VAT Bus. Posting Group", "VAT Prod. Posting Group")
        moveafter("Line Discount %"; "Line Discount Amount")
        moveafter("Qty. Assigned"; "Unit Cost (LCY)")
        moveafter("Unit of Measure Code"; WSB_AvailabilityIndicator)
        addafter("Unit of Measure Code")
        {
            field(Instock_SalesLine; rec.Instock_SalesLine)
            {
                Editable = false;
                Caption = 'Qty in Stock';
                ApplicationArea = All;
                Visible = true;
                BlankZero = true;
                Style = StandardAccent;
                Width = 5;
                DecimalPlaces = 0 : 2;

                trigger OnDrillDown()
                var
                    ItemLedgerEntryRec: Record "Item Ledger Entry";
                    ItemLedgerEntryPageID: Integer;
                begin
                    ItemLedgerEntryPageID := Page::"Item Ledger Entries";
                    ItemLedgerEntryRec.SetRange("Item No.", Rec."No.");
                    PAGE.Run(ItemLedgerEntryPageID, ItemLedgerEntryRec);
                end;
            }
        }
        modify("Item Reference No.") { Visible = false; }
        modify("Gen. Prod. Posting Group") { Style = Ambiguous; }
        modify("VAT Prod. Posting Group") { Style = AttentionAccent; }
        modify("Unit Price")
        {
            StyleExpr = LineStatusStyle;

            trigger OnAfterValidate()
            begin
                GetInventory();
                CheckProfit();
            end;
        }
        modify("Line Discount Amount") { Visible = true; StyleExpr = LineStatusStyle; }
        modify("Total Amount Excl. VAT") { StyleExpr = LineStatusStyle; }
        modify("Unit Cost (LCY)") { Visible = true; Style = Ambiguous; Editable = false; BlankZero = true; }
        addafter("Line Amount")
        {
            field("Amount Including VAT"; Rec."Amount Including VAT")
            { ApplicationArea = All; Visible = true; Editable = false; StyleExpr = LineStatusStyle; }
        }
        addafter("Unit Cost (LCY)")
        {
            field("Line Profit"; Rec."Line Amount" - (Rec.Quantity * Rec."Unit Cost (LCY)"))
            { ApplicationArea = all; Editable = false; Caption = 'Line Profit'; StyleExpr = LineStatusStyle; ToolTip = 'The amount of profit, including customer discount but not invoice discount, on this line compared to the displayed cost'; }
        }
        modify("Planned Shipment Date") { QuickEntry = false; }
        modify("Shortcut Dimension 1 Code") { QuickEntry = false; }
        modify("Shortcut Dimension 2 Code") { QuickEntry = false; }
        modify(ShortcutDimCode3) { QuickEntry = false; }
        modify(ShortcutDimCode4) { QuickEntry = false; }
        modify(ShortcutDimCode5) { QuickEntry = false; }
        modify(ShortcutDimCode6) { QuickEntry = false; }
        modify(ShortcutDimCode7) { QuickEntry = false; }
        modify(ShortcutDimCode8) { QuickEntry = false; }
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
        // modify("Total VAT Amount")
        // {

        //     trigger OnDrillDown()
        //     var
        //         SalesHeader: Record "Sales Header";
        //     begin
        //         if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then
        //             Page.Run(Page::"Sales Order Statistics", SalesHeader)
        //         else
        //             Error('The related Sales Header could not be found.');
        //     end;
        // }
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
                Caption = 'Substitution';
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
                Caption = 'BOM Availability';
                Image = BOMLevel;
                ToolTip = 'View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.';

                trigger OnAction()
                begin
                    SalesAvailabilityMgt.ShowItemAvailabilityFromSalesLine(Rec, "Item Availability Type"::BOM);
                end;
            }

            action(DocAttach2)
            {
                ApplicationArea = All;
                Caption = 'Files';
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
        //ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        SalesAvailabilityMgt: Codeunit "Sales Availability Mgt.";
        IsOpenOrder: Boolean;
        CommentStyle: Text;
        LineStatusStyle: Text;
        QuantityStyle: Text;

    trigger OnAfterGetRecord()
    begin
        GetInventory;
        SetStyles()
    end;

    // local procedure GetInventory()
    // var
    //     Item: Record Item;
    //     AvailableBOMQty: Decimal;
    // begin
    //     if Rec.Type <> Rec.Type::Item then
    //         Rec.Instock_SalesLine := 0
    //     else
    //         if Item.Get(Rec."No.") then begin
    //             if Item.Type = Item.Type::Inventory then begin
    //                 Item.CalcFields(Inventory);
    //                 if Item."Replenishment System" = Item."Replenishment System"::Assembly then
    //                     AvailableBOMQty := CalculateAvailableBOMQuantity(Item."No.")
    //                 else
    //                     AvailableBOMQty := 0;
    //                 Rec.Validate(Rec.Instock_SalesLine, Item.Inventory + AvailableBOMQty);
    //             end else if (Item.Type = Item.Type::"Non-Inventory") or (Item.Type = Item.Type::Service) then
    //                     Rec.Validate(Rec.Instock_SalesLine, 999);
    //             Rec.Modify();
    //             Commit();
    //         end;
    // end;

    // local procedure CalculateAvailableBOMQuantity(ItemNo: Code[20]): Decimal
    // var
    //     CalcBOMTree: Codeunit "Calculate BOM Tree";
    //     BOMBuffer: Record "BOM Buffer" temporary;
    //     Item: Record Item;
    //     AvailableQuantity: Decimal;
    // begin
    //     // Initialize the available quantity to a large number
    //     AvailableQuantity := 99999;
    //     // Set the item filter
    //     Item.SetRange("No.", ItemNo);
    //     // Generate the BOM tree for the item
    //     CalcBOMTree.GenerateTreeForItems(Item, BOMBuffer, 1);
    //     // Loop through the BOM buffer to calculate the available quantity
    //     if BOMBuffer.FindSet() then
    //         repeat
    //             // Calculate the available quantity based on the stock levels of the components
    //             if BOMBuffer."Able to Make Parent" < AvailableQuantity then
    //                 AvailableQuantity := BOMBuffer."Able to Make Parent";
    //         until BOMBuffer.Next() = 0;
    //     if AvailableQuantity = 99999 then
    //         exit(0)
    //     else
    //         exit(AvailableQuantity);
    // end;

    local procedure GetInventory()
    var
        Item: Record Item;
    begin
        if Rec.Type <> Rec.Type::Item then
            Rec.Instock_SalesLine := 0
        else
            if Item.Get(Rec."No.") and (Item.Type = Item.Type::Inventory) then begin
                Item.CalcFields(Inventory);
                Rec.Validate(Rec.Instock_SalesLine, Item.Inventory);
                Rec.Modify();
                Commit();
            end
            else
                if Item.Get(Rec."No.") and ((Item.Type = Item.Type::"Non-Inventory") or (Item.Type = Item.Type::Service)) then begin
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

    trigger OnOpenPage()
    var
        Order: Record "Sales Header";
    begin
        if Order.Status = Order.Status::Open then
            IsOpenOrder := true;
    end;

    procedure SetStyles()
    begin
        CommentStyle := SetCommentStyle();
        LineStatusStyle := SetLineStatusStyle();
        QuantityStyle := SetQuantityStyle();
    end;

    procedure SetCommentStyle(): Text
    begin
        If Rec.Type = Rec.Type::" " then
            exit('Strong')
        else if Rec."Qty. to Ship" = 0 then
            exit('Subordinate')
        else
            exit('');
    end;

    procedure SetLineStatusStyle(): Text
    begin
        If Rec."Qty. to Ship" = 0 then exit('Subordinate') else exit('');
    end;

    procedure SetQuantityStyle(): Text
    begin
        If Rec."Qty. to Ship" = 0 then exit('Subordinate') else exit('Strong');
    end;
}