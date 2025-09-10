pageextension 50122 SalesOrderExtension extends "Sales Order"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Order Notes"; Rec."Order Notes")
            {
                ApplicationArea = All;
                QuickEntry = false;
                Importance = Standard;
                ShowMandatory = true;
                MultiLine = true;
                InstructionalText = 'Notes about this order...';
            }
            field("Customer Balance"; CustBalance)
            {
                ApplicationArea = All;
                Caption = 'Customer Balance (LCY)';
                Tooltip = 'The balance owed. Positive amounts mean customer owes US, whereas negative numbers mean we owe THEM.';
                Editable = False;
                Importance = Standard;
                Visible = true;
                StyleExpr = BalanceStyle;
                trigger OnDrillDown()
                begin
                    RecCustomer.OpenCustomerLedgerEntries(true);
                end;
            }
        }
        moveafter("Sell-to Customer Name"; "Your Reference", Status, "Shipping Advice", "Payment Method Code", "Shortcut Dimension 1 Code")
        moveafter("Sell-to Contact"; "External Document No.")
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
                ShowCaption = false;
                InstructionalText = 'Customer Notes';
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
                Caption = 'CC Info';
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
        modify("Sell-to Customer No.") { Importance = Standard; }
        modify("Sell-to Phone No.") { QuickEntry = false; Importance = Standard; }
        modify("Sell-to E-Mail") { QuickEntry = false; Importance = Standard; }
        modify("Sell-to Contact") { QuickEntry = false; }
        modify("Sell-to Address") { Importance = Standard; QuickEntry = false; }
        modify("Sell-to Address 2") { Importance = Standard; QuickEntry = false; }
        modify("Sell-to City") { Importance = Standard; QuickEntry = false; }
        modify("Sell-to County") { Importance = Standard; QuickEntry = false; }
        modify("Sell-to Post Code") { Importance = Standard; QuickEntry = false; }
        modify("Sell-to Country/Region Code") { Importance = Standard; QuickEntry = false; }
        modify("Your Reference") { Importance = Standard; QuickEntry = true; ShowMandatory = true; InstructionalText = 'e.g. AC TEL CC'; }
        modify(WorkDescription) { Importance = Additional; Visible = true; QuickEntry = false; }
        modify("External Document No.") { Importance = Standard; Visible = true; QuickEntry = false; }
        modify("Document Date") { Visible = true; Importance = Standard; QuickEntry = false; }
        modify("Due Date") { Visible = true; Importance = Standard; QuickEntry = false; }
        modify("Posting Date") { Visible = true; Importance = Standard; QuickEntry = false; }
        modify("VAT Reporting Date") { Visible = true; Importance = Standard; QuickEntry = false; }
        modify("Ship-to Name") { Importance = Standard; }
        modify("Ship-to Code") { Importance = Standard; }
        modify("Ship-to Address") { Importance = Standard; }
        modify("Ship-to Address 2") { Importance = Standard; }
        modify("Ship-to City") { Importance = Standard; }
        modify("Ship-to County") { Importance = Standard; }
        modify("Ship-to Post Code") { Importance = Standard; }
        modify("Shipment Date") { Importance = Standard; Visible = true; }
        modify("Requested Delivery Date") { QuickEntry = false; Importance = Additional; }
        modify("Assigned User ID") { Importance = Standard; QuickEntry = false; }
        modify("Shipping Advice") { Importance = Standard; }
        modify(ShpfyOrderNo) { Importance = Standard; }
        addafter("Sell-to Phone No.")
        {
            field("Sell-to Mobile No."; Rec."Mobile No.") { ApplicationArea = All; Importance = Standard; }
        }
        modify(SellToMobilePhoneNo) { Importance = Standard; CaptionML = ENG = 'Contact Mobile No.'; }
        moveafter("Sell-to Contact"; SellToMobilePhoneNo)
        modify(Control4) { Visible = true; }
        moveafter(SalesDocCheckFactbox; Control1906127307)
        movelast(factboxes; Control1902018507)
        modify(Control1902018507) { Visible = true; }
        modify("Payment Method Code") { Importance = Standard; QuickEntry = true; }
        modify(SelectedPayments) { Visible = false; }
        modify("Direct Debit Mandate ID") { Visible = false; }
        addafter("Pmt. Discount Date")
        {
            field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type") { ApplicationArea = All; Visible = true; }
            field("Applies-to Doc. No."; Rec."Applies-to Doc. No.") { ApplicationArea = All; Visible = true; }
        }
        addbefore(IncomingDocAttachFactBox)
        {
            part(VendorListFactbox; "Item Vendor List Factbox")
            {
                ApplicationArea = All;
                Visible = true;
                Provider = SalesLines;
                SubPageLink = "Item No." = FIELD("No.");
                SubPageView = sorting("Vendor No.", "Vendor Item No.");
            }
        }
    }
    actions
    {
        movefirst(Category_Category6; PostAndSend_Promoted)
        addlast(Category_Process)
        {
            actionref(PickInstruction; "Pick Instruction") { }
            actionref(PrintConfirmation; "Print Confirmation") { }
            actionref(ItemJournal_Promoted; ItemJournal) { }
            actionref(ItemList_Promoted; ItemList) { }
            actionref(CustomerCard; Customer) { }
            actionref(Statistics3; SalesOrderStatistics) { }
        }
        modify(SalesOrderStatistics) { Visible = true; }
        modify("Create &Warehouse Shipment") { Visible = false; }
        modify("Create Inventor&y Put-away/Pick") { Visible = false; }
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
                BlankReference();
                if rec."Posting Date" = 0D then begin
                    Rec.Validate(Rec."Posting Date", Today);
                    Rec.Modify();
                end;
            end;
        }
        modify(PostAndSend)
        {
            trigger OnBeforeAction()
            begin
                BlankReference();
                if rec."Posting Date" = 0D then begin
                    Rec.Validate(Rec."Posting Date", Today);
                    Rec.Modify();
                end;
            end;
        }
        modify(PostAndNew)
        {
            trigger OnBeforeAction()
            begin
                BlankReference();
                if rec."Posting Date" = 0D then begin
                    Rec.Validate(Rec."Posting Date", Today);
                    Rec.Modify();
                end;
            end;
        }
        modify(Release) { Enabled = ReleaseControllerStatus; }
        modify(Reopen) { Enabled = ReopenControllerStatus; }
    }

    var
        RecCustomer: Record Customer;
        CustomerNotes: Text[2000];
        CustomerCCNotes: Text[150];
        ReleaseControllerStatus: Boolean;
        ReopenControllerStatus: Boolean;
        IsCustomerOrContactNotEmpty: Boolean;
        BalanceStyle: Text;

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

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        BlankReference();
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
        BalanceStyle := SetBalanceStyle();
    end;

    local procedure InitPageControllers()
    begin
        ReleaseControllerStatus := Rec.Status = Rec.Status::Open;
        ReopenControllerStatus := Rec.Status = Rec.Status::Released;
    end;

    local procedure CustBalance(): Decimal
    begin
        RecCustomer.CalcFields("Balance (LCY)");
        exit(RecCustomer."Balance (LCY)");
    end;

    local procedure SetBalanceStyle(): Text
    begin
        if CustBalance > 0 then
            exit('unfavorable')
        else if CustBalance < 0 then exit('favorable');
        exit('standard');
    end;

    local procedure BlankReference()
    begin
        if rec."Your Reference" = '' then begin
            if Rec."No." <> '' then
                if rec."Your Reference" = '' then Error('You must enter "Your Reference" for this order.');
        end;
    end;
}