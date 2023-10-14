reportextension 50101 PhysInvtReportExt extends "Phys. Inventory List"
{
    dataset
    {

        add("Item Journal Line")
        {
            column(ShelfNo_ItemJournalLine; ShelfNo_ItemJournalLine)
            {
            }
        }
    }

    rendering
    {
        layout("./OmicronPhysInvtList.rdlc")
        {
            Type = RDLC;
            LayoutFile = './OmicronPhysInvtList.rdlc';
            Caption = 'Omicron Physical Inventory List';
            Summary = 'Omicron Physical Inventory List';
        }
    }

}