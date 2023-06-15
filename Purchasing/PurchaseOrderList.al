pageextension 50109 PurchaseOrderListExt extends "Purchase Order List"
{
    layout
    {
        modify("Buy-from Vendor No.")
        { StyleExpr = StatusStyle; }
        modify("Buy-from Vendor Name")
        { StyleExpr = StatusStyle; }
        moveafter("Buy-from Vendor Name"; "Your Reference")
        modify("Your Reference")
        {
            ApplicationArea = All;
            Caption = 'Our reference';
            ToolTip = 'Add our reference here so we know something about the order';
            Visible = true;
            Editable = true;
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
        {
            Visible = false;
        }
        addafter("Amount Including VAT")
        {
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
        }
    }
    actions
    {
        modify("Create &Whse. Receipt_Promoted")
        { Visible = false; }
        modify("Send IC Purchase Order_Promoted")
        { Visible = false; }
    }

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Order Date", "No.");
        Rec.Ascending(false);
    end;

    trigger OnAfterGetRecord()
    begin
        SetStatusStyle();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetStatusStyle();
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
                    StatusStyle := 'Unfavorable'
                else
                    StatusStyle := 'Standard';
    end;

    var
        StatusStyle: Text;
}