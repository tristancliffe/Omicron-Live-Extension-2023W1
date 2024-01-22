pageextension 50109 PurchaseOrderListExt extends "Purchase Order List"
{
    AboutTitle = 'Purchase Orders';
    AboutText = 'This page shows the current orders. There is a basic colour code system, and an "Order Status" of ''Open'' or ''Released''. Click next to see more info on OPEN AND RELEASED...';
    layout
    {
        modify("Buy-from Vendor No.")
        { StyleExpr = StatusStyle; }
        modify("Buy-from Vendor Name")
        { StyleExpr = StatusStyle; AboutTitle = 'Colour Codes'; AboutText = 'When an order is *Released* it will become **BLUE**. When an order is *partially invoiced* it will become **RED**. When an order is *completely received* it will become **GREEN**. When an order is *partially invoiced and completely received* it will be **BLACK**. If the order has been pre-paid it will be shown in **RED**.'; }
        moveafter("Buy-from Vendor Name"; "Your Reference", "Amount", Status, "Document Date", "Amount Received Not Invoiced (LCY)", "Amount Including VAT", "Currency Code", "Assigned User ID")
        modify(Status)
        { AboutTitle = 'Order Statuses'; AboutText = '**Open** means that the order is *NOT YET FINALISED*. This should mean the order hasn'' been placed, and can be modified. **Released** means that the order has been sent to the supplier, and whilst prices might change, the order is *essentially fixed*. **Pending Prepayment** means a prepayment invoice has been posted.'; }
        modify("Your Reference")
        {
            ApplicationArea = All;
            Caption = 'Our reference';
            ToolTip = 'Add our reference here so we know something about the order';
            Visible = true;
            Editable = true;
            Width = 35;
        }
        // addafter("Buy-from Vendor Name")
        // {
        //     field("Your Reference"; Rec."Your Reference")
        //     {
        //         ApplicationArea = All;
        //         Caption = 'Our reference';
        //         ToolTip = 'Add our reference here so we know something about the order';
        //         Visible = true;
        //         Editable = true;
        //     }
        // }
        modify("Vendor Authorization No.")
        { Visible = false; }
        addafter("Currency Code")
        {
            field(TotalAmountLCY; TotalAmountLCY)
            {
                ApplicationArea = Suite;
                Caption = 'Total LCY';
                Editable = false;
                AutoFormatExpression = Currency.Code;
                AutoFormatType = 1;
                Width = 8;
            }
            field("Completely Received"; Rec."Completely Received")
            {
                ApplicationArea = All;
                Caption = 'Completely Received';
                Visible = true;
            }
            field("Partially Invoiced"; Rec."Partially Invoiced")
            {
                ApplicationArea = All;
                Caption = 'Partially Invoiced';
                Visible = true;
            }
            field("Expected Receipt Date"; Rec."Expected Receipt Date")
            { ApplicationArea = All; Visible = true; StyleExpr = OverdueStyle; }
        }
        moveafter("Expected Receipt Date"; "Payment Method Code")
        modify("Payment Method Code")
        { Visible = true; }
        modify("Location Code")
        { Visible = false; }
        modify("Currency Code")
        { Visible = true; Width = 7; }
    }
    actions
    {
        modify("Create &Whse. Receipt_Promoted")
        { Visible = false; }
        modify("Send IC Purchase Order_Promoted")
        { Visible = false; }
        addlast("O&rder")
        {
            action(PostedInvoices)
            {
                ApplicationArea = all;
                Caption = 'Posted Invoices';
                ToolTip = 'Opens the list of posted purchase invoices';
                Image = PurchaseInvoice;
                RunObject = Page "Posted Purchase Invoices";
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
        Rec.SetCurrentKey("Order Date", "No.");
        Rec.Ascending(false);
    end;

    trigger OnAfterGetRecord()
    begin
        SetStatusStyle();
        SetOverdueStyle();
        UpdateTotalLCY();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetStatusStyle();
        SetOverdueStyle();
    end;

    procedure SetStatusStyle()
    begin
        StatusStyle := 'Standard';
        if (Rec."Completely Received" = true) AND (Rec."Partially Invoiced" = true) then
            StatusStyle := 'Strong'
        else
            if Rec."Completely Received" = true then
                StatusStyle := 'Favorable'
            else
                if Rec."Partially Invoiced" = true then
                    StatusStyle := 'Attention'
                else
                    if Rec.Status = Rec.Status::Released then
                        StatusStyle := 'StrongAccent'
                    else
                        if Rec.Status = Rec.Status::"Pending Prepayment" then
                            StatusStyle := 'Unfavorable'
                        else
                            StatusStyle := 'Standard';
    end;

    procedure SetOverdueStyle()
    begin
        OverdueStyle := 'Standard';
        if Rec."Expected Receipt Date" < Today then
            OverdueStyle := 'Unfavorable';
    end;

    var
        StatusStyle: Text;
        OverdueStyle: Text;
        TotalAmountLCY: Decimal;
        Currency: Record Currency;

    local procedure UpdateTotalLCY()
    begin
        if Rec."Currency Factor" <> 0 then
            TotalAmountLCY := Rec."Amount Including VAT" / Rec."Currency Factor"
        else
            TotalAmountLCY := Rec."Amount Including VAT";
    end;
}