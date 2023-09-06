pageextension 50106 VendorListExtension extends "Vendor List"
{
    layout
    {
        modify("No.")
        { StyleExpr = BlockedStyleNo; }
        modify(Name)
        { StyleExpr = BlockedStyle; }
        modify(Control1)
        { FreezeColumn = Name; }
        modify("Location Code")
        { Visible = false; }
        addafter(Contact)
        {
            field(City; Rec.City)
            { ApplicationArea = All; }
            field("Post Code1"; Rec."Post Code")
            { ApplicationArea = All; }
            field("Country/Region Code1"; Rec."Country/Region Code")
            { ApplicationArea = All; }
        }
        modify("Phone No.")
        {
            ApplicationArea = All;
            StyleExpr = BlockedStyleNo;
        }
        addafter("Phone No.")
        {
            field("Mobile Phone No."; Rec."Mobile Phone No.")
            {
                ApplicationArea = All;
                ExtendedDatatype = PhoneNo;
                StyleExpr = BlockedStyleNo;
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = All;
                ExtendedDatatype = EMail;
                StyleExpr = BlockedStyleNo;
            }
        }
        addafter("Payments (LCY)")
        {
            field("Supply Type"; Rec."Supply Type")
            { ApplicationArea = All; }
            field("Vendor Notes"; Rec."Vendor Notes")
            { ApplicationArea = All; }
        }
    }
    actions
    {
        addafter(Email_Promoted)
        {
            actionref("Purchase Journal_Promoted1"; "Purchase Journal")
            { }
            actionref("Payment Journal_Promoted1"; "Payment Journal")
            { }
        }
        addafter("Ledger E&ntries_Promoted")
        {
            actionref("Bank Accounts_Promoted1"; "Bank Accounts")
            { }
            actionref(OrderAddresses_Promoted1; OrderAddresses)
            { }
        }
        addlast("Ven&dor")
        {
            action("Ledger Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Ledger Entries';
                Image = VendorLedger;
                RunObject = Page "Vendor Ledger Entries";
                RunPageLink = "Vendor No." = FIELD("No.");
                RunPageView = SORTING("Vendor No.")
                                  ORDER(Descending);
                ToolTip = 'View the history of transactions that have been posted for the selected record.';
                Scope = Repeater;
            }
            action("Open Ledger Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open Entries';
                Image = VendorLedger;
                RunObject = Page "Vendor Ledger Entries";
                RunPageLink = "Vendor No." = FIELD("No.");
                RunPageView = SORTING("Vendor No.")
                                  ORDER(Descending) where(Open = filter(true));
                ToolTip = 'View the open transactions that have been posted for the selected record.';
                Scope = Repeater;
            }
        }
    }
    views
    {
        addfirst
        {
            view(ActiveVendors)
            {
                Caption = 'Active Suppliers';
                Filters = where("Blocked" = const(" "));

            }
            view(InactiveVendors)
            {
                Caption = 'Inactive Suppliers';
                Filters = where("Blocked" = filter('All|Payment'));

            }
            view(Balance)
            {
                Caption = 'Balance';
                Filters = where("Balance" = filter('<>0'));

            }
            view(PhoneNumbers)
            {
                Caption = 'Phone Numbers';
                SharedLayout = false;
                Filters = where("Blocked" = const(" "));
                layout
                {
                    modify("E-Mail")
                    { Visible = false; }
                    modify(Contact)
                    { Visible = false; }
                    modify(City)
                    { Visible = false; }
                    modify("Post Code")
                    { Visible = false; }
                    modify("Post Code1")
                    { Visible = false; }
                    modify("Country/Region Code")
                    { Visible = false; }
                    modify("Country/Region Code1")
                    { Visible = false; }
                    modify("Search Name")
                    { Visible = false; }
                    modify("Balance (LCY)")
                    { Visible = false; }
                    modify("Balance Due (LCY)")
                    { Visible = false; }
                    modify("Payments (LCY)")
                    { Visible = false; }
                    modify("Supply Type")
                    { Visible = false; }
                    modify("Vendor Notes")
                    { Visible = false; }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetBlockedStyle();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetBlockedStyle();
    end;

    procedure SetBlockedStyle()
    begin
        if Rec.Blocked = Rec.Blocked::" " then begin
            BlockedStyle := 'Standard';
            BlockedStyleNo := 'StandardAccent';
        end else
            if Rec.Blocked = Rec.Blocked::All then begin
                BlockedStyle := 'Subordinate';
                BlockedStyleNo := 'Subordinate';
            end else
                if Rec.Blocked = Rec.Blocked::Payment then begin
                    BlockedStyle := 'Ambiguous';
                    BlockedStyleNo := 'Ambiguous';
                end;
    end;

    var
        BlockedStyle: Text;
        BlockedStyleNo: Text;

    // trigger OnOpenPage()
    // begin
    //     Rec.SetCurrentKey("No.");
    //     Rec.Ascending(true);
    //     Rec.SetRange(Blocked, Rec.Blocked::" ");
    // end;
}