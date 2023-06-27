pageextension 50115 SalesOrderList extends "Sales Order List"
{
    layout
    {
        modify("Sell-to Customer No.")
        { StyleExpr = ShippedStatus; }
        modify("Sell-to Customer Name")
        { StyleExpr = ShippedStatus; }
        modify("External Document No.")
        { Visible = false; }
        modify("Location Code")
        { Visible = false; }
        modify("Sell-To Contact")
        { Visible = false; }
        addafter("Sell-to Customer Name")
        {
            field("Order Date98002"; Rec."Order Date")
            { ApplicationArea = All; }
            field("Your Reference50380"; Rec."Your Reference")
            {
                ApplicationArea = All;
                Width = 14;
            }
        }
        addafter("Your Reference50380")
        {
            field("Order Notes1"; Rec."Order Notes")
            { ApplicationArea = All; }
        }
        moveafter("Sell-to Customer Name"; Amount, "Amount Including VAT")
        modify("Completely Shipped")
        {
            Visible = true;
        }
        moveafter(Amount; Status)
        moveafter("Document Date"; "Completely Shipped")
        addafter("Completely Shipped")
        {
            field(InvoicedLineExists; Rec.InvoicedLineExists)
            { ApplicationArea = All; }
        }
        modify("Document Date")
        { Visible = false; }
    }
    actions
    {
        modify("Create Inventor&y Put-away/Pick_Promoted")
        { Visible = false; }
        modify("Create &Warehouse Shipment_Promoted")
        { Visible = false; }
    }
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        Rec.Ascending(false);
    end;

    trigger OnAfterGetRecord()
    begin
        SetShippedStatus();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetShippedStatus();
    end;

    procedure SetShippedStatus()
    begin
        ShippedStatus := 'Standard';
        if (Rec."Completely Shipped" = true) then
            ShippedStatus := 'Unfavorable'
        else
            if (Rec.InvoicedLineExists = true) then
                ShippedStatus := 'Favorable'
            else
                if rec.Ship = true then
                    ShippedStatus := 'StrongAccent'
                else
                    if Rec."Shpfy Order No." <> '' then
                        ShippedStatus := 'Strong'
                    else
                        if Rec.Status = Rec.Status::Released then
                            ShippedStatus := 'Attention'
                        else
                            ShippedStatus := 'Standard';
    end;

    var
        ShippedStatus: Text;
}