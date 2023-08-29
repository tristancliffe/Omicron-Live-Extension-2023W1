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
    layout
    {
        modify("No.")
        { StyleExpr = BlockedStyleNo; }
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
        { StyleExpr = BlockedStyleNo; }
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
        case Rec.Blocked of
            Rec.Blocked::" ":
                begin
                    BlockedStyle := 'Standard';
                    BlockedStyleNo := 'StandardAccent';
                end;
            Rec.Blocked::All:
                begin
                    BlockedStyle := 'Subordinate';
                    BlockedStyleNo := 'Subordinate';
                end;
            Rec.Blocked::Invoice:
                begin
                    BlockedStyle := 'Ambiguous';
                    BlockedStyleNo := 'Ambiguous';
                end;
            rec.Blocked::Ship:
                begin
                    BlockedStyle := 'Ambiguous';
                    BlockedStyleNo := 'Ambiguous';
                end;
        end;

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
        BlockedStyleNo: Text;

    // trigger OnOpenPage()
    // begin
    //     Rec.SetCurrentKey("No.");
    //     Rec.Ascending(true);
    //     Rec.SetRange(Blocked, Rec.Blocked::" ");
    //     // Rec.SetFilter("Blocked", '<>ALL');
    //     // Rec.SetView(StrSubstNo('sorting ("No.") order(ascending) where ("Blocked" = filter ())')); // I CAN'T GET THIS TO FILTER ON THE 'BLANK' VALUE (i.e. NOT BLOCKED)
    // end;
}