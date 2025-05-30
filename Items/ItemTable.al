// The extension extends the base "Item" table with additional fields and triggers.
// The fields include "Model," "Item Notes," "Supplier," "NonStockShelf," "Search_Column," and "NeedsReorder."
// The triggers include "OnAfterModify," "OnModify," and "OnBeforeDelete."
// The "OnAfterModify" trigger converts the values of "Model," "Supplier," and "NonStockShelf" to uppercase.
// The "OnModify" trigger sets the value of "Search_Column" by concatenating various fields and strings.
// The "OnBeforeDelete" trigger displays a random warning message to confirm the deletion of the record.
// The code uses the DataClassification property to mark the fields as containing customer content.
tableextension 50100 ItemTableExt extends Item
{
    fields
    {
        field(50100; "Model"; Text[50])
        {
            CaptionML = ENU = 'Vehicle Model';
            DataClassification = CustomerContent;
            ToolTip = 'Known/intended application by model. For more specifics consider the Notes field';
            //OptimizeForTextSearch = true;
        }
        field(50101; "Item Notes"; Text[1000])
        {
            CaptionML = ENU = 'Item Notes';
            DataClassification = CustomerContent;
            ToolTip = 'Item notes...';
            //OptimizeForTextSearch = true;
        }
        field(50102; "Supplier"; Text[50])
        {
            CaptionML = ENU = 'Supplier';
            DataClassification = CustomerContent;
            ToolTip = 'Brief summary of main supplier and/or part number. No longed editable. Use the Vendor Catalogue to record suppliers, their part numbers and lead times, and use the Vendor No. and Vendor Item No. below to define the default vendor used for purchasing.';
            //OptimizeForTextSearch = true;
        }

        field(50103; "NonStockShelf"; Text[20])
        {
            CaptionML = ENU = 'Non-Inventory Shelf';
            DataClassification = CustomerContent;
            ToolTip = 'Only to be used when the Shelf No. field is not shown (e.g. on Non-Inventory items). Otherwise leave blank.';
        }
        field(50399; Search_Column; Text[2000])
        {
            CaptionML = ENU = 'Search field';
            DataClassification = CustomerContent;
        }
        field(50104; NumberOfAttachments; Integer)
        {
            Caption = 'Files';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Document Attachment" where("Table ID" = const(27),
                                                            "No." = field("No.")));
            ToolTip = 'Number of attachments to this record. These can simply exist, or be transferred to sales/purchase documents for processing/printing/emails with orders.';
        }
        field(50105; OnShopify; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Shpfy Variant" where("Item No." = field("No.")));
            ToolTip = 'True if this is listed on Shopify';
            Caption = 'On Shopify';
        }
        field(50106; QtySold; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Sales Invoice Line".Quantity where(Type = filter('Item'), "No." = field("No.")));
            Caption = 'Qty. Sold';
            ToolTip = 'Sum of quantity of this part number appearing on posted sales invoice lines.';
        }
    }
    fieldgroups
    {
        addlast(DropDown; "Item Category Code", Inventory, "Shelf No.", "Assembly BOM", "Vendor Item No.", Supplier) { }
    }
    trigger OnAfterModify()
    begin
        Validate(Model, UpperCase(Model));
        Validate(Supplier, UpperCase(Supplier));
        Validate(NonStockShelf, UpperCase(NonStockShelf));
    end;

    trigger OnModify()
    begin
        Search_Column := "No." + ' ' + Description + ' ' + "Search Description" + ' ' + "Item Category Code" + ' ' + Model + ' ' + Supplier + ' ' + Rec."Vendor No." + ' ' + Rec."Vendor Item No." + ' ' + Rec."Item Notes";
    end;

    trigger OnBeforeDelete()
    var
        messages: List of [Text];
        index: Integer;
    begin
        messages.Add('Deleting this record will erase it from existence like Thanos snapped his fingers. Are you sure you want to do this?');
        messages.Add('By deleting this record, you''ll be sending it on a one-way trip to the Phantom Zone. Are you sure you want to do that?');
        messages.Add('Deleting this record is like crossing the streams in Ghostbusters. It''s technically possible, but is it really a good idea?');
        messages.Add('If you delete this record, it will be gone forever, like a redshirt on an away mission. Are you sure you want to risk it?');
        messages.Add('Deleting this record is like navigating an asteroid field without a calculator. Are you feeling lucky?');
        messages.Add('By deleting this record, you''ll be unleashing a horde of Daleks. Are you sure you want to take that risk?');
        messages.Add('If you delete this record, you''ll be creating a temporal paradox that could unravel the fabric of spacetime. Are you sure you want to do that?');
        messages.Add('Deleting this record is like using a lightsaber to open a jar of pickles. It''s probably not the best idea.');
        messages.Add('By deleting this record, you''ll be crossing the event horizon of a black hole. Are you sure you want to take that leap?');
        messages.Add('If you delete this record, you''ll be triggering a self-destruct sequence that could destroy the entire universe. Are you absolutely sure?');
        messages.Add('Deleting this record is like asking the question "what could go wrong?" right before everything goes wrong. Are you sure you want to do this?');
        messages.Add('If you delete this record, it''ll be like Marty McFly fading away in Back to the Future. Are you sure you want to alter the timeline?');
        messages.Add('If you delete this record, you''ll be taking the One Ring to Mordor. Are you sure you''re up to the task?');
        messages.Add('Deleting this record is like putting a fork in a toaster. Are you sure you want to take that risk?');
        messages.Add('By deleting this record, you''ll be releasing the Kraken. Are you ready to face the consequences?');
        messages.Add('If you delete this record, you''ll be playing Russian roulette with a fully loaded gun. Are you sure you want to take that risk?');
        messages.Add('By deleting this record, you''ll be opening the Ark of the Covenant. Do you really want to face the wrath of God?');
        messages.Add('Deleting this record is like trying to swim across the English Channel with lead weights tied to your ankles. It''s probably not going to end well. Still sure?');
        messages.Add('If you delete this record, you''ll be taking a swim in the shark tank. Are you sure you''re ready for that?');
        messages.Add('Deleting this record is like trying to put out a fire with gasoline. It''s probably not the best idea, but if you''re sure...?');
        messages.Add('By deleting this record, you''ll be jumping out of an airplane without a parachute. Are you sure you want to take that leap?');
        messages.Add('If you delete this record, you''ll be walking into Mordor. One does not simply do that. Are you sure you''re up for it?');
        messages.Add('Deleting this record is like jumping into a pool full of sharks. Are you sure you want to take that risk?');
        messages.Add('By deleting this record, you''re entering a realm of chaos and madness. Are you sure you want to go down that rabbit hole?');
        messages.Add('Deleting this record is like playing a game of Minesweeper. Only instead of mines, you''re dealing with the fate of your data.');
        index := Random(messages.Count());

        if (not Confirm(messages.Get(index))) then begin
            ERROR('Deletion cancelled by user');
            exit;
        end;
    end;
}