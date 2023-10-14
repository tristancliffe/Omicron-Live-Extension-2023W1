reportextension 50111 AssemblyOrderReportExt extends "Assembly Order"
{
    dataset
    {
        add("Assembly Line")
        {
            column(Instock_AssemblyLine; "Assembly Line".Instock_AssemblyLine)
            { }
            column(ShelfNo_AssemblyLine; "Assembly Line".ShelfNo_AssemblyLine)
            { }
        }
    }
    rendering
    {
        layout(".OmicronAssemblyOrder.rdlc")
        {
            Type = RDLC;
            LayoutFile = './OmicronAssemblyOrder.rdlc';
            Caption = 'Omicron Assembly Order';
            Summary = 'Omicron Assembly Order';
        }
    }
}