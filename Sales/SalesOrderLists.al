pageextension 50115 SalesOrderList extends "Sales Order List"
{
    layout
    {
        modify("Sell-to Customer No.")
        {
            StyleExpr = ShippedStatusStyle;
            AboutTitle = 'Sales Order Colours';
            AboutText = 'Orders that have *completely shipped* are shown in **bold RED**. If *partially invoiced* they are shown in **bold GREEN**. If some other condition exists they are shown in **BLUE**. *Released* orders are shown as **RED**. Pre-paid invoices are shown in **YELLOW**. Other orders are shown as **BLACK**.';
        }
        modify(Status)
        { AboutTitle = 'Order Status'; AboutText = '**Open** means that the order is *NOT YET FINALISED*. This should mean the order hasn'' been placed, and can be modified. **Released** means that the order has been sent to the supplier, and whilst prices might change, the order is *essentially fixed*. **Pending Prepayment** means a prepayment invoice has been posted.'; }
        modify("Sell-to Customer Name")
        { StyleExpr = ShippedStatusStyle; }
        modify("External Document No.")
        { Visible = false; }
        modify("Location Code")
        { Visible = false; }
        modify("Sell-To Contact")
        { Visible = false; }
        moveafter("Sell-to Customer Name"; Amount, Status, "Amount Including VAT", "Your Reference")
        modify("Your Reference")
        { Width = 14; Visible = true; }
        addafter("Amount Including VAT")
        {
            field("Order Date"; Rec."Order Date")
            { ApplicationArea = All; StyleExpr = OrderDateStyle; }
        }
        addafter("Your Reference")
        {
            field("Order Notes"; Rec."Order Notes")
            { ApplicationArea = All; }
        }
        modify("Completely Shipped")
        { Visible = true; }
        moveafter("Document Date"; "Completely Shipped")
        addafter("Completely Shipped")
        {
            field(InvoicedLineExists; Rec.InvoicedLineExists)
            { ApplicationArea = All; Caption = 'Invoiced Lines Exist'; Visible = false; }
        }
        modify("Document Date")
        { Visible = false; }
        addbefore("Completely Shipped")
        {
            field("Partially Shipped"; Rec."Partially Shipped")
            {
                StyleExpr = PartiallyShippedStyle;
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter(Status)
        {
            field("Attachments Exist"; Rec."Attachments Exist")
            { ApplicationArea = All; Width = 2; DrillDown = false; Editable = false; }
        }
        addbefore(Control1902018507)
        {
            part(SalesOrderDetailFactbox; "Sales Order Detail Factbox") { ApplicationArea = Basic, Suite; SubPageLink = "No." = field("No."); }
            part(SalesOrderLinesFactbox; "Sales Order Lines Factbox") { ApplicationArea = All; Visible = true; SubPageLink = "Document No." = FIELD("No."); }
        }
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
                ToolTip = 'Opens the list of posted sales invoices for all customers';
                Image = SalesInvoice;
                RunObject = Page "Posted Sales Invoices";
            }
            action(CustomerInvoices)
            {
                ApplicationArea = All;
                Caption = 'Invoices';
                ToolTip = 'Open a list of posted invoices for this customer';
                Image = SalesInvoice;
                Scope = Repeater;
                RunObject = page "Posted Sales Invoices";
                RunPageLink = "Sell-to Customer No." = field("Sell-to Customer No.");
            }
            action(CustomerLedger)
            {
                ApplicationArea = All;
                Caption = 'Ledger';
                Tooltip = 'Open the customer ledger entries list for this customer';
                image = LedgerEntries;
                Scope = Repeater;
                RunObject = page "Customer Ledger Entries";
                RunPageLink = "Customer No." = field("Sell-to Customer No.");
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
        ShippedStatusStyle := SetShippedStatus();
        PartiallyShippedStyle := SetPartiallyShippedStyle();
        OrderDateStyle := CheckOrderDate();
    end;

    procedure SetPartiallyShippedStyle(): Text
    begin
        if (Rec.InvoicedLineExists = true) or (Rec."Partially Shipped" = true) then
            exit('Unfavorable');
        exit('');
    end;

    procedure SetShippedStatus(): Text
    begin
        //ShippedStatusStyle := 'Standard';
        if (Rec."Completely Shipped" = true) then
            exit('Unfavorable')
        else
            if (Rec.InvoicedLineExists = true) or (Rec."Partially Shipped" = true) then
                exit('Favorable')
            else
                if rec.Ship = true then
                    exit('StrongAccent')
                else
                    if Rec."Shpfy Order Id" > 0 then
                        exit('Strong')
                    else
                        if Rec.Status = Rec.Status::Released then
                            exit('Attention')
                        else
                            if Rec.Status = Rec.Status::"Pending Prepayment" then
                                exit('Ambiguous');
        exit('')
    end;

    procedure CheckOrderDate(): Text;
    begin
        if Rec."Order Date" < CalcDate('-12M', Today()) then
            exit('Unfavorable');
        exit('');
    end;

    var
        ShippedStatusStyle: Text;
        PartiallyShippedStyle: Text;
        OrderDateStyle: Text;
        TodayDate: Date;
        MaxOrderDate: Date;
}