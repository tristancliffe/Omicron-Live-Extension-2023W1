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
        modify("Your Reference") { Importance = Standard; QuickEntry = true; ShowMandatory = true; }
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
        addafter("Sell-to Country/Region Code")
        {
            field(ShowMap; ShowMapLbl)
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                ShowCaption = false;
                Style = StrongAccent;
                StyleExpr = TRUE;
                ToolTip = 'Specifies the customer''s address on your preferred map website.';

                trigger OnDrillDown()
                begin
                    CurrPage.Update(true);
                    Rec.DisplayMap();
                end;
            }
            //field("Sell-to Phone No.2"; Rec."Sell-to Phone No.") { ApplicationArea = All; CaptionML = ENU = 'Phone No.'; }
            //field("Sell-to E-Mail2"; Rec."Sell-to E-Mail") { ApplicationArea = All; CaptionML = ENU = 'E-Mail Address'; }
            // field("Mobile No."; MobileNo)
            // {
            //     ApplicationArea = All;
            //     CaptionML = ENU = 'Mobile Phone No.';
            //     ExtendedDatatype = PhoneNo;
            //     Numeric = true;
            //     QuickEntry = false;
            //     trigger OnValidate()
            //     begin
            //         RecCustomer."Mobile Phone No." := MobileNo;
            //         RecCustomer.Modify()
            //     end;
            // }
        }
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
            actionref(Statistics2; Statistics) { }
        }
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
                if rec."Posting Date" = 0D then begin
                    Rec.Validate(Rec."Posting Date", Today);
                    Rec.Modify();
                end;
            end;
        }
        // modify(PreviewPosting)
        // {
        //     trigger OnBeforeAction()
        //     begin
        //         if rec."Posting Date" = 0D then begin
        //             Rec.Validate(Rec."Posting Date", Today);
        //             Rec.Modify();
        //         end;
        //     end;
        // }
        modify(Release) { Enabled = ReleaseControllerStatus; }
        modify(Reopen) { Enabled = ReopenControllerStatus; }
    }

    var
        RecCustomer: Record Customer;
        CustomerNotes: Text[2000];
        //MobileNo: Text[30];
        ReleaseControllerStatus: Boolean;
        ReopenControllerStatus: Boolean;
        IsCustomerOrContactNotEmpty: Boolean;
        ShowMapLbl: Label 'Show on Map';

    trigger OnInsertRecord(BelowXRec: Boolean): Boolean
    begin
        Rec."Assigned User ID" := USERID;
        RecCustomer.SetRange("No.", Rec."Sell-to Customer No.");
        if RecCustomer.FindSet() then begin
            CustomerNotes := RecCustomer."Customer Notes";
            //MobileNo := RecCustomer."Mobile Phone No.";
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
            //MobileNo := RecCustomer."Mobile Phone No.";
        end;
        // if Rec."Posting Date" <> Today then begin
        //     Rec.Validate(Rec."Posting Date", Today);
        //     Rec.Modify();
        // end;
    end;

    trigger OnAfterGetRecord()
    begin
        InitPageControllers();
        RecCustomer.SetRange("No.", Rec."Sell-to Customer No.");
        if RecCustomer.FindSet() then begin
            CustomerNotes := RecCustomer."Customer Notes";
            //MobileNo := RecCustomer."Mobile Phone No.";
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        InitPageControllers();
        RecCustomer.SetRange("No.", Rec."Sell-to Customer No.");
        if RecCustomer.FindSet() then begin
            CustomerNotes := RecCustomer."Customer Notes";
            //MobileNo := RecCustomer."Mobile Phone No.";
        end;
    end;

    local procedure InitPageControllers()
    begin
        ReleaseControllerStatus := Rec.Status = Rec.Status::Open;
        ReopenControllerStatus := Rec.Status = Rec.Status::Released;
    end;
}