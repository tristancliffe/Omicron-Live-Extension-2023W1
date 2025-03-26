reportextension 50101 PhysInvtReportExt extends "Phys. Inventory List"
{
    dataset
    {
        add("Item Journal Line")
        {
            column(ShelfNo_ItemJournalLine; ShelfNo_ItemJournalLine) { }
            column(AssemblyBOM; AssemblyBOM) { }
        }
        modify("Item Journal Line")
        {
            trigger OnAfterAfterGetRecord()
            var
                Item: Record "Item";
            begin
                if "Item No." <> '' then begin
                    if Item.Get("Item No.") then begin
                        if Item."Replenishment System" = Item."Replenishment System"::Assembly then
                            AssemblyBOM := true
                        else
                            AssemblyBOM := false;
                    end
                end;
            end;
        }
    }
    requestpage
    {
        trigger OnOpenPage()
        begin
            ShowQtyCalculated := true;
        end;
    }
    rendering
    {
        layout("./OmicronPhysInvtList.rdlc")
        {
            Type = RDLC;
            LayoutFile = './OmicronPhysInvtList.rdlc';
            Caption = 'Omicron Physical Inventory List';
            Summary = 'Omicron Physical Inventory List Report';
        }
    }

}