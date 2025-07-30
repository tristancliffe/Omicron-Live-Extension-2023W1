pageextension 50140 PostedSalesInvoiceExt extends "Posted Sales Invoice"
{
    layout
    {
        moveafter("Sell-to Customer Name"; "Your Reference")
        modify("External Document No.") { Importance = Standard; Visible = true; }
        modify("Document Date") { Visible = true; Importance = Standard; }
        modify("VAT Reporting Date") { Visible = true; Importance = Standard; }
        modify("Posting Date") { Visible = true; Importance = Standard; }
        modify("No. Printed") { Visible = true; Importance = Standard; }
        modify(Cancelled) { Visible = true; Importance = Standard; }
        modify(Corrective) { Visible = true; Importance = Standard; }
        modify(Closed) { Visible = true; Importance = Standard; }
        modify("Your Reference") { Importance = Standard; ShowMandatory = true; QuickEntry = true; }
        addafter("Sell-to Country/Region Code")
        {
            field("Sell-to Phone No."; Rec."Sell-to Phone No.") { ApplicationArea = All; }
            field("Sell-to E-Mail"; Rec."Sell-to E-Mail") { ApplicationArea = All; }
        }
        addafter("Your Reference")
        {
            field(OrderNotes; Rec."Order Notes") { ApplicationArea = All; }
        }
        addafter(IncomingDocAttachFactBox)
        {
            part(Control1903720907; "Sales Hist. Sell-to FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = field("Sell-to Customer No.");
            }
            part(VendorListFactbox; "Item Vendor List Factbox")
            {
                ApplicationArea = All;
                Visible = true;
                Provider = SalesInvLines;
                SubPageLink = "Item No." = FIELD("No.");
                SubPageView = sorting("Vendor No.", "Vendor Item No.");
            }
        }
        modify("Quote No.")
        {
            trigger OnDrillDown()
            var
                SalesHeaderArchive: Record "Sales Header Archive";
            begin
                SalesHeaderArchive.SetRange("No.", Rec."Quote No.");
                PAGE.RunModal(PAGE::"Sales Quote Archives", SalesHeaderArchive);
            end;
        }
        modify("Order No.")
        {
            trigger OnDrillDown()
            var
                SalesOrderArchive: Record "Sales Header Archive";
            begin
                SalesOrderArchive.SetRange("No.", Rec."Order No.");
                PAGE.RunModal(PAGE::"Sales Order Archives", SalesOrderArchive);
            end;
        }
    }
}