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
        { Importance = Additional; Visible = true; QuickEntry = false; }
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
            field("Sell-to Phone No."; Rec."Sell-to Phone No.") { ApplicationArea = All; Importance = Standard; }
            field("Mobile No."; Rec."Mobile No.") { ApplicationArea = All; Importance = Standard; }
            field("Sell-to E-Mail"; Rec."Sell-to E-Mail") { ApplicationArea = All; Importance = Standard; }
        }
        addafter("Sell-to")
        {
            field(CustomerCar; RecCustomer."Vehicle Model")
            {
                Caption = 'Customer Car';
                ApplicationArea = All;
                Editable = false;
                Importance = Standard;
            }
            field("Order Customer Notes"; CustomerNotes)
            {
                MultiLine = true;
                Caption = 'Customer Notes';
                ApplicationArea = All;
                Importance = Standard;
                ToolTip = 'This SHOULD be the customer notes brought across to the orders';
                QuickEntry = false;
                Editable = true;
                trigger OnAssistEdit()
                begin
                    message(Rec."Order Customer Notes");
                end;

                trigger OnValidate()
                begin
                    RecCustomer."Customer Notes" := CustomerNotes;
                    RecCustomer.Modify()
                end;
            }
            field("Customer CC Notes"; CustomerCCNotes)
            {
                MultiLine = true;
                Caption = 'CC Notes';
                ShowCaption = false;
                InstructionalText = 'CC Info';
                ApplicationArea = All;
                Importance = Standard;
                ToolTip = 'This SHOULD be the CC notes brought across to the orders';
                QuickEntry = false;
                Editable = true;
                trigger OnAssistEdit()
                begin
                    message(Rec."Customer CC Notes");
                end;

                trigger OnValidate()
                begin
                    RecCustomer."Customer CC Notes" := CustomerCCNotes;
                    RecCustomer.Modify()
                end;
            }
        }
        modify("Foreign Trade")
        { Visible = false; }
    }
    actions
    {
        movefirst(Category_Category6; PostAndSend_Promoted)
        addlast(Category_Process)
        {
            actionref(ItemList_Promoted; ItemList) { }
            actionref(CustomerCard; Customer) { }
            actionref(Statistics3; SalesStatistics) { Visible = true; }
        }
        modify(SalesStatistics) { Visible = true; }
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
        modify(Release)
        { Enabled = ReleaseControllerStatus; }
        modify(Reopen)
        { Enabled = ReopenControllerStatus; }
    }

    var
        RecCustomer: Record Customer;
        CustomerNotes: Text[2000];
        CustomerCCNotes: Text[150];
        ReleaseControllerStatus: Boolean;
        ReopenControllerStatus: Boolean;
        ShowMapLbl: Label 'Show on Map';

    trigger OnInsertRecord(BelowXRec: Boolean): Boolean
    begin
        Rec."Assigned User ID" := USERID;
        RecCustomer.SetRange("No.", Rec."Sell-to Customer No.");
        if RecCustomer.FindSet() then begin
            CustomerNotes := RecCustomer."Customer Notes";
            CustomerCCNotes := RecCustomer."Customer CC Notes";
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec.Validate(Rec."Your Reference", UpperCase(Rec."Your Reference"));
    end;

    trigger OnOpenPage()
    begin
        InitPageControllers();
        RecCustomer.SetRange("No.", Rec."Sell-to Customer No.");
        if RecCustomer.FindSet() then begin
            CustomerNotes := RecCustomer."Customer Notes";
            CustomerCCNotes := RecCustomer."Customer CC Notes";
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        InitPageControllers();
        RecCustomer.SetRange("No.", Rec."Sell-to Customer No.");
        if RecCustomer.FindSet() then begin
            CustomerNotes := RecCustomer."Customer Notes";
            CustomerCCNotes := RecCustomer."Customer CC Notes";
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        InitPageControllers();
        RecCustomer.SetRange("No.", Rec."Sell-to Customer No.");
        if RecCustomer.FindSet() then begin
            CustomerNotes := RecCustomer."Customer Notes";
            CustomerCCNotes := RecCustomer."Customer CC Notes";
        end;
    end;

    local procedure InitPageControllers()
    begin
        ReleaseControllerStatus := Rec.Status = Rec.Status::Open;
        ReopenControllerStatus := Rec.Status = Rec.Status::Released;
    end;
}