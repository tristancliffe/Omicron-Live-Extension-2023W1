pageextension 50115 SalesOrderList extends "Sales Order List"
{
    layout
    {
        modify("Sell-to Customer No.")
        {
            StyleExpr = ShippedStatus;
            AboutTitle = 'Sales Order Colours';
            AboutText = 'Orders that have *completely shipped* are shown in **bold RED**. If *partially invoiced* they are shown in **bold GREEN**. If some other condition exists they are shown in **BLUE**. *Released* orders are shown as **RED**. Pre-paid invoices are shown in **YELLOW**. Other orders are shown as **BLACK**.';
        }
        modify(Status)
        { AboutTitle = 'Order Status'; AboutText = '**Open** means that the order is *NOT YET FINALISED*. This should mean the order hasn'' been placed, and can be modified. **Released** means that the order has been sent to the supplier, and whilst prices might change, the order is *essentially fixed*. **Pending Prepayment** means a prepayment invoice has been posted.'; }
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
            { ApplicationArea = All; Width = 14; }
        }
        addafter("Your Reference50380")
        {
            field("Order Notes1"; Rec."Order Notes")
            { ApplicationArea = All; }
        }
        moveafter("Sell-to Customer Name"; Amount, "Amount Including VAT")
        modify("Completely Shipped")
        { Visible = true; }
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
        addlast("O&rder")
        {
            action(PostedInvoices)
            {
                ApplicationArea = all;
                Caption = 'Posted Invoices';
                ToolTip = 'Opens the list of posted sales invoices';
                Image = PurchaseInvoice;
                RunObject = Page "Posted Sales Invoices";
            }
        }
        addlast(Promoted)
        {
            actionref(PostedInvoices_Promoted; PostedInvoices)
            { }
        }
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
                    if Rec."Shpfy Order Id" > 0 then
                        ShippedStatus := 'Strong'
                    else
                        if Rec.Status = Rec.Status::Released then
                            ShippedStatus := 'Attention'
                        else
                            if Rec.Status = Rec.Status::"Pending Prepayment" then
                                ShippedStatus := 'Ambiguous'
                            else
                                ShippedStatus := 'Standard';
    end;

    var
        ShippedStatus: Text;
}