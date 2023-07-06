pageextension 50122 SalesOrderExtension extends "Sales Order"
{
    layout
    {
        moveafter("Sell-to Customer Name"; "Your Reference")
        moveafter("Sell-to Contact"; "External Document No.")
        addafter("Sell-to")
        {
            field("Order Customer Notes"; CustomerNotes)
            {
                MultiLine = true;
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
        }
        modify("Sell-to Customer No.")
        { Importance = Standard; }
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
        modify("Your Reference")
        {
            Importance = Standard;
            QuickEntry = true;
            ShowMandatory = true;
        }
        modify(WorkDescription)
        {
            Importance = Standard;
            Visible = false;
        }
        modify("External Document No.")
        {
            Importance = Standard;
            Visible = true;
        }
        modify("Document Date")
        {
            Visible = true;
            Importance = Standard;
        }
        modify("Due Date")
        {
            Visible = true;
            Importance = Standard;
        }
        modify("Posting Date")
        {
            Visible = true;
            Importance = Standard;
        }
        modify("VAT Reporting Date")
        {
            Visible = true;
            Importance = Standard;
        }
        modify("Ship-to Name")
        { Importance = Standard; }
        modify("Ship-to Code")
        { Importance = Standard; }
        modify("Ship-to Address")
        { Importance = Standard; }
        modify("Ship-to Address 2")
        { Importance = Standard; }
        modify("Ship-to City")
        { Importance = Standard; }
        modify("Ship-to County")
        { Importance = Standard; }
        modify("Ship-to Post Code")
        { Importance = Standard; }
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
        moveafter("Order Notes47091"; Status)
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
            field("Mobile No."; MobileNo)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Mobile Phone No.';
                ExtendedDatatype = PhoneNo;
                Numeric = true;

                trigger OnValidate()
                begin
                    RecCustomer."Mobile Phone No." := MobileNo;
                    RecCustomer.Modify()
                end;
            }
        }
        modify(Control4)
        { Visible = true; }
        moveafter(SalesDocCheckFactbox; Control1906127307)
        movelast(factboxes; Control1902018507)
        modify(Control1902018507)
        {
            Visible = true;
        }
        modify("Payment Method Code")
        {
            Importance = Standard;
            QuickEntry = true;
        }
        modify(SelectedPayments)
        { Visible = false; }
        modify("Direct Debit Mandate ID")
        { Visible = false; }
    }
    actions
    {
        movefirst(Category_Category6; PostAndSend_Promoted)
        addlast(Category_Process)
        {
            actionref(PickInstruction; "Pick Instruction")
            { }
            actionref(PrintConfirmation; "Print Confirmation")
            { }
            actionref(ItemJournal_Promoted; ItemJournal)
            { }
            actionref(ItemList_Promoted; ItemList)
            { }
            actionref(CustomerCard; Customer)
            { }
            actionref(Statistics2; Statistics)
            { }
        }
        // modify("Pick Instruction")
        // {
        //     Promoted = true;
        //     PromotedCategory = Process;
        //     PromotedOnly = true;
        // }
        modify("Create &Warehouse Shipment")
        { Visible = false; }
        modify("Create Inventor&y Put-away/Pick")
        { Visible = false; }
        // modify("Print Confirmation")
        // {
        //     Promoted = true;
        //     PromotedCategory = Process;
        // }
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
                // Promoted = true;
                // PromotedOnly = true;
                // PromotedCategory = Process;
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
                // Promoted = true;
                // PromotedOnly = true;
                // PromotedCategory = Process;
            }
            action(ItemCard)
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
                Enabled = true;
            }
        }
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    rec."Posting Date" := Today;
                    Rec.Modify();
                end;
            end;
        }
        modify(PostAndSend)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    rec."Posting Date" := Today;
                    Rec.Modify();
                end;
            end;
        }
        modify(PostAndNew)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    rec."Posting Date" := Today;
                    Rec.Modify();
                end;
            end;
        }
        modify(Release)
        { Enabled = ReleaseControllerStatus; }
        modify(Reopen)
        { Enabled = ReopenControllerStatus; }
    }

    var
        RecCustomer: Record Customer;
        CustomerNotes: Text[2000];
        MobileNo: Text[30];
        ReleaseControllerStatus: Boolean;
        ReopenControllerStatus: Boolean;

    trigger OnInsertRecord(BelowXRec: Boolean): Boolean
    begin
        Rec."Assigned User ID" := USERID;
        RecCustomer.SetRange("No.", Rec."Sell-to Customer No.");
        if RecCustomer.FindSet() then begin
            CustomerNotes := RecCustomer."Customer Notes";
            MobileNo := RecCustomer."Mobile Phone No.";
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec."Your Reference" := UpperCase(Rec."Your Reference");
    end;

    trigger OnOpenPage()
    begin
        InitPageControllers();
        RecCustomer.SetRange("No.", Rec."Sell-to Customer No.");
        if RecCustomer.FindSet() then begin
            CustomerNotes := RecCustomer."Customer Notes";
            MobileNo := RecCustomer."Mobile Phone No.";
        end;
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
}