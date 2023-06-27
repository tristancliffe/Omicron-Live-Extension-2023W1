pageextension 50156 PurchaseInvoiceListExt extends "Purchase Invoices"
{
    layout
    {
        moveafter("Buy-from Vendor Name"; "Your Reference", "Vendor Invoice No.", Amount, Status)
        addafter(Status)
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
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
        { Visible = false; }
        modify("Assigned User ID")
        { Visible = true; }
        modify("Location Code")
        { Visible = false; }
        modify(Status)
        {
            ApplicationArea = All;
            Visible = true;
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Order Date", "No.");
        Rec.Ascending(false);
    end;
}