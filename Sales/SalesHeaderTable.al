tableextension 50121 SalesHeaderExt extends "Sales Header"
{
    fields
    {
        modify("Sell-to Customer No.")
        {

            trigger OnAfterValidate()
            var
                RecCustomer: Record Customer;

            begin
                RecCustomer.SetRange("No.", Rec."Sell-to Customer No.");
                if RecCustomer.FindSet() then
                    Rec."Order Customer Notes" := RecCustomer."Customer Notes";
                Rec."Mobile No." := RecCustomer."Mobile Phone No.";
            end;
        }
        field(50100; "Order Customer Notes"; text[2000])
        {
            CaptionML = ENU = 'Customer Notes';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                RecCustomer: Record Customer;
            begin
                RecCustomer.SetRange("No.", Rec."Sell-to Customer No.");
                if RecCustomer.FindSet() then begin
                    RecCustomer."Customer Notes" := Rec."Order Customer Notes";
                    RecCustomer.Modify()
                end;
            end;
        }
        field(50101; "Order Notes"; text[250])
        { CaptionML = ENU = 'Order Notes'; DataClassification = CustomerContent; }
        field(50102; "Mobile No."; text[30])
        { CaptionML = ENU = 'Mobile Phone No.'; DataClassification = CustomerContent; }
    }

}