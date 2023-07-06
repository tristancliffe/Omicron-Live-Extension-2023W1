// The layout of the page is modified with various changes.
// The "Name" field is modified, and an "OnAfterValidate" trigger is added to check if the customer's name is empty, then it validates the "Payment Terms Code" field with '0 DAYS' and the "Location Code" field with 'STORES' values.
// A new field "Vehicle Model" is added after the "Name" field, and it has "MultiLine" set to false and "ApplicationArea" set to All.
// The "Post Code" field is moved after the "Country/Region Code" field.
// The "Fax No.", "MobilePhoneNo", "VAT Registration No.", "Ship-to Code", "Shipping Advice", and "Balance (LCY)2" fields are modified, and their "Importance" is set to "Standard" or "Promoted".
// The "Primary Contact No." and "ContactName" fields are modified, and their "Importance" is set to "Standard".
// The "Blocked" field is moved to the end of the "General" section.
// A new user control is added for the "Customer Notes" field, which allows the user to add and edit large notes.
// The "Payment Terms Code", "Location Code", "Gen. Bus. Posting Group", "VAT Bus. Posting Group", "Customer Posting Group", and "Country/Region Code" fields are modified, and their "ShowMandatory" property is set to true.
// An "OnAfterValidate" trigger is added to the "Country/Region Code" field, which checks if the code is 'GB', then it sets the "Gen. Bus. Posting Group", "VAT Bus. Posting Group", and "Customer Posting Group" fields to 'UK'.
// Some actions are added to the page extension, such as "Ledger Entries", "ShipToAddresses", "Post Cash Receipts", and "PaymentRegistration".
// A variable "IsReady" is defined to handle the large notes field.
// An "OnAfterGetCurrRecord" trigger is added to the page extension to check if the user control is ready, then it calls the "FillAddIn" function.
// A local procedure "FillAddIn" is defined to set the content of the user control for the large notes field.
pageextension 50102 CustomerCardExt extends "Customer Card"
{
    layout
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                if Rec.Name = '' then begin
                    rec.Validate("Payment Terms Code", '0 DAYS');
                    Rec.Validate("Location Code", 'STORES');
                    //Rec.Validate("Country/Region Code", 'GB');
                end;
            end;
        }
        addafter(Name)
        {
            field("Vehicle Model"; Rec."Vehicle Model")
            {
                MultiLine = false;
                ApplicationArea = All;
            }
        }
        moveafter("Post Code"; "Country/Region Code")
        modify("Fax No.")
        { Importance = Standard; }
        modify("Phone No.")
        { Importance = Promoted; }
        modify(MobilePhoneNo)
        { Importance = Promoted; }
        modify("VAT Registration No.")
        { Importance = Standard; }
        modify("Ship-to Code")
        { Importance = Promoted; }
        modify("Shipping Advice")
        { Importance = Standard; }
        modify("Balance (LCY)2")
        { Importance = Standard; }
        modify("Primary Contact No.")
        { Importance = Standard; }
        modify(ContactName)
        { Importance = Standard; }
        movelast(General; Blocked)
        addlast(General) //! User Control for the large notes field...
        {
            // field("Customer Notes"; Rec."Customer Notes")
            // {
            //     MultiLine = true;
            //     ApplicationArea = All;
            //     AssistEdit = true;
            //     trigger OnAssistEdit()
            //     begin
            //         Message(Rec."Customer Notes")
            //     end;
            // }
            usercontrol(UserControlDesc; "Microsoft.Dynamics.Nav.Client.WebPageViewer")
            {
                ApplicationArea = All;
                trigger ControlAddInReady(callbackUrl: Text)
                begin
                    IsReady := true;
                    FillAddIn();
                end;

                trigger Callback(data: Text)
                begin
                    Rec."Customer Notes" := data;
                end;
            }
        }
        modify("Payment Terms Code")
        { ShowMandatory = true; }
        modify("Location Code")
        { ShowMandatory = true; }
        modify("Gen. Bus. Posting Group")
        {
            Importance = Standard;
            ShowMandatory = true;
        }
        modify("VAT Bus. Posting Group")
        {
            Importance = Standard;
            ShowMandatory = true;
        }
        modify("Customer Posting Group")
        {
            Importance = Standard;
            ShowMandatory = true;
        }
        modify("Country/Region Code")
        {
            trigger OnAfterValidate()
            begin
                if Rec."Country/Region Code" = 'GB' then begin
                    Rec."Gen. Bus. Posting Group" := 'UK';
                    Rec."VAT Bus. Posting Group" := 'UK';
                    Rec."Customer Posting Group" := 'UK';
                end;
            end;
        }
    }
    actions
    {
        addlast(Category_Process)
        {
            actionref(LedgerEntries_Promoted; "Ledger E&ntries")
            { }
            actionref(Addresses_Promoted; ShipToAddresses)
            { }
            actionref(CashReceipt_Promoted; "Post Cash Receipts")
            { }
            actionref(RequestPayment_Promoted; PaymentRegistration)
            { }
        }
    }
    var  //!To do with large notes field...
        IsReady: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        if IsReady then
            FillAddIn();
    end;

    local procedure FillAddIn()
    begin
        CurrPage.UserControlDesc.SetContent(StrSubstNo('<textarea Id="TextArea" maxlength="%2" style="width:100%;height:80%;resize: none; font-family: &quot;Segoe UI&quot;, &quot;Segoe WP&quot;, Segoe, device-segoe, Tahoma, Helvetica, Arial, sans-serif !important; font-size: 11pt !important;" OnChange="window.parent.WebPageViewerHelper.TriggerCallback(document.getElementById(''TextArea'').value)">%1</textarea>', Rec."Customer Notes", MaxStrLen(Rec."Customer Notes")));
    end; //! end of large notes field code...
}