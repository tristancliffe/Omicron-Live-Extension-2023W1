pageextension 50174 SalesCreditMemoExt extends "Sales Credit Memo"
{
    layout
    {
        moveafter("Sell-to Customer Name"; "Your Reference", Status, Correction)
        moveafter("Sell-to Contact"; "External Document No.")
        modify("Sell-to Customer No.")
        { Importance = Standard; }
        modify("Sell-to Address")
        { Importance = Standard; QuickEntry = false; }
        modify("Sell-to Address 2")
        { Importance = Standard; QuickEntry = false; }
        modify("Sell-to City")
        { Importance = Standard; QuickEntry = false; }
        modify("Sell-to County")
        { Importance = Standard; QuickEntry = false; }
        modify("Sell-to Post Code")
        { Importance = Standard; QuickEntry = false; }
        modify("Sell-to Country/Region Code")
        { Importance = Standard; QuickEntry = false; }
        modify("Your Reference")
        { Importance = Standard; QuickEntry = true; ShowMandatory = true; }
        modify(WorkDescription)
        { Importance = Additional; Visible = true; }
        modify("External Document No.")
        { Importance = Standard; Visible = true; }
        modify("Document Date")
        { Visible = true; Importance = Standard; }
        modify("Due Date")
        { Visible = true; Importance = Standard; }
        modify("Posting Date")
        { Visible = true; Importance = Standard; }
        modify("VAT Reporting Date")
        { Visible = true; Importance = Standard; }
        modify("Shipment Date")
        { Importance = Standard; }
        modify("Assigned User ID")
        { Importance = Standard; QuickEntry = false; }
        moveafter("Sell-to"; Status)
        addafter("Sell-to Country/Region Code")
        {
            field("Sell-to Phone No.2"; Rec."Sell-to Phone No.")
            { ApplicationArea = All; CaptionML = ENU = 'Phone No.'; }
            field("Sell-to E-Mail2"; Rec."Sell-to E-Mail")
            { ApplicationArea = All; CaptionML = ENU = 'E-Mail Address'; }
            field("Mobile No."; Rec."Mobile No.")
            { ApplicationArea = All; CaptionML = ENU = 'Mobile Phone No.'; }
        }
        addafter(Correction)
        {
            field("Order Notes"; Rec."Order Notes")
            {
                ApplicationArea = All;
                QuickEntry = false;
                Importance = Standard;
                ShowMandatory = true;
                MultiLine = true;
            }
        }
    }
    actions
    {
        movefirst(Category_Category6; PostAndSend_Promoted)
        addlast(Category_Process)
        {
            actionref(ItemList_Promoted; ItemList)
            { }
            actionref(CustomerCard; Customer)
            { }
            actionref(Statistics2; Statistics)
            { }
        }
        addlast("F&unctions")
        {
            action(ItemJournal)
            {
                Caption = 'Item Journal';
                Image = ItemRegisters;
                ApplicationArea = All;
                RunObject = Page "Item Journal";
                ShortcutKey = 'Shift+Ctrl+I';
                ToolTip = 'Takes the user to the item journal to add [secondhand] stock';
                Visible = true;
            }
            action(ItemList)
            {
                Caption = 'Item List';
                Image = Item;
                ApplicationArea = All;
                RunObject = Page "Item List";
                ShortcutKey = 'Shift+Ctrl+L';
                ToolTip = 'Takes the user to the item list';
                Visible = true;
            }
        }
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    Rec.Validate(Rec."Posting Date", Today);
                    // Rec.Modify();
                end;
            end;
        }
        modify(PostAndSend)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    Rec.Validate(Rec."Posting Date", Today);
                    // Rec.Modify();
                end;
            end;
        }
    }
    trigger OnInsertRecord(BelowXRec: Boolean): Boolean
    begin
        Rec."Assigned User ID" := USERID;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec.Validate(Rec."Your Reference", UpperCase(Rec."Your Reference"));
    end;
}