pageextension 50170 PostedPurchInvoiceExt extends "Posted Purchase Invoice"
{
    layout
    {
        movebefore("Buy-from Contact"; "Buy-from Contact No.")
        addafter("Buy-from Vendor Name")
        {
            field("Your Reference"; Rec."Your Reference")
            { ApplicationArea = All; QuickEntry = true; }
        }
        moveafter("Your Reference"; "Vendor Invoice No.", "Payment Method Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")
        modify("Vendor Invoice No.")
        { Visible = true; Importance = Standard; }
        modify("Document Date")
        { Visible = true; Importance = Standard; }
        modify("Due Date")
        { Visible = true; Importance = Standard; }
        modify("Posting Date")
        { Visible = true; Importance = Standard; }
        modify("VAT Reporting Date")
        { Visible = true; Importance = Standard; }
        modify("Purchaser Code")
        { Visible = false; }
        modify("Payment Method Code")
        { Importance = Standard; }
        modify(BuyFromContactMobilePhoneNo)
        { Importance = Standard; }
        modify(BuyFromContactPhoneNo)
        { Importance = Standard; }
        modify(BuyFromContactEmail)
        { Importance = Standard; }
        modify("Currency Code")
        { Importance = Standard; }
        addafter("Your Reference")
        {
            field("Order Notes"; Rec."Order Vendor Notes") //* changed to order vendor notes due to mistake in table field numbering
            { ApplicationArea = All; }
        }
        addafter(IncomingDocAttachFactBox)
        {
            part(VendorListFactbox; "Item Vendor List Factbox")
            {
                ApplicationArea = All;
                Visible = true;
                Provider = PurchInvLines;
                SubPageLink = "Item No." = FIELD("No.");
                SubPageView = sorting("Vendor No.", "Vendor Item No.");
            }
            part(ItemReplenishmentFactbox; "Item Replenishment FactBox")
            {
                ApplicationArea = All;
                Provider = PurchInvLines;
                SubPageLink = "No." = field("No.");
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Amount Including VAT");
    end;
}

