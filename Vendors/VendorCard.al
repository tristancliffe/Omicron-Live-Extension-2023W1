pageextension 50105 VendorCardExtension extends "Vendor Card"
{
    layout
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                if rec.Name = '' then begin
                    rec."Payment Terms Code" := '30 DAYS';
                    rec."Location Code" := 'STORES';
                end;
            end;
        }
        modify("Search Name") { Importance = Standard; }
        modify("Fax No.") { Importance = Standard; }
        moveafter(AddressDetails; "Home Page")
        modify("VAT Registration No.") { Importance = Promoted; }
        moveafter("Post Code"; "Country/Region Code")
        moveafter(ShowMap; "Language Code")
        moveafter("Fax No."; "Home Page")
        addlast(General) //! User Control for the large notes field...
        {
            field("Supply Type"; Rec."Supply Type")
            {
                ApplicationArea = All;
            }
            field("Preferred Payment Method"; Rec."Preferred Payment Method")
            {
                ApplicationArea = All;
            }
            // field("Vendor Notes"; Rec."Vendor Notes")
            // {
            //     MultiLine = true;
            //     ApplicationArea = All;
            //     AssistEdit = true;
            //     trigger OnAssistEdit()
            //     begin
            //         Message(Rec."Vendor Notes")
            //     end;
            // }
            usercontrol(UserControlDesc; WebPageViewer) //"Microsoft.Dynamics.Nav.Client.WebPageViewer")
            {
                ApplicationArea = All;
                trigger ControlAddInReady(callbackUrl: Text)
                begin
                    IsReady := true;
                    FillAddIn();
                end;

                trigger Callback(data: Text)
                begin
                    Rec."Vendor Notes" := data;
                end;
            }
        }
        moveafter("Preferred Payment Method"; Blocked)
        modify("Payment Terms Code") { ShowMandatory = true; }
        modify("Location Code") { ShowMandatory = true; }
        modify("Gen. Bus. Posting Group") { Importance = Standard; ShowMandatory = true; }
        modify("VAT Bus. Posting Group") { Importance = Standard; ShowMandatory = true; }
        modify("Vendor Posting Group") { Importance = Standard; ShowMandatory = true; }
        modify("Registration Number") { Importance = Standard; }
        modify("Country/Region Code")
        {
            //ShowMandatory = true; //## This was used before I found out how to make Country appear by default in General Ledger Setup
            trigger OnAfterValidate()
            begin
                if Rec."Country/Region Code" = 'GB' then begin
                    Rec."Gen. Bus. Posting Group" := 'UK';
                    Rec."VAT Bus. Posting Group" := 'UK';
                    Rec."Vendor Posting Group" := 'UK';
                end;
            end;
        }
        addbefore("Balance (LCY)")
        {
            field(Balance; Rec.Balance) { ApplicationArea = All; }
        }
        addbefore("Balance Due (LCY)")
        {
            field("Balance Due"; Rec."Balance Due") { ApplicationArea = All; }
        }
    }
    actions
    {
        addlast("&Purchases")
        {
            action(ItemsFromVendor)
            {
                ApplicationArea = All;
                Caption = 'Items from Vendor';
                Image = Item;
                RunObject = Page "Vendor Item Catalog";
                RunPageLink = "Vendor No." = FIELD("No.");
                RunPageView = SORTING("Vendor No.", "Item No.");
                ToolTip = 'Open the list of items that you trade in with this vendor.';
            }
        }
        addlast(Category_Process)
        {
            actionref(Dimensions_Promoted2; Dimensions) { }
            actionref(LedgerEntries_Promoted; "Ledger E&ntries") { }
            actionref(OrderAddress_Promoted; OrderAddresses) { }
            actionref(BankAccounts_Promoted; "Bank Accounts") { }
            actionref(CreatePayment_Promoted; "Create Payments") { }
            actionref(ItemsFromVendor_Promoted; ItemsFromVendor) { }
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
        CurrPage.UserControlDesc.SetContent(StrSubstNo('<textarea Id="TextArea" maxlength="%2" style="width:100%;height:50%;resize: none; font-family: &quot;Segoe UI&quot;, &quot;Segoe WP&quot;, Segoe, device-segoe, Tahoma, Helvetica, Arial, sans-serif !important; font-size: 11pt !important;" OnChange="window.parent.WebPageViewerHelper.TriggerCallback(document.getElementById(''TextArea'').value)">%1</textarea>', Rec."Vendor Notes", MaxStrLen(Rec."Vendor Notes")));
    end; //! end of large notes field code...
}