// The extension is called "ItemCardExt" and is based on the "Item Card" page (pageextension 50100).
// The layout section of the code modifies various fields on the page, adding tooltips, making some fields mandatory, and adding new fields to the page.
// The actions section of the code adds two new actions to the page, one for creating a new sales order and one for viewing the list of vendors who can supply the item.
// Some of the modifications made to the page include:
// Showing the "Shelf No." and "Search Description" fields as mandatory
// Adding a new field for "Model"
// Adding a new field for "Supplier"
// Adding a new field for "NonStockShelf" under a new group "NonStockGroup"
// Adding a new user control for the "Item Notes" field
// Moving some fields around on the page, such as "Tariff No." and "Unit Price"
// Changing the caption of the "BOM Level" field to "BOM Availability"
// Making some fields more prominent by setting their Importance property to "Promoted"
// The code also contains a trigger for the "No." field, which runs after validation and checks if the "Description" field is blank. If it is, the trigger sets the values of the "Reordering Policy" and "Automatic Ext. Texts" fields to default values.
pageextension 50100 ItemCardExt extends "Item Card"
{
    layout
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                if rec.Description = '' then begin
                    Rec.Validate(Rec."Reordering Policy", Rec."Reordering Policy"::"Fixed Reorder Qty.");
                    Rec.Validate(Rec."Automatic Ext. Texts", true);
                end;
            end;
        }
        modify("Item Category Code")
        { ShowMandatory = true; }
        addafter("Item Category Code")
        {
            // field("Description 2"; Rec."Description 2")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Quantity info';
            //     //CaptionML = ENG = 'Quantity info';
            //     Tooltip = 'Useful information like length per car or similar that will show on order lines but not invoices';
            //     Visible = true;
            //     QuickEntry = false;
            // }
            field("Model"; Rec."Model")
            {
                ApplicationArea = All;
                Caption = 'Car Make/Model';
                ToolTip = 'Known/intended application by model. For more specifics consider the Notes field';
                ShowMandatory = true;
            }
            field("Supplier"; Rec."Supplier")
            {
                ApplicationArea = All;
                Caption = 'Old Supplier Ref';
                ToolTip = 'Brief summary of main supplier and/or part number. No longed editable. Use the Vendor Catalogue to record suppliers, their part numbers and lead times, and use the Vendor No. and Vendor Item No. below to define the default vendor used for purchasing.';
                Editable = false;
            }
            group("NonStockGroup")
            {
                visible = NonStockShelfVisible;
                ShowCaption = false;

                field("NonStockShelf"; Rec.NonStockShelf)
                {
                    ApplicationArea = All;
                    Caption = 'Shelf No.';
                    ToolTip = 'Only to be used when the Shelf No. field is not shown (e.g. on Non-Inventory items). Otherwise leave blank.';
                }
            }
        }
        movelast(Item; "Tariff No.")
        moveafter(Blocked; "Unit Cost", "Unit Price")
        modify("Blocked")
        { Visible = true; }
        modify("Automatic Ext. Texts")
        { Importance = Standard; }
        modify("Shelf No.")
        {
            Importance = Promoted;
            ShowMandatory = true;
        }
        modify("Search Description")
        { Importance = Promoted; }
        modify("Costing Method")
        { Importance = Promoted; }
        modify("VAT Prod. Posting Group")
        { Importance = Standard; }
        modify("Profit %")
        { Importance = Promoted; }
        modify("Sales Unit of Measure")
        {
            Importance = Promoted;
            ShowMandatory = true;
        }
        modify("Vendor No.")
        { Importance = Promoted; }
        modify("Vendor Item No.")
        { Importance = Promoted; }
        modify("Purch. Unit of Measure")
        {
            Importance = Promoted;
            ShowMandatory = true;
        }
        modify("Tariff No.")
        { ShowMandatory = true; }
        modify("Reordering Policy")
        { ShowMandatory = true; }
        modify("Reorder Point")
        { ShowMandatory = true; }
        modify("Reorder Quantity")
        { ShowMandatory = true; }
        modify("Lead Time Calculation")
        { ShowMandatory = true; }
        addlast(Item) //! User Control for the large notes field...
        {
            // field("Item Notes"; Rec."Item Notes")
            // {
            //     MultiLine = true;
            //     ApplicationArea = All;
            //     AssistEdit = true;
            //     trigger OnAssistEdit()
            //     begin
            //         Message(Rec."Item Notes")
            //     end;
            // }
            usercontrol(UserControlDesc; "Microsoft.Dynamics.Nav.Client.WebPageViewer")
            {
                ApplicationArea = All;
                trigger ControlAddInReady(callbackUrl: Text)
                begin
                    IsReady := true;
                    FillAddIn();
                end;

                trigger Callback(data: Text)
                begin
                    Rec."Item Notes" := data;
                    Caption := 'Item Notes';
                end;
            }
        }
    }
    actions
    {
        addlast(Sales)
        {
            action(NewSalesOrder)
            {
                AccessByPermission = TableData "Sales Header" = RIM;
                ApplicationArea = Basic, Suite;
                Caption = 'Create New Sales Order';
                Image = Order;
                RunObject = Page "Sales Order";
                RunPageMode = Create;
                ToolTip = 'Create a sales order (but you''ll have to add the item manually after choosing the customer).';
            }
        }
        addlast(Purchases)
        {
            action(ItemsFromVendors)
            {
                ApplicationArea = Planning;
                Caption = 'Vendor List';
                Image = Vendor;
                RunObject = Page "Item Vendor Catalog";
                RunPageLink = "Item No." = FIELD("No.");
                RunPageView = SORTING("Item No.");
                ToolTip = 'View the list of vendors who can supply the item, and at which lead time.';
            }
        }
        modify("BOM Level")
        {
            CaptionML = ENG = 'BOM Availability';
        }
        addlast(Category_Process)
        {
            actionref(ItemJournal_Omicron; "Item Journal")
            { }
            actionref(ItemLedger; "Ledger E&ntries")
            { }
            actionref(Substitutions; "Substituti&ons")
            { }
            actionref(ExtendedTexts; "E&xtended Texts")
            { }
            actionref(VendorCatalogue; ItemsFromVendors)
            { }
            actionref(BOMAvailability; "BOM Level")
            { }
            actionref(WhereUsed; "Where-Used")
            { }
            actionref(NewSalesOrder_Promoted; NewSalesOrder)
            { }
        }
        modify(AdjustInventory_Promoted)
        { Visible = false; }
        modify(AdjustInventory)
        { Visible = false; }
        modify("&Create Stockkeeping Unit_Promoted")
        { Visible = false; }
        modify(ApplyTemplate_Promoted)
        { Visible = false; }
    }
    trigger OnOpenPage();
    begin
        InitializeVariables;
    end;

    var
        //[InDataSet]
        NonStockShelfVisible: Boolean;

    local procedure InitializeVariables()
    begin
        case rec.Type of
            Rec.Type::Inventory:
                SetFieldsVisible(false);
            Rec.Type::Service:
                SetFieldsVisible(false);
            Rec.Type::"Non-Inventory":
                SetFieldsVisible(true);
        end;
    end;

    local procedure SetFieldsVisible(NewNonStockShelfVisible: Boolean)
    begin
        NonStockShelfVisible := NewNonStockShelfVisible;
    end;

    var  //!To do with large notes field...
        IsReady: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        if IsReady then
            FillAddIn();
    end;

    local procedure FillAddIn()
    begin
        CurrPage.UserControlDesc.SetContent(StrSubstNo('<textarea Id="TextArea" maxlength="%2" style="width:100%;height:100%;resize: none; font-family: &quot;Segoe UI&quot;, &quot;Segoe WP&quot;, Segoe, device-segoe, Tahoma, Helvetica, Arial, sans-serif !important; font-size: 11pt !important;" OnChange="window.parent.WebPageViewerHelper.TriggerCallback(document.getElementById(''TextArea'').value)">%1</textarea>', Rec."Item Notes", MaxStrLen(Rec."Item Notes")));
    end; //! end of large notes field code...
}