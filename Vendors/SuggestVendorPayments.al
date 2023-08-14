reportextension 50114 SuggestVendorPaymentsExt extends "Suggest Vendor Payments"
{
    requestpage
    {
        layout
        {
            modify(UseVendorPriority)
            { Importance = Standard; }
            modify("Available Amount (LCY)")
            { Importance = Standard; }
            modify(BalAccountType)
            { Importance = Standard; }
            modify(BalAccountNo)
            { Importance = Standard; }
        }
    }
}