pageextension 50123 QuoteExtension extends "Sales Quote"
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
            field("Sell-to Phone No."; Rec."Sell-to Phone No.") { ApplicationArea = All; Importance = Standard; }
            field("Mobile No."; Rec."Mobile No.") { ApplicationArea = All; Importance = Standard; }
            field("Sell-to E-Mail"; Rec."Sell-to E-Mail") { ApplicationArea = All; Importance = Standard; }
        }
        moveafter("Sell-to Customer Name"; "Your Reference", Status)
        moveafter("Sell-to Contact"; "Sell-to Contact No.", "External Document No.")
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

                trigger OnValidate()
                begin
                    RecCustomer."Customer Notes" := CustomerNotes;
                    RecCustomer.Modify()
                end;
            }
        }
        modify("Sell-to Contact No.") { QuickEntry = false; }
        modify("Sell-to Contact") { QuickEntry = false; }
        modify("External Document No.") { QuickEntry = false; }
        modify("Sell-to Customer No.") { Importance = Standard; }
        modify("Your Reference") { Importance = Standard; ShowMandatory = true; QuickEntry = true; }
        modify("Sell-to Address") { Importance = Standard; QuickEntry = false; }
        modify("Sell-to Address 2") { Importance = Standard; QuickEntry = false; }
        modify("Sell-to City") { Importance = Standard; QuickEntry = false; }
        modify("Sell-to County") { Importance = Standard; QuickEntry = false; }
        modify("Sell-to Post Code") { Importance = Standard; QuickEntry = false; }
        modify("Sell-to Country/Region Code") { Importance = Standard; QuickEntry = false; }
        modify(WorkDescription) { Importance = Additional; Visible = true; QuickEntry = false; }
        modify(SellToPhoneNo) { Visible = false; }
        modify(SellToMobilePhoneNo) { Visible = false; }
        modify(SellToEmail) { Visible = false; }
        modify("Document Date")
        {
            Visible = true;
            Importance = Standard;
            QuickEntry = false;
            trigger OnAfterValidate()
            begin
                Rec."Quote Valid Until Date" := Rec."Document Date" + 30;
            end;
        }
        modify("Due Date") { Visible = true; Importance = Standard; QuickEntry = false; }
        modify("Ship-to Name") { Importance = Standard; }
        modify("Ship-to Code") { Importance = Standard; }
        modify("Ship-to Address") { Importance = Standard; }
        modify("Ship-to Address 2") { Importance = Standard; }
        modify("Ship-to City") { Importance = Standard; }
        modify("Ship-to County") { Importance = Standard; }
        modify("Ship-to Post Code") { Importance = Standard; }
        modify("Shipment Date") { Importance = Standard; }
        modify("Assigned User ID") { Importance = Standard; QuickEntry = false; }
        // addafter("Sell-to Country/Region Code")
        // {
        //     field("Sell-to Phone No.2"; Rec."Sell-to Phone No.") { ApplicationArea = All; CaptionML = ENU = 'Phone No.'; QuickEntry = false; }
        //     field("Sell-to E-Mail2"; Rec."Sell-to E-Mail") { ApplicationArea = All; CaptionML = ENU = 'E-Mail Address'; QuickEntry = false; }
        //     field("Mobile No."; MobileNo)
        //     {
        //         ApplicationArea = All;
        //         CaptionML = ENU = 'Mobile Phone No.';
        //         ExtendedDatatype = PhoneNo;
        //         QuickEntry = false;
        //         Numeric = true;

        //         trigger OnValidate()
        //         begin
        //             RecCustomer."Mobile Phone No." := MobileNo;
        //             RecCustomer.Modify()
        //         end;
        //     }
        // }
        modify("Quote Valid Until Date") { Visible = true; Importance = Standard; QuickEntry = false; }
        modify("Requested Delivery Date") { QuickEntry = false; }
        modify("Salesperson Code") { QuickEntry = false; }
        modify("Responsibility Center") { QuickEntry = false; }
        modify(Control72) { Visible = true; }
        //movebefore("Attached Documents"; Control1906127307)
        movebefore("Attached Documents List"; Control1906127307)
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
            actionref(ItemJournal_Promoted; ItemJournal) { }
            actionref(ItemList_Promoted; ItemList) { }
            actionref(CustomerCard; Customer) { }
        }
        modify(Release) { Enabled = ReleaseControllerStatus; }
        modify(Reopen) { Enabled = ReopenControllerStatus; }
    }

    var
        RecCustomer: Record Customer;
        ReleaseControllerStatus: Boolean;
        ReopenControllerStatus: Boolean;
        CustomerNotes: Text[2000];
        MobileNo: Text[30];

    protected var
        CallNotificationCheck: Boolean;

    trigger OnInsertRecord(BelowXRec: Boolean): Boolean
    begin
        Rec."Assigned User ID" := USERID;
        RecCustomer.SetRange("No.", Rec."Sell-to Customer No.");
        if RecCustomer.FindSet() then begin
            CustomerNotes := RecCustomer."Customer Notes";
            MobileNo := RecCustomer."Mobile Phone No.";
            //rec.modify()
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
            MobileNo := RecCustomer."Mobile Phone No.";
            //rec.modify()
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
            MobileNo := RecCustomer."Mobile Phone No.";
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        InitPageControllers();
        RecCustomer.SetRange("No.", Rec."Sell-to Customer No.");
        if RecCustomer.FindSet() then begin
            CustomerNotes := RecCustomer."Customer Notes";
            MobileNo := RecCustomer."Mobile Phone No.";
        end;
    end;

    local procedure InitPageControllers()
    begin
        ReleaseControllerStatus := Rec.Status = Rec.Status::Open;
        ReopenControllerStatus := Rec.Status = Rec.Status::Released;
    end;

    procedure CheckNotificationsOnce()
    begin
        CallNotificationCheck := true;
    end;

    local procedure BlankReference()
    begin
        if rec."Your Reference" = '' then begin
            if Rec."No." <> '' then
                Error('You must enter "Your Reference" for this order.');
        end
    end;
}