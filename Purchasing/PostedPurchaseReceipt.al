pageextension 50233 PostedPurchaseReceiptExt extends "Posted Purchase Receipt"
{
    layout
    {
        addbefore("Posting Date")
        {
            field("Order Date"; Rec."Order Date")
            { ApplicationArea = All; Importance = Standard; }
        }
        addafter("Responsibility Center")
        {
            field("User ID"; Rec."User ID")
            { ApplicationArea = All; Importance = Standard; }
        }
        modify(BuyFromContactPhoneNo)
        { Importance = Standard; }
        modify(BuyFromContactMobilePhoneNo)
        { Importance = Standard; }
        modify(BuyFromContactEmail)
        { Importance = Standard; }
        modify("Order Address Code")
        { Importance = Additional; }
        modify("Purchaser Code")
        { Importance = Additional; }
        modify("Responsibility Center")
        { Importance = Additional; }
        addlast(factboxes)
        {
            part(ItemReplenishmentFactbox; "Item Replenishment FactBox")
            {
                ApplicationArea = All;
                Provider = PurchReceiptLines;
                SubPageLink = "No." = field("No.");
            }
        }
    }
}