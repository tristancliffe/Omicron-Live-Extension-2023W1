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
            // action(VendorLedger)
            // {
            //     ApplicationArea = All;
            //     Image = VendorLedger;
            //     Caption = 'Vendor Ledger';
            //     RunObject = page "Vendor Ledger Entries";
            //     RunPageLink = "Vendor No." = field("Vendor No.");
            //     Description = 'Open the vendor list.';
            //     ToolTip = 'Opens the vendor ledger entries for this vendor.';
            //     Visible = true;
            //     Enabled = true;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedOnly = true;
            // }
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
}
