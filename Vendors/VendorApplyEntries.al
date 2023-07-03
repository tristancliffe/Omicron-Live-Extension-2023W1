pageextension 50195 VendorApplyEntries extends "Apply Vendor Entries"
{
    layout
    {
        movebefore("Remaining Amount"; Amount)
        modify(Amount)
        {
            Visible = true;
            Caption = 'Orig. Amount';
        }
    }
}