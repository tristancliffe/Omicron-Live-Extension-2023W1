pageextension 50191 RegisterCustomerPaymentsExt extends "Payment Registration"
{
    AboutTitle = 'Customer Payment Colours';
    AboutText = 'The colours on the list show if an amount is negative [we owe them] (**red**) or positive [they owe us] (**black**).';
    layout
    {
        modify("Source No.")
        { Visible = true; Caption = 'Account No.'; }
        addafter("Amount Received")
        {
            field("Payment Method Code"; Rec."Payment Method Code")
            { ApplicationArea = All; Visible = true; }
        }
        moveafter("Payment Method Code"; "Document Type")
        modify("Document Type")
        { Visible = true; }
        modify("Remaining Amount")
        { StyleExpr = BalanceColours; }
    }

    var
        BalanceColours: Text;

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Due Date");
        Rec.Ascending := true;
        // Rec.FindFirst
    end;

    trigger OnAfterGetRecord()
    begin
        SetBalanceColours();
    end;

    local procedure SetBalanceColours()
    begin
        BalanceColours := 'Standard';
        if Rec."Remaining Amount" < 1 then BalanceColours := 'Attention';
    end;
}