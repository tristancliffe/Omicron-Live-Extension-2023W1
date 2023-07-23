// The extension adds a new field, "Shelf No.1", and a new hidden field, "Stockout Warning", after the "Inventory" field.
// It adds a new field, "Item Category Code1", after the "Description" field.
// It modifies the "Type" field by setting its style to "BlockedStyle".
// It adds three new fields, "Model", "Supplier", and "Item Notes", after the "Vendor No." field.
// It modifies the layout of the page by making the "No." field read-only and hiding some fields, such as "Unit Cost" and "Cost is Adjusted".
// It also adds a new group called "General" with a field called "ApplyFilters", which is used for filtering records based on a search term. This group is positioned before the "Control1" group.
// The extension modifies the actions of the original page by removing the "Adjust Inventory" action and making the "Item Journal" action visible.
// It adds five new views to the original page: "Active Items", "Inactive Items", "Assemblies", "In Stock", "Non-Inventory", and "Services". These views have predefined filters to show only certain types of items.
// The extension includes two triggers, "OnAfterGetRecord" and "OnAfterGetCurrRecord", that call a procedure called "SetBlockedStyle". This procedure sets the style of certain fields based on the values of other fields in the record.
pageextension 50101 ItemListExtension extends "Item List"
{
    editable = true;

    layout
    {
        modify("No.")
        { StyleExpr = BlockedStyleNo; }
        modify(Description)
        { StyleExpr = BlockedStyle; }
        modify(Control1)
        { Editable = false; FreezeColumn = Description; }
        modify("Unit Cost")
        { Visible = false; }
        modify("Unit Price")
        { Style = Strong; }
        addbefore(Control1)
        {
            group(General)
            {
                // Caption = 'General';
                ShowCaption = false;
                field(ApplyFilters; ApplyFilters)
                {
                    Caption = 'Omicron SuperSearch: Type in your search term here - partial or complete words in any order and press Return';
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        Rec.MARKEDONLY(FALSE);
                        IF ApplyFilters <> '' THEN begin
                            OldApplyFilters := ApplyFilters;
                            ApplyFilters := '@*' + ApplyFilters + '*';
                        end;
                        ApplyFilters := FilterOnAfterValidate(ApplyFilters, ' ', '*&@*');
                        Rec.CLEARMARKS;

                        Rec.SETFILTER(Search_Column, ApplyFilters);
                        IF Rec.FIND('-') THEN
                            REPEAT
                                Rec.MARK(TRUE);
                            UNTIL Rec.NEXT = 0;
                        Rec.SETRANGE(Search_Column);
                        Rec.SETRANGE(Search_Column);
                        Rec.MARKEDONLY(TRUE);
                        IF ApplyFilters = '' THEN Rec.MARKEDONLY(FALSE);
                        ApplyFilters := OldApplyFilters;
                        Clear(OldApplyFilters);
                        CurrPage.UPDATE(FALSE);
                    end;
                }
            }
        }
        modify("Cost is Adjusted")
        { Visible = false; }
        modify("Reverse Charge Applies")
        { Visible = false; }
        modify("Default Deferral Template Code")
        { Visible = false; }
        addafter(InventoryField)
        {
            field("Shelf No.1"; Rec."Shelf No.")
            {
                ApplicationArea = All;
                ToolTip = 'The shelf location in the stores';
                Style = Strong;
            }
            field("Stockout Warning"; Rec."Stockout Warning")
            { ApplicationArea = All; Visible = false; }
        }
        addafter(Description)
        {
            field("Item Category Code1"; Rec."Item Category Code")
            {
                ApplicationArea = All;
                StyleExpr = BlockedStyle;
                ToolTip = 'The Item Category Code field, called the SORTKEY or SHORTNAME in Access Dimensions.';
            }
        }
        modify(Type)
        { StyleExpr = BlockedStyle; }
        addafter("Vendor No.")
        {
            field(Model; Rec.Model)
            { ApplicationArea = All; ToolTip = 'Vehicle model and detaisl. Use the Notes field for more information like chassis numbers et cetera.'; }
            field(Supplier; Rec.Supplier)
            { ApplicationArea = All; ToolTip = 'Short supplier notes. Ideally use the vendors functionality to record suppiers, prices and leadtimes.'; }
            field("Item Notes"; Rec."Item Notes")
            { ApplicationArea = All; ToolTip = 'Item notes.'; }
        }
    }
    actions
    {
        addfirst(Category_Category4)
        {
            actionref(ItemJournal_promoted; "Item Journal")
            { }
            actionref("E&xtended Texts_Promoted1"; "E&xtended Texts")
            { }
            actionref("Ven&dors_Promoted64734"; "Ven&dors")
            { }
        }
        addlast(Promoted)
        {
            actionref(Action37_Promoted1; Action37)
            { }
            actionref(Action40_Promoted1; Action40)
            { }
        }
        modify(AdjustInventory)
        { Visible = false; }
        modify("Item Journal")
        { Visible = true; }
    }
    views
    {
        addfirst
        {
            view(ActiveItems)
            {
                Caption = 'Active Items';
                Filters = where("Blocked" = const(false));
            }
            view(InactiveItems)
            {
                Caption = 'Inactive Items';
                Filters = where("Blocked" = const(true));
            }
            view(Assemblies)
            {
                Caption = 'Assemblies';
                Filters = where("Assembly BOM" = const(true));
                OrderBy = ascending("No.");
            }
            view(Instock)
            {
                Caption = 'In Stock';
                Filters = where("Inventory" = filter('>0'));
            }
            view(NonInventory)
            {
                Caption = 'Non-Inventory';
                Filters = where(Type = const("Non-Inventory"));
            }
            view(Services)
            {
                Caption = 'Services';
                Filters = where(Type = const(Service));
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetBlockedStyle();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetBlockedStyle();
    end;

    procedure SetBlockedStyle()
    begin
        if Rec.Blocked = false then begin
            BlockedStyle := 'Standard';
            BlockedStyleNo := 'StandardAccent';
        end else
            if Rec.Blocked = true then begin
                BlockedStyle := 'Subordinate';
                BlockedStyleNo := 'Subordinate';
            end else
                if Rec."Sales Blocked" = true then begin
                    BlockedStyle := 'Ambiguous';
                    BlockedStyleNo := 'Ambiguous';
                end else
                    if Rec."Purchasing Blocked" = true then begin
                        BlockedStyle := 'Ambiguous';
                        BlockedStyleNo := 'Ambiguous';
                    end;
    end;

    var
        BlockedStyle: Text;
        BlockedStyleNo: Text;

    // trigger OnOpenPage()
    // begin
    //     Rec.SetCurrentKey("No.");
    //     Rec.Ascending(true);
    //     Rec.SetFilter("Blocked", 'No');
    //     // Rec.SetView(StrSubstNo('sorting ("No.") order(ascending) where ("Blocked" = filter (No))'));
    // end;

    local procedure FilterOnAfterValidate(String: Text; FindWhat: Text; ReplaceWith: Text) NewString: Text
    begin
        Rec.RESET;
        IF String <> '' THEN BEGIN
            FindPos := STRPOS(String, FindWhat);
            WHILE FindPos > 0 DO BEGIN
                NewString += DELSTR(String, FindPos) + ReplaceWith;
                String := COPYSTR(String, FindPos + STRLEN(FindWhat));
                FindPos := STRPOS(String, FindWhat);
            END;
            NewString += String;
        END ELSE
            NewString := '';
    end;

    Var
        ApplyFilters: Text;
        OldApplyFilters: Text;
        FindPos: Integer;
}