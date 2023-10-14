reportextension 50116 OmicronSalesProformaExt extends "Standard Sales - Pro Forma Inv"
{
    dataset
    {
        add(Header)
        {
            column(BilltoCustomerNo_Header; "Bill-to Customer No.")
            { }
        }
        add(Line)
        {
            column(No_Line; "No.")
            { }
            column(UnitofMeasure_Line; "Unit of Measure")
            { }
        }
    }
    rendering
    {
        layout("./OmicronSalesProForma.docx")
        {
            Type = Word;
            LayoutFile = './OmicronSalesProForma.docx';
            Caption = 'Omicron Pro-Forma Sales Invoice';
            Summary = 'Omicron Pro-Forma Sales Invoice';
        }
    }
}
