pageextension 50162 VendorLedgerEntriesExt extends "Vendor Ledger Entries"
{
    layout
    {
        moveafter(Description; "Due Date", "Remaining Amount", "Remaining Amt. (LCY)", "Payment Method Code", "Original Amount", "Amount (LCY)", "User ID", RunningBalanceLCY)
        modify("User ID") { Visible = true; ApplicationArea = All; }
        modify("Pmt. Discount Date") { Visible = false; }
        modify("Pmt. Disc. Tolerance Date") { Visible = false; }
        modify("Original Pmt. Disc. Possible") { Visible = false; }
        modify("Remaining Pmt. Disc. Possible") { Visible = false; }
        modify("Max. Payment Tolerance") { Visible = false; }
        modify("Exported to Payment File") { Visible = false; }
        modify("Payment Method Code") { Visible = true; }
        addafter("Due Date")
        {
            field(VendorPriority; Priority) { ApplicationArea = All; Caption = 'Priority'; ToolTip = 'Vendor payment priority'; BlankZero = true; Editable = false; }
        }
        modify("Vendor Name") { StyleExpr = TypeStyle; }
        modify(Description) { StyleExpr = TypeStyle; }
        moveafter("Document Type"; Reversed)
        modify(Reversed) { Visible = true; }
        modify("Document No.") { Visible = false; }
        modify(RunningBalanceLCY) { Visible = true; }
        moveafter("Entry No."; "Message to Recipient")
        modify("Message to Recipient") { Visible = true; }
        addbefore("Remit-to Code")
        {
            field(SystemCreatedAt; Rec.SystemCreatedAt) { ApplicationArea = All; Visible = true; Caption = 'Posted At'; }
            field(SystemCreatedBy; GetFullName(Rec.SystemCreatedBy)) { ApplicationArea = All; Visible = true; Caption = 'Posted By'; }
        }
    }

    actions
    {
        addlast("F&unctions")
        {
            action(VendorList)
            {
                ApplicationArea = All;
                Image = Vendor;
                Caption = 'Vendor List';
                RunObject = page "Vendor List";
                Description = 'Open the vendor list.';
                ToolTip = 'Opens the vendor ledger entries for this vendor.';
                Visible = true;
                Enabled = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Scope = Repeater;
            }
            action(PostedInvoices)
            {
                ApplicationArea = All;
                Caption = 'Posted Invoices';
                Image = PurchaseInvoice;
                RunObject = Page "Posted Purchase Invoices";
                RunPageLink = "Buy-from Vendor No." = field("Vendor No.");
                RunPageView = sorting("Buy-from Vendor No.", "Order No.");
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Scope = Repeater;
                ToolTip = 'View all posted invoices for this vendor.';
            }
            action(PurchaseOrders)
            {
                ApplicationArea = All;
                Caption = 'Purchase Orders';
                Image = Purchase;
                RunObject = Page "Purchase Order List";
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Go to list of current purchase orders';
            }
        }
    }
    views
    {
        addfirst
        {
            view(BACS) { Caption = 'BACS'; Filters = where("Document Type" = filter(Invoice | "Credit Memo"), Open = const(true), "Payment Method Code" = filter('BACS|CASH|CHQ|PETTY')); ; }
            view(CREDITCARD) { Caption = 'Creditcard'; Filters = where("Document Type" = filter(Invoice | "Credit Memo"), Open = const(true), "Payment Method Code" = filter('CREDITCARD')); ; }
            view(ANDREW) { Caption = 'Andrew'; Filters = where("Document Type" = filter(Invoice | "Credit Memo"), Open = const(true), "Payment Method Code" = filter('ANDREW')); ; }
        }
    }

    var
        Priority: Integer;
        TypeStyle: Text;

    trigger OnAfterGetRecord()
    begin
        GetPriority();
        TypeStyle := SetTypeStyle();
    end;

    // trigger OnAfterGetCurrRecord()
    // begin
    //     GetPriority();
    // end;

    local procedure GetPriority()
    var
        VendorRec: Record Vendor;
    begin
        if VendorRec.Get(rec."Vendor No.") then begin
            Priority := VendorRec.Priority;
        end;
    end;

    local procedure SetTypeStyle(): Text
    begin
        if Rec."Document Type" <> Rec."Document Type"::Invoice then
            exit('Ambiguous');
        exit('');
    end;

    procedure GetFullName(userID: Guid): Text
    var
        UserInfo: Record User;
    begin
        if not UserInfo.Get(userID) then
            exit('');
        exit(UserInfo."Full Name");
    end;
}