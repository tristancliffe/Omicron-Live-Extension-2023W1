tableextension 50114 PurchaseHeaderExt extends "Purchase Header"
{
    DataCaptionFields = "No.", "Buy-from Vendor Name", "Amount Including VAT";
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
                Rec."Preferred Payment Method" := RecVendor."Preferred Payment Method";
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
        field(50102; "Preferred Payment Method"; Text[50]) //! Remove this
        {
            CaptionML = ENG = 'Preferred Payment Method';
            DataClassification = CustomerContent;
        }
        field(50103; "Partially Received"; Boolean)
        {
            //DataClassification = CustomerContent;
            Caption = 'Partially Received';
            FieldClass = FlowField;
            CalcFormula = exist("Purchase Line" where("Document Type" = field("Document Type"),
                                                       "Document No." = field("No."),
                                                       Type = filter(<> " "),
                                                       "Location Code" = field("Location Filter"),
                                                       "Quantity Received" = filter(<> 0)));
        }
        field(50104; "Has Job Lines"; Boolean)
        {
            Caption = 'Job';
            FieldClass = FlowField;
            CalcFormula = exist("Purchase Line" where("Document Type" = field("Document Type"),
                                                       "Document No." = field("No."),
                                                       Type = filter(<> " "),
                                                       "Location Code" = field("Location Filter"),
                                                       "Job No." = filter(<> '')));
            ToolTip = 'This order has lines linked to a project';
        }
        field(50105; "Attachments Exist"; Boolean)
        {
            Caption = 'Files';
            FieldClass = FlowField;
            CalcFormula = exist("Purchase Line" where("Document Type" = field("Document Type"),
                                                       "Document No." = field("No."),
                                                       Type = filter(<> " "),
                                                       "Location Code" = field("Location Filter"),
                                                       "Attached Doc Count" = filter(<> 0)));
            ToolTip = 'This order has line(s) with attachments.';
        }
    }
}