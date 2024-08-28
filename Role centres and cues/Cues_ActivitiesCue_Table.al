tableextension 50110 ActivityCueTableExt extends "Activities Cue"
{
    fields
    {
        field(50100; OngoingPurchQuote; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Quote)));
            Caption = 'Ongoing Purchase Quotes';
            FieldClass = FlowField;
        }
        field(50101; CustomersOpen; Integer)
        {
            CalcFormula = count("Cust. Ledger Entry" where(Open = filter(true)));
            Caption = 'Open Customer Entries';
            FieldClass = FlowField;
        }
        field(50102; SuppliersOpen; Integer)
        {
            CalcFormula = count("Vendor Ledger Entry" where(Open = filter(true)));
            Caption = 'Open Vendor Entries';
            FieldClass = FlowField;
        }
        field(50103; "Pending Sales Invoice Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Amount Including VAT" where("Document Type" = filter(Invoice)));
            AutoFormatExpression = '£<precision, 0:0><standard format, 0>';  //GetAmountFormat();
            AutoFormatType = 11;
            Caption = 'Pending Sales Invoice Amount';
            //DecimalPlaces = 0 : 0;
        }
        field(50104; "Ongoing Purchase Credit Memos"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = filter("Credit Memo")));
            Caption = 'Ongoing Purch. Credit Memo';
            FieldClass = FlowField;
        }
        field(50105; "Ongoing Sales Credit Memos"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = filter("Credit Memo")));
            Caption = 'Ongoing Sales Credit Memo';
            FieldClass = FlowField;
        }
        field(50106; ItemsOnShopify; Integer)
        {
            Caption = 'Items On Shopify Shop';
            FieldClass = FlowField;
            CalcFormula = count("Shpfy Variant" where("Mapped By Item" = filter(true)));
        }
    }
}