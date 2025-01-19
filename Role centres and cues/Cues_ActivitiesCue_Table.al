tableextension 50110 ActivityCueTableExt extends "Activities Cue"
{
    fields
    {
        field(50100; OngoingPurchQuote; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Quote)));
            Caption = 'Ongoing Purchase Quotes';
            FieldClass = FlowField;
            ToolTip = 'Specifies purchases quotes that are active';
        }
        field(50101; CustomersOpen; Integer)
        {
            CalcFormula = count("Cust. Ledger Entry" where(Open = filter(true)));
            Caption = 'Open Customer Entries';
            FieldClass = FlowField;
            ToolTip = 'Specifies number of ''Open'' customer ledger entries';
        }
        field(50102; SuppliersOpen; Integer)
        {
            CalcFormula = count("Vendor Ledger Entry" where(Open = filter(true)));
            Caption = 'Open Vendor Entries';
            FieldClass = FlowField;
            ToolTip = 'Specifies number of ''Open'' vendor ledger entries';
        }
        field(50103; "Pending Sales Invoice Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Amount Including VAT" where("Document Type" = filter(Invoice)));
            AutoFormatExpression = '£<precision, 0:0><standard format, 0>';  //GetAmountFormat();
            AutoFormatType = 11;
            Caption = 'Pending Sales Invoice Amount';
            ToolTip = 'Specifies the sum of sales invoices to be sent.';
            //DecimalPlaces = 0 : 0;
        }
        field(50104; "Ongoing Purchase Credit Memos"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = filter("Credit Memo")));
            Caption = 'Ongoing Purch. Credit Memo';
            FieldClass = FlowField;
            ToolTip = 'Specifies purchases credit memos that are active';
        }
        field(50105; "Ongoing Sales Credit Memos"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = filter("Credit Memo")));
            Caption = 'Ongoing Sales Credit Memo';
            FieldClass = FlowField;
            ToolTip = 'Specifies sales credit memos that are active';
        }
        field(50106; ItemsOnShopify; Integer)
        {
            Caption = 'Items On Shopify Shop';
            FieldClass = FlowField;
            CalcFormula = count("Shpfy Variant" where("Mapped By Item" = filter(true)));
            ToolTip = 'Number of items listed on Shopify';
        }
        field(50107; "Due This Week Filter"; Date)
        {
            Caption = 'Due Next Week Filter';
            FieldClass = FlowFilter;
        }
        field(50108; "Purch. Invoices Due This Week"; Integer)
        {
            CalcFormula = count("Vendor Ledger Entry" where("Document Type" = filter(Invoice | "Credit Memo"),
                                                             "Due Date" = field("Due This Week Filter"),
                                                             Open = const(true),
                                                             "Payment Method Code" = filter('BACS|CASH|CHQ|PETTY')));
            Caption = 'Purch. Invoices Due This Week';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the number of payments to vendors that are due this week.';
        }
    }
}