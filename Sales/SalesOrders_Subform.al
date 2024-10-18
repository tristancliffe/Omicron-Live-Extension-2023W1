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
            }
            // field(AvailabletoMake; AvailableToMake)
            // { ApplicationArea = All; DecimalPlaces = 0 : 2; }
        }
        modify("Item Reference No.")
        { Visible = false; }
        moveafter("Qty. Assigned"; "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "VAT Bus. Posting Group", "VAT Prod. Posting Group")
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
        moveafter("Line Discount %"; "Line Discount Amount")
        modify("Line Discount Amount") { Visible = true; StyleExpr = LineStatusStyle; }
        modify("Total Amount Excl. VAT") { StyleExpr = LineStatusStyle; }

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
            { ApplicationArea = All; Visible = true; Editable = false; StyleExpr = LineStatusStyle; }
        }
        addafter("Unit Cost (LCY)")
        {
            field("Line Profit"; Rec."Line Amount" - (Rec.Quantity * Rec."Unit Cost (LCY)"))
            { ApplicationArea = all; Editable = false; Caption = 'Line Profit'; StyleExpr = LineStatusStyle; ToolTip = 'The amount of profit, including customer discount but not invoice discount, on this line compared to the displayed cost'; }
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
                    //ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByBOM())
                    SalesAvailabilityMgt.ShowItemAvailabilityFromSalesLine(Rec, "Item Availability Type"::BOM);
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
        //ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        SalesAvailabilityMgt: Codeunit "Sales Availability Mgt.";
        IsOpenOrder: Boolean;
        CommentStyle: Text;
        LineStatusStyle: Text;
        QuantityStyle: Text;
        Item: Record Item;
        AvailableToMake: Decimal;

    trigger OnAfterGetRecord()
    begin
        GetInventory;
        CommentStyle := SetCommentStyle();
        LineStatusStyle := SetLineStatusStyle();
        QuantityStyle := SetQuantityStyle();
        //CalcBOM();
    end;

    // local procedure CalcBOM()
    // var
    //     CalcBOMTree: Codeunit "Calculate BOM Tree";
    //     BOMBuffer: Record "BOM Buffer" temporary;
    //     IsHandled: Boolean;
    //     Item: Record Item;
    //     ShowTotalAvailability: Boolean;
    //     ShowBy: Enum "BOM Structure Show By";
    //     ProdOrderLine: Record "Prod. Order Line";
    //     AsmHeader: Record "Assembly Header";
    //     IsCalculated: Boolean;
    //     Text000: Label 'Could not find items with BOM levels.';
    //     Text001: Label 'There are no warnings.';
    // begin
    //     Item.SetRange("Date Filter", 0D, Today);
    //     Item.SetFilter("Location Filter", 'STORES');
    //     Item.SetFilter("No.", Rec."No.");
    //     CalcBOMTree.SetItemFilter(Item);

    //     CalcBOMTree.SetShowTotalAvailability(true);
    //     case ShowBy of
    //         ShowBy::Item:
    //             begin
    //                 Item.FindFirst();
    //                 IsHandled := false;
    //                 OnRefreshPageOnBeforeCheckItemHasBOM(Item, IsHandled);
    //                 if not IsHandled then
    //                     if not Item.HasBOM() then
    //                         exit;
    //                 CalcBOMTree.GenerateTreeForItems(Item, BOMBuffer, 1);
    //             end;
    //         ShowBy::Production:
    //             begin
    //                 ProdOrderLine."Due Date" := Today;
    //                 CalcBOMTree.GenerateTreeForProdLine(ProdOrderLine, BOMBuffer, 1);
    //             end;
    //         ShowBy::Assembly:
    //             begin
    //                 AsmHeader."Due Date" := Today;
    //                 CalcBOMTree.GenerateTreeForAsm(AsmHeader, BOMBuffer, 1);
    //             end;
    //     end;
    //     IsCalculated := true;
    //     message('%1 - %2 - %3 - %4 - %5', Rec."No.", BOMBuffer."No.", BOMBuffer."Able to Make Top Item", BOMBuffer."Replenishment System", BOMBuffer."Able to Make Parent");
    //     AvailableToMake := BOMBuffer."Able to Make Top Item";
    // end;

    // [IntegrationEvent(false, false)]
    // local procedure OnRefreshPageOnBeforeCheckItemHasBOM(var Item: Record Item; var IsHandled: Boolean)
    // begin
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