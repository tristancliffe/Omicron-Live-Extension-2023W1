pageextension 50134 PurchQuoteExt extends "Purchase Quote"
{
    layout
    {
        moveafter("Buy-from Vendor Name"; Status)
        movebefore("Buy-from Contact"; "Buy-from Contact No.")
        addafter("Buy-from Vendor Name")
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = All;
                QuickEntry = true;
            }
        }
        addafter("Your Reference")
        {
            field("Preferred Payment Method"; PaymentMethod)
            {
                ApplicationArea = All;
                Caption = 'Preferred Payment Method';
                ToolTip = 'Pulled from Vendor card';
                Editable = false;
                Style = Strong;
            }
            field("Order Notes"; Rec."Order Notes")
            {
                ApplicationArea = All;
                QuickEntry = false;
                Importance = Standard;
                MultiLine = true;
            }
        }
        addafter("Buy-from")
        {
            field("Order Vendor Notes"; VendorNotes)
            {
                Caption = 'Vendor Notes';
                MultiLine = true;
                ApplicationArea = All;
                Importance = Standard;
                ToolTip = 'This SHOULD be the vendor notes brought across to the orders';
                QuickEntry = false;
                Editable = true;

                trigger OnValidate()
                begin
                    RecVendor."Vendor Notes" := VendorNotes;
                    RecVendor.Modify()
                end;
            }
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
        modify("Buy-from Vendor No.")
        { Importance = Standard; }
        modify("Assigned User ID")
        { Importance = Standard; }
        modify("Vendor Order No.")
        { Importance = Standard; }
        modify("Payment Method Code")
        { Importance = Promoted; }
        modify(BuyFromContactPhoneNo)
        { Importance = Standard; }
        modify(BuyFromContactMobilePhoneNo)
        { Importance = Standard; }
        modify(BuyFromContactEmail)
        { Importance = Standard; }
        modify("Currency Code")
        { Importance = Standard; }
        movebefore(Control1904651607; Control5)
    }
    actions
    {
        addlast(Category_Process)
        {
            actionref(VendorCard; Vendor)
            { }
        }
        modify(Release)
        { Enabled = ReleaseControllerStatus; }
        modify(Reopen)
        { Enabled = ReopenControllerStatus; }
    }

    var
        RecVendor: Record Vendor;
        ReleaseControllerStatus: Boolean;
        ReopenControllerStatus: Boolean;
        PaymentMethod: Text[50];
        VendorNotes: Text[1000];

    trigger OnInsertRecord(BelowXRec: Boolean): Boolean
    begin
        Rec."Assigned User ID" := USERID;
        RecVendor.SetRange("No.", Rec."Buy-from Vendor No.");
        if RecVendor.FindSet() then begin
            VendorNotes := RecVendor."Vendor Notes";
            PaymentMethod := RecVendor."Preferred Payment Method";
            //Rec.Modify()
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec.Validate(Rec."Your Reference", UpperCase(Rec."Your Reference"));
    end;

    trigger OnOpenPage()
    begin
        InitPageControllers();
        RecVendor.SetRange("No.", Rec."Buy-from Vendor No.");
        if RecVendor.FindSet() then begin
            VendorNotes := RecVendor."Vendor Notes";
            PaymentMethod := RecVendor."Preferred Payment Method";
            //Rec.Modify()
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        InitPageControllers();
        Rec.CalcFields("Amount Including VAT");
        RecVendor.SetRange("No.", Rec."Buy-from Vendor No.");
        if RecVendor.FindSet() then begin
            VendorNotes := RecVendor."Vendor Notes";
            PaymentMethod := RecVendor."Preferred Payment Method";
            //Rec.Modify()
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        InitPageControllers();
        RecVendor.SetRange("No.", Rec."Buy-from Vendor No.");
        if RecVendor.FindSet() then begin
            VendorNotes := RecVendor."Vendor Notes";
            PaymentMethod := RecVendor."Preferred Payment Method";
            //Rec.Modify()
        end;
    end;

    local procedure InitPageControllers()
    begin
        ReleaseControllerStatus := Rec.Status = Rec.Status::Open;
        ReopenControllerStatus := Rec.Status = Rec.Status::Released;
    end;
}