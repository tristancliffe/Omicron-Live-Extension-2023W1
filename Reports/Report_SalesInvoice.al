reportextension 50103 OmicronSalesInvoiceExt extends "Standard Sales - Invoice"
{
    dataset
    {
        add(Line)
        {
            column(WorkDone_Line; "Work Done")
            { }
        }
        modify(Line)
        {
            trigger OnAfterAfterGetRecord()
            begin
                if (Line.Quantity = 0) and (PrintZeroQtyLines = false) then
                    CurrReport.Skip();
            end;
        }

    }
    requestpage
    {
        layout
        {
            addafter(DisplayAdditionalFeeNote)
            {
                field(PrintZeroQtyLines; PrintZeroQtyLines)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    rendering
    {
        layout("./OmicronSalesInvoice.docx")
        {
            Type = Word;
            LayoutFile = './OmicronSalesInvoice.docx';
            Caption = 'Omicron Sales Invoice';
            Summary = 'Omicron Standard Sales Invoice';
        }
        layout("./OmicronJobSalesInvoice.docx")
        {
            Type = Word;
            LayoutFile = './OmicronJobSalesInvoice.docx';
            Caption = 'Omicron Job Sales Invoice';
            Summary = 'Omicron Job Sales Invoice';
        }
    }

    var
        PrintZeroQtyLines: Boolean;
}
