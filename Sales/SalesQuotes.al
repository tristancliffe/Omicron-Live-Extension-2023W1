pageextension 50123 QuoteExtension extends "Sales Quote"
{
    layout
    {
        moveafter("Sell-to Customer Name"; "Your Reference")
        moveafter("Sell-to Contact"; "External Document No.")
        addafter("Sell-to")
        {
            field("Order Customer Notes"; Rec."Order Customer Notes")
            {
                MultiLine = true;
                ApplicationArea = All;
                Importance = Standard;
                ToolTip = 'This SHOULD be the customer notes brought across to the orders';
                QuickEntry = false;
                Editable = true;
            }
        }
        modify("Sell-to Customer No.")
        { Importance = Standard; }
        modify("Your Reference")
        {
            Importance = Standard;
            ShowMandatory = true;
            QuickEntry = true;
        }
        modify("Sell-to Address")
        {
            Importance = Standard;
            QuickEntry = false;
        }
        modify("Sell-to Address 2")
        {
            Importance = Standard;
            QuickEntry = false;
        }
        modify("Sell-to City")
        {
            Importance = Standard;
            QuickEntry = false;
        }
        modify("Sell-to County")
        {
            Importance = Standard;
            QuickEntry = false;
        }
        modify("Sell-to Post Code")
        {
            Importance = Standard;
            QuickEntry = false;
        }
        modify("Sell-to Country/Region Code")
        {
            Importance = Standard;
            QuickEntry = false;
        }
        modify(WorkDescription)
        {
            Importance = Standard;
            Visible = false;
        }
        modify("Document Date")
        {
            Visible = true;
            Importance = Standard;
            trigger OnAfterValidate()
            begin
                Rec."Quote Valid Until Date" := Rec."Document Date" + 30;
            end;
        }
        modify("Due Date")
        {
            Visible = true;
            Importance = Standard;
        }
        modify("Ship-to Name")
        { Importance = Promoted; }
        modify("Ship-to Code")
        { Importance = Additional; }
        modify("Ship-to Address")
        { Importance = Promoted; }
        modify("Ship-to Address 2")
        { Importance = Promoted; }
        modify("Ship-to City")
        { Importance = Promoted; }
        modify("Ship-to County")
        { Importance = Promoted; }
        modify("Ship-to Post Code")
        { Importance = Promoted; }
        modify("Shipment Date")
        { Importance = Standard; }
        modify("Assigned User ID")
        {
            Importance = Standard;
            QuickEntry = false;
        }
        addafter("Your Reference")
        {
            field("Order Notes47091"; Rec."Order Notes")
            {
                ApplicationArea = All;
                QuickEntry = false;
                Importance = Standard;
                ShowMandatory = true;
                MultiLine = true;
            }
        }
        addafter("Sell-to Country/Region Code")
        {
            field("Sell-to Phone No.2"; Rec."Sell-to Phone No.")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Phone No.';
            }
            field("Sell-to E-Mail2"; Rec."Sell-to E-Mail")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'E-Mail Address';
            }
            field("Mobile No."; Rec."Mobile No.")
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Mobile Phone No.';
            }
        }
        modify("Quote Valid Until Date")
        {
            Visible = true;
            Importance = Standard;
        }
        modify(Control72)
        { Visible = true; }
        movebefore("Attached Documents"; Control1906127307)
    }
    actions
    {
        addlast("F&unctions")
        {
            action(ItemJournal)
            {
                Caption = 'Item Journal';
                Image = ItemRegisters;
                ApplicationArea = All;
                RunObject = Page "Item Journal";
                ShortcutKey = 'Shift+Ctrl+J';
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
        moveafter("Archive Document_Promoted"; GetRecurringSalesLines_Promoted)
        addlast(Category_Process)
        {
            actionref(ItemJournal_Promoted; ItemJournal)
            { }
            actionref(ItemList_Promoted; ItemList)
            { }
            actionref(CustomerCard; Customer)
            { }
        }
    }
    trigger OnInsertRecord(BelowXRec: Boolean): Boolean
    begin
        Rec."Assigned User ID" := USERID;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec."Your Reference" := UpperCase(Rec."Your Reference");
    end;

    trigger OnOpenPage()
    var
        RecCustomer: Record Customer;

    begin
        RecCustomer.SetRange("No.", Rec."Sell-to Customer No.");
        if RecCustomer.FindSet() then begin
            Rec."Order Customer Notes" := RecCustomer."Customer Notes";
            //rec.modify()
        end;
        Rec."Mobile No." := RecCustomer."Mobile Phone No.";
    end;
}