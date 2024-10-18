pageextension 50199 PaymentJournalExt extends "Payment Journal"
{
    layout
    {
        moveafter("Posting Date"; "Document Date")
        modify("Document Date")
        { Visible = true; width = 10; }
        modify("Recipient Bank Account")
        { QuickEntry = false; }
        modify("Message to Recipient")
        { QuickEntry = false; }
        modify("Currency Code")
        { QuickEntry = false; }
        modify("Payment Reference")
        { QuickEntry = false; }
        modify("Creditor No.")
        { QuickEntry = false; }
        modify("Bank Payment Type")
        { Visible = false; }
        modify("Exported to Payment File")
        { Visible = false; }
        modify("Has Payment Export Error")
        { Visible = false; }
        modify("Remit-to Code")
        { Visible = false; }
        addafter("Number of Lines")
        {
            group("Sum of Lines")
            {
                Caption = 'Sum of Lines';
                field(SumOfLines; Rec.SumOfLines)
                { ApplicationArea = All; Visible = true; ShowCaption = false; Editable = false; AutoFormatType = 1; }
            }

        }
    }
    actions
    {
        addlast(processing)
        {
            action(ChartOfAccounts)
            {
                ApplicationArea = All;
                Image = GeneralLedger;
                Caption = 'G/L Account';
                RunObject = page "G/L Account Card";
                RunPageLink = "No." = field("Account No.");
                Description = 'Go to the General Ledger account card';
                ToolTip = 'Opens the general ledger account card for this line';
                Scope = Repeater;
                Visible = true;
                Enabled = rec."Account Type" = Rec."Account Type"::"G/L Account";
            }
            action(VendorLink)
            {
                ApplicationArea = All;
                Image = Vendor;
                Caption = 'Vendor Card';
                RunObject = page "Vendor Card";
                RunPageLink = "No." = field("Account No.");
                Description = 'Go to the Vendor card';
                ToolTip = 'Opens the Vendor account card for this line';
                Scope = Repeater;
                Visible = true;
                Enabled = rec."Account Type" = Rec."Account Type"::Vendor;
                ;
            }
            action(CustomerLink)
            {
                ApplicationArea = All;
                Image = Customer;
                Caption = 'Customer Card';
                RunObject = page "Customer Card";
                RunPageLink = "No." = field("Account No.");
                Description = 'Go to the Customer card';
                ToolTip = 'Opens the Customer account card for this line';
                Scope = Repeater;
                Visible = true;
                Enabled = rec."Account Type" = Rec."Account Type"::Customer;
            }
        }
        addlast(Category_Process)
        {
            actionref(SuggestVendorPaymentsPromoted; SuggestVendorPayments)
            { }
            actionref(CalcPostingDates; CalculatePostingDate)
            { }
        }
    }
}