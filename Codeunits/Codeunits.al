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

codeunit 50102 PostSalesInvoiceOrderNotes
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnInsertInvoiceHeaderOnAfterSalesInvHeaderTransferFields, '', true, true)]
    local procedure TransferOrderNotes(var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesHeader: Record "Sales Header")
    begin
        SalesInvoiceHeader."Order Notes" := SalesHeader."Order Notes"
    end;
}

codeunit 50103 PostPurchInvoiceOrderNotes
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterInsertPostedHeaders, '', true, true)]
    local procedure TransferOrderNotes(var PurchInvHeader: Record "Purch. Inv. Header"; var PurchaseHeader: Record "Purchase Header")
    begin
        PurchInvHeader."Order Notes" := PurchaseHeader."Order Notes"
    end;
}