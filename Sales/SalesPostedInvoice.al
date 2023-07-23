pageextension 50140 PostedSalesInvoiceExt extends "Posted Sales Invoice"
{
    layout
    {
        modify("External Document No.")
        { Importance = Standard; Visible = true; }
        modify("Document Date")
        { Visible = true; Importance = Standard; }
        modify("VAT Reporting Date")
        { Visible = true; Importance = Standard; }
        modify("Posting Date")
        { Visible = true; Importance = Standard; }
        // modify(SellToPhoneNo)
        // {
        //     Importance = Standard;
        //     QuickEntry = false;
        //     Visible = true;
        // }
        // modify(SellToMobilePhoneNo)
        // {
        //     Importance = Standard;
        //     QuickEntry = false;
        //     Visible = true;
        // }
        // modify(SellToEmail)
        // {
        //     Importance = Standard;
        //     QuickEntry = false;
        //     Visible = true;
        // }
        modify("Your Reference")
        {
            Importance = Standard;
            ShowMandatory = true;
            QuickEntry = true;
        }
        addafter("Sell-to Country/Region Code")
        {
            field("Sell-to Phone No."; Rec."Sell-to Phone No.")
            { ApplicationArea = All; }
            field("Sell-to E-Mail"; Rec."Sell-to E-Mail")
            { ApplicationArea = All; }
        }
        addafter("Your Reference")
        {
            field(OrderNotes; Rec."Order Notes")
            { ApplicationArea = All; }
        }
    }
}