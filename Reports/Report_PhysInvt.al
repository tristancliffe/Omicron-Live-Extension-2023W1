reportextension 50101 PhysInvtReportExt extends "Phys. Inventory List"
{
    RDLCLayout = './OmicronPhysInvtList.rdlc';
    dataset
    {

        add("Item Journal Line")
        {
            column(ShelfNo_ItemJournalLine; ShelfNo_ItemJournalLine)
            {
            }
        }
    }

}