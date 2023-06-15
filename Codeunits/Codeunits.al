codeunit 50100 ChangeStatusColour
{
    procedure ChangeLineStatusColour(Line: Record "Time Sheet Line"): Text[50]
    begin
        case Line.Status of
            Line.status::Approved:
                exit('favorable');
            Line.Status::Open:
                exit('standard');
            Line.Status::Rejected:
                exit('unfavorable');
            Line.Status::Submitted:
                exit('standardaccent');
        end;
    end;
}

codeunit 50101 ItemLedgerReasons
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnBeforeInsertItemLedgEntry, '', true, true)]
    local procedure TransferProdPostGroup(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    begin
        ItemLedgerEntry.ReasonCode := ItemJournalLine."Reason Code";
    end;
}