reportextension 50100 ExcelQuoteExt extends "Job Quote"
{
    dataset
    {
        add("Job Planning Line")
        {
            column(WorkDone; "Work Done")
            { }
            column(Qty__to_Transfer_to_Invoice; "Qty. to Transfer to Invoice")
            { }
            column(Planning_Date; "Planning Date")
            { }
            column(Unit_Cost; "Unit Cost")
            { }
            column(InvoiceCost; InvoiceCost)
            { }
            column(Unit_Price; "Unit Price")
            { }
            column(InvoicePrice; InvoicePrice)
            { }
            column(VAT; VAT)
            { }
            column(InvoicePriceInclVAT; InvoicePriceInclVAT)
            { }
        }
        modify("Job Planning Line")
        {
            trigger OnAfterAfterGetRecord()
            begin
                if Quantity <> 0 then
                    InvoicePrice := round(("Line Amount" / Quantity) * "Qty. to Transfer to Invoice", 0.01);
                InvoiceCost := round("Unit Cost" * "Qty. to Transfer to Invoice", 0.01);
                VAT := round(InvoicePrice * 0.2, 0.01);
                InvoicePriceInclVAT := round(InvoicePrice + VAT, 0.01);
                // "Planning Date" := format("Planning Date", 0, '<Day,2>/<Month,2>/<Year,2>');
            end;
        }
    }
    rendering
    {
        layout("Omicron Job Excel Quote")
        {
            Type = Excel;
            LayoutFile = './OmicronJobQuoteExcel.xlsx';
            Caption = 'Excel Job Quote';
            Summary = 'Used to calculate handwritten invoices for jobs';
        }
        layout("Omicron Job Quote")
        {
            Type = RDLC;
            LayoutFile = './OmicronJobQuote.rdlc';
        }
        // layout("Omicron Time Sheet Records")
        // {
        //     Type = Word;
        //     LayoutFile = './OmicronTimeSheetRecords.docx';
        //     Caption = 'Time Sheet History';
        //     Summary = 'Print off all billable job entries';
        // }

    }
}