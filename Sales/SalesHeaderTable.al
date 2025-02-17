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
                if RecCustomer.FindSet() then begin
                    Rec."Order Customer Notes" := RecCustomer."Customer Notes";
                    Rec."Mobile No." := RecCustomer."Mobile Phone No.";
                end;
            end;
        }
        field(50100; "Order Customer Notes"; text[2000])
        {
            //CaptionML = ENU = 'Customer Notes';
            Caption = 'Customer Notes';
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
        {
            CaptionML = ENU = 'Mobile Phone No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                RecCustomer: Record Customer;
            begin
                RecCustomer.SetRange("No.", Rec."Sell-to Customer No.");
                if RecCustomer.FindSet() then begin
                    RecCustomer."Mobile Phone No." := Rec."Mobile No.";
                    RecCustomer.Modify()
                end;
            end;
        }

        field(50103; "Partially Shipped"; Boolean)
        {
            //DataClassification = CustomerContent;
            Caption = 'Partially Shipped';
            FieldClass = FlowField;
            CalcFormula = exist("Sales Line" where("Document Type" = field("Document Type"),
                                                       "Document No." = field("No."),
                                                       Type = filter(<> " "),
                                                       "Location Code" = field("Location Filter"),
                                                       "Quantity Shipped" = filter(<> 0)));
        }
        field(50104; "Attachments Exist"; Boolean)
        {
            Caption = 'Files';
            FieldClass = FlowField;
            CalcFormula = exist("Sales Line" where("Document Type" = field("Document Type"),
                                                       "Document No." = field("No."),
                                                       Type = filter(<> " "),
                                                       "Location Code" = field("Location Filter"),
                                                       "Attached Doc Count" = filter(<> 0)));
            ToolTip = 'This order has line(s) with attachments.';
        }



        // field(50103; "Shopify Order Value"; Decimal)
        // { Caption = 'Shopify Order Value'; DataClassification = CustomerContent; DecimalPlaces = 2 : 2; }
    }
}