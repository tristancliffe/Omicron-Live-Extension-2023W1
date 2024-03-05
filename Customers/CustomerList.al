// Page Layout:
// Modifies the "No." and "Name" fields' styles.
// Freezes the "Name" column.
// Hides the "Responsibility Center" and "Location Code" fields.
// Adds "City", "Post Code1", "Country/Region Code1", "Mobile Phone No.", and "E-Mail" fields.
// Modifies the "Phone No." field's style.
// Adds "Vehicle Model" and "Customer Notes" fields.
// Adds fields, actions and views in specific places.
// Actions:
// Adds actions for "Cash Receipt Journal", "Sales Journal", and "Ship To Addresses".
// Views:
// Adds three views: "Active Customers", "Inactive Customers", and "Balance". Each with a filter.
// Triggers:
// Sets the style of blocked customers when the record is retrieved.
// Triggers commented out to sort the records by "No." and filter by blocked customers.
// Variables:
// Defines variables to hold blocked styles for use in the triggers.
pageextension 50103 CustomerListExt extends "Customer List"
{
    AboutTitle = 'General Ledger Colours';
    AboutText = 'The colours on the list show if an account is active (**black**) or blocked (**grey**) or partially blocked (**yellow**).';
    layout
    {
        modify("No.")
        { StyleExpr = BlockedStyle; }
        modify(Name)
        { StyleExpr = BlockedStyle; }
        modify(Control1)
        { FreezeColumn = Name; }
        modify("Responsibility Center")
        { Visible = false; }
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
        { StyleExpr = BlockedStyle; }
        addafter("Phone No.")
        {
            field("Mobile Phone No."; Rec."Mobile Phone No.")
            {
                ApplicationArea = All;
                ExtendedDatatype = PhoneNo;
                StyleExpr = BlockedStyle;

            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = All;
                ExtendedDatatype = EMail;
                StyleExpr = BlockedStyle;
            }
        }
        addafter("Payments (LCY)")
        {
            field("Vehicle Model"; Rec."Vehicle Model")
            { ApplicationArea = All; }
            field("Customer Notes"; Rec."Customer Notes")
            { ApplicationArea = All; }
        }
    }
    actions
    {
        addafter(PaymentRegistration_Promoted)
        {
            actionref("Cash Receipt Journal_Promoted1"; "Cash Receipt Journal")
            { }
        }
        addafter(ApplyTemplate_Promoted)
        {
            actionref("Sales Journal_Promoted1"; "Sales Journal")
            { }
        }
        addafter(CustomerLedgerEntries_Promoted)
        {
            actionref(ShipToAddresses_Promoted1; ShipToAddresses)
            { }
        }
        addlast("&Customer")
        {
            action("Ledger Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Ledger Entries';
                Image = CustomerLedger;
                RunObject = Page "Customer Ledger Entries";
                RunPageLink = "Customer No." = FIELD("No.");
                RunPageView = SORTING("Customer No.")
                                  ORDER(Descending);
                ToolTip = 'View the history of transactions that have been posted for the selected record.';
                Scope = Repeater;
            }
            action("Open Ledger Entries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open Entries';
                Image = CustomerLedger;
                RunObject = Page "Customer Ledger Entries";
                RunPageLink = "Customer No." = FIELD("No.");
                RunPageView = SORTING("Customer No.")
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
            view(ActiveCustomers)
            {
                Caption = 'Active Customers';
                Filters = where("Blocked" = const(" "));
            }
            view(InactiveCustomers)
            {
                Caption = 'Inactive Customers';
                Filters = where("Blocked" = filter('All|Ship|Invoice'));
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
                    modify("Balance (LCY)")
                    { Visible = false; }
                    modify("Balance Due (LCY)")
                    { Visible = false; }
                    modify("Sales (LCY)")
                    { Visible = false; }
                    modify("Payments (LCY)")
                    { Visible = false; }
                    modify("Vehicle Model")
                    { Visible = false; }
                    modify("Customer Notes")
                    { Visible = false; }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        BlockedStyle := SetBlockedStyle();
    end;

    procedure SetBlockedStyle(): Text
    begin
        case Rec.Blocked of
            Rec.Blocked::All:
                exit('Subordinate');
            Rec.Blocked::Invoice:
                exit('Ambiguous');
            rec.Blocked::Ship:
                exit('Ambiguous');
        end;
        exit('');

        // if Rec.Blocked = Rec.Blocked::" " then begin
        //     BlockedStyle := 'Standard';
        //     BlockedStyleNo := 'StandardAccent';
        // end else
        //     if Rec.Blocked = Rec.Blocked::All then begin
        //         BlockedStyle := 'Subordinate';
        //         BlockedStyleNo := 'Subordinate';
        //     end else
        //         if Rec.Blocked = Rec.Blocked::Invoice then begin
        //             BlockedStyle := 'Ambiguous';
        //             BlockedStyleNo := 'Ambiguous';
        //         end else
        //             if Rec.Blocked = Rec.Blocked::Ship then begin
        //                 BlockedStyle := 'Ambiguous';
        //                 BlockedStyleNo := 'Ambiguous';
        //             end;
    end;

    var
        BlockedStyle: Text;

    // trigger OnOpenPage()
    // begin
    //     Rec.SetCurrentKey("No.");
    //     Rec.Ascending(true);
    //     Rec.SetRange(Blocked, Rec.Blocked::" ");
    //     // Rec.SetFilter("Blocked", '<>ALL');
    //     // Rec.SetView(StrSubstNo('sorting ("No.") order(ascending) where ("Blocked" = filter ())')); // I CAN'T GET THIS TO FILTER ON THE 'BLANK' VALUE (i.e. NOT BLOCKED)
    // end;
}