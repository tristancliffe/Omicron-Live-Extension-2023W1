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