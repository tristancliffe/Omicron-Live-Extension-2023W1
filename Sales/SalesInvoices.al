pageextension 50124 SalesInvoiceExtension extends "Sales Invoice"
{
    layout
    {
        moveafter("Sell-to Customer Name"; "Your Reference")
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
        { Importance = Standard; ShowMandatory = true; QuickEntry = true; }
        modify(WorkDescription)
        { Importance = Additional; Visible = true; }
        modify("Document Date")
        { Visible = true; Importance = Standard; }
        modify("Due Date")
        { Visible = true; Importance = Standard; }
        modify("Posting Date")
        { Visible = true; Importance = Standard; }
        modify("VAT Reporting Date")
        { Visible = true; Importance = Standard; }
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
        { Importance = Standard; QuickEntry = false; }
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
        modify("External Document No.")
        { Importance = Standard; Visible = true; }
        addafter("Sell-to Country/Region Code")
        {
            field("Sell-to Phone No.2"; Rec."Sell-to Phone No.")
            { ApplicationArea = All; CaptionML = ENU = 'Phone No.'; }
            field("Sell-to E-Mail2"; Rec."Sell-to E-Mail")
            { ApplicationArea = All; CaptionML = ENU = 'E-Mail Address'; }
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
        modify(Control202)
        { Visible = true; }
        moveafter(SalesDocCheckFactbox; Control1906127307)
        modify(Control1906127307) { Visible = true; }
    }
    actions
    {
        movefirst(Category_Category5; PostAndSend_Promoted)
        addlast(Category_Process)
        {
            actionref(ItemJournal_Promoted; ItemJournal)
            { }
            actionref(ItemList_Promoted; ItemList)
            { }
            actionref(CustomerCard_promoted; Function_CustomerCard)
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
        moveafter(Category_Category8; GetRecurringSalesLines_Promoted)
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    Rec.Validate(Rec."Posting Date", Today);
                    //Rec.Modify();
                end;
            end;
        }
        modify(PostAndSend)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    Rec.Validate(Rec."Posting Date", Today);
                    //Rec.Modify();
                end;
            end;
        }
        modify(PostAndNew)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    Rec.Validate(Rec."Posting Date", Today);
                    // Rec.Modify();
                end;
            end;
        }
        // modify(Preview)
        // {
        //     trigger OnBeforeAction()
        //     begin
        //         if rec."Posting Date" = 0D then begin
        //             Rec.Validate("Posting Date", Today);
        //             Rec.Modify();
        //         end;
        //     end;
        // }
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
        Rec.Validate(Rec."Your Reference", UpperCase(Rec."Your Reference"));
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