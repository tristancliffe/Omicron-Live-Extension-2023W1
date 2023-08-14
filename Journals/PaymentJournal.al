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
                Enabled = true;
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