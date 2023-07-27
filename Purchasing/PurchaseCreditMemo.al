pageextension 50110 PurchaseCreditExt extends "Purchase Credit Memo"
{
    layout
    {
        modify("Document Date")
        {
            Visible = true;
            Importance = Standard;
        }
        modify("VAT Reporting Date")
        {
            Visible = true;
            Importance = Standard;
        }
        modify("Buy-from Vendor No.")
        { Importance = Standard; }
        modify("Payment Method Code")
        { Importance = Standard; ShowMandatory = true; }
        modify("Currency Code")
        { Importance = Standard; }
    }
    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    Rec.Validate("Posting Date", Today);
                    Rec.Modify();
                end;
            end;
        }
        modify(PostAndPrint)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    Rec.Validate("Posting Date", Today);
                    Rec.Modify();
                end;
            end;
        }
        modify(PostAndNew)
        {
            trigger OnBeforeAction()
            begin
                if rec."Posting Date" = 0D then begin
                    Rec.Validate("Posting Date", Today);
                    Rec.Modify();
                end;
            end;
        }
    }
}