tableextension 50114 PurchaseHeaderExt extends "Purchase Header"
{
    fields
    {
        modify("Buy-from Vendor No.")
        {

            trigger OnAfterValidate()
            var
                RecVendor: Record Vendor;
            begin
                RecVendor.SetRange("No.", Rec."Buy-from Vendor No.");
                if RecVendor.FindSet() then
                    Rec."Order Vendor Notes" := RecVendor."Vendor Notes";
            end;
        }
        field(50100; "Order Vendor Notes"; text[1000])
        {
            CaptionML = ENU = 'Vendor Notes';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                RecVendor: Record Vendor;
            begin
                RecVendor.SetRange("No.", Rec."Buy-from Vendor No.");
                if RecVendor.FindSet() then begin
                    RecVendor."Vendor Notes" := Rec."Order Vendor Notes";
                    RecVendor.Modify()
                end;
            end;
        }
        field(50101; "Order Notes"; text[250])
        {
            CaptionML = ENU = 'Order Notes';
            DataClassification = CustomerContent;
        }
    }
}