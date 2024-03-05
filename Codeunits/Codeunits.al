codeunit 50100 ChangeStatusColour
{
    procedure ChangeLineStatusColour(Line: Record "Time Sheet Line"): Text[50]
    begin
        case Line.Status of
            Line.status::Approved:
                exit('favorable');
            Line.Status::Rejected:
                exit('unfavorable');
            Line.Status::Submitted:
                exit('standardaccent');
        end;
        exit('');
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

// codeunit 50105 UpdateJobPlanningLines
// {
//     procedure UpdateLines(Rec: Record "Job Planning Line")
//     var
//     // Rec: Record "Job Planning Line";
//     begin
//         begin
//             if ((rec."Line Type" = Rec."Line Type"::Billable) or (rec."Line Type" = Rec."Line Type"::Billable)) then begin
//                 Rec.Validate(InvoicePrice, round(Rec."Unit Price (LCY)" * Rec."Qty. to Transfer to Invoice", 0.01));
//                 Rec.Validate(InvoiceCost, round(Rec."Total Cost", 0.01));
//                 Rec.Validate(VAT, round(Rec.InvoicePrice * 0.2, 0.01));
//                 Rec.Validate(InvoicePriceInclVAT, round(Rec.InvoicePrice + Rec.VAT, 0.01));
//                 Rec.Modify();
//             end;
//         end;
//     end;
// }