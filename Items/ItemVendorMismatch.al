// Page to show items where Item."Vendor No." and Item."Vendor Item No." 
// do not match any record in the Item Vendor table.
// This helps identify items that need vendor catalog updates.

page 50170 "Item Vendor Mismatch"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = Item;
    Caption = 'Items with Vendor Catalog Mismatches';
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            group(Filters)
            {
                ShowCaption = false;
                field(ShowMismatchesOnly; ShowMismatchesOnly)
                {
                    Caption = 'Show Mismatches Only';
                    ApplicationArea = All;
                    ToolTip = 'When enabled, hides items with "OK" status (those that match the Item Vendor catalog)';

                    trigger OnValidate()
                    begin
                        ApplyMismatchFilter();
                    end;
                }
            }
            repeater(Items)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Item number';

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Item Card", Rec);
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Item description';
                    Width = 50;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Default vendor number for this item';
                }
                field("Vendor Item No."; Rec."Vendor Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Vendor item number';
                }
                field(CatalogVendorNo; CatalogVendorNo)
                {
                    Caption = 'Catalog Vendor No.';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Vendor number from the Item Vendor Catalog';
                }
                field(CatalogVendorItemNo; CatalogVendorItemNo)
                {
                    Caption = 'Catalog Vendor Item No.';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Vendor item number from the Item Vendor Catalog';
                }
                field(VendorMatchExists; VendorMatchExists)
                {
                    Caption = 'Vendor Catalog Match Exists';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Indicates whether this item vendor combination exists in the Item Vendor table';
                }
                field(MatchStatus; MatchStatus)
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = (not VendorMatchExists) and (Rec."Vendor No." <> '');
                    ToolTip = 'Shows if the vendor information is properly recorded in the Item Vendor table';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(OpenVendorCatalog)
            {
                ApplicationArea = All;
                Caption = 'Item Vendor Catalog';
                Image = Vendor;
                RunObject = page "Item Vendor Catalog";
                RunPageLink = "Item No." = field("No.");
                ToolTip = 'View and manage vendor information for this item';
                Scope = Repeater;
            }
            action(OpenItemCard)
            {
                ApplicationArea = All;
                Caption = 'Item Card';
                Image = Item;
                RunObject = page "Item Card";
                RunPageLink = "No." = field("No.");
                ToolTip = 'Open the item card';
                Scope = Repeater;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CheckVendorMatch();
    end;

    trigger OnOpenPage()
    begin
        // Filter to show only items with a vendor number
        Rec.SetFilter("Vendor No.", '<>%1', '');

        // Default toggle to show mismatches only
        ShowMismatchesOnly := true;
        ApplyMismatchFilter();
    end;

    local procedure ApplyMismatchFilter()
    begin
        Rec.ClearMarks();

        if ShowMismatchesOnly then begin
            // Mark only items with mismatches
            Rec.Reset();
            Rec.SetFilter("Vendor No.", '<>%1', '');
            if Rec.FindSet() then begin
                repeat
                    CheckVendorMatch();
                    if MatchStatus <> 'OK' then
                        Rec.Mark(true);
                until Rec.Next() = 0;
            end;
            Rec.MarkedOnly(true);
        end else begin
            // Show all items with vendor numbers
            Rec.Reset();
            Rec.SetFilter("Vendor No.", '<>%1', '');
            Rec.MarkedOnly(false);
        end;
    end;

    local procedure CheckVendorMatch()
    var
        ItemVendor: Record "Item Vendor";
    begin
        VendorMatchExists := false;
        CatalogVendorNo := '';
        CatalogVendorItemNo := '';

        // Check if vendor combination exists in Item Vendor table
        if (Rec."Vendor No." <> '') then begin
            ItemVendor.SetRange("Item No.", Rec."No.");
            ItemVendor.SetRange("Vendor No.", Rec."Vendor No.");

            // If Vendor Item No. is specified, check for match (case-insensitive and trim spaces)
            if Rec."Vendor Item No." <> '' then begin
                // Find with vendor number first, then check Vendor Item No. case-insensitively with trimmed spaces
                if ItemVendor.FindFirst() then begin
                    CatalogVendorNo := ItemVendor."Vendor No.";
                    CatalogVendorItemNo := ItemVendor."Vendor Item No.";
                    VendorMatchExists := UpperCase(DelChr(ItemVendor."Vendor Item No.", '<>', ' ')) = UpperCase(DelChr(Rec."Vendor Item No.", '<>', ' '));
                end;
            end else begin
                if ItemVendor.FindFirst() then begin
                    CatalogVendorNo := ItemVendor."Vendor No.";
                    CatalogVendorItemNo := ItemVendor."Vendor Item No.";
                    VendorMatchExists := true;
                end;
            end;
        end;

        // Set status message
        if VendorMatchExists then begin
            MatchStatus := 'OK';
        end else if (Rec."Vendor No." <> '') or (Rec."Vendor Item No." <> '') then begin
            MatchStatus := 'MISMATCH - Needs Update';
        end else begin
            MatchStatus := 'No Vendor Info';
        end;
    end;

    var
        VendorMatchExists: Boolean;
        MatchStatus: Text[50];
        ShowMismatchesOnly: Boolean;
        CatalogVendorNo: Code[20];
        CatalogVendorItemNo: Code[50];
}
