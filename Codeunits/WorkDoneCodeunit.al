codeunit 50200 "Table Page Events"
{
    [EventSubscriber(ObjectType::Report, Report::"Suggest Job Jnl. Lines", 'OnAfterTransferTimeSheetDetailToJobJnlLine', '', false, false)]
    local procedure OnAfterTransferTimeSheetDetailToJobJnlLine(var JobJournalLine: Record "Job Journal Line"; JobJournalTemplate: Record "Job Journal Template"; var TempTimeSheetLine: Record "Time Sheet Line" temporary; TimeSheetDetail: Record "Time Sheet Detail"; JobJournalBatch: Record "Job Journal Batch"; var LineNo: Integer)
    begin
        JobJournalLine."Work Done" := TempTimeSheetLine."Work Done";
        If JobJournalLine.Chargeable = true then
            JobJournalLine."Line Type" := JobJournalLine."Line Type"::Billable
        else
            JobJournalLine."Line Type" := JobJournalLine."Line Type"::Budget;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post Line", 'OnBeforeJobLedgEntryInsert', '', false, false)]
    local procedure OnBeforeJobLedgEntryInsert(var JobLedgerEntry: Record "Job Ledger Entry"; JobJournalLine: Record "Job Journal Line")
    begin
        JobLedgerEntry."Work Done" := JobJournalLine."Work Done";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Res. Journal Line", 'OnAfterCopyResJnlLineFromJobJnlLine', '', false, false)]
    local procedure OnAfterCopyResJnlLineFromJobJnlLine(var ResJnlLine: Record "Res. Journal Line"; var JobJnlLine: Record "Job Journal Line")
    begin
        ResJnlLine."Work Done" := JobJnlLine."Work Done";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Res. Ledger Entry", 'OnAfterCopyFromResJnlLine', '', false, false)]
    procedure OnAfterCopyFromResJnlLine(var ResLedgerEntry: Record "Res. Ledger Entry"; ResJournalLine: Record "Res. Journal Line")
    begin
        ResLedgerEntry."Work Done" := ResJournalLine."Work Done";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Create-Invoice", 'OnBeforeInsertSalesLine', '', false, false)]
    procedure OnAfterCreateSalesLine(var SalesLine: Record "Sales Line"; JobPlanningLine: Record "Job Planning Line")
    begin
        SalesLine."Work Done" := JobPlanningLine."Work Done";
        // if JobPlanningLine.Type = JobPlanningLine.Type::"G/L Account" then begin
        //     if JobPlanningLine."No." > '2000' then begin
        //         SalesLine."No." := '1115';
        //     end;
        // end;
        // if JobPlanningLine."Gen. Prod. Posting Group" = 'PURCHASE G/L' then begin
        //     SalesLine."Gen. Prod. Posting Group" := 'SALES G/L';
        // end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Res. Journal Line", 'OnAfterCopyResJnlLineFromSalesLine', '', false, false)]
    local procedure OnAfterCopyResJnlLineFromSalesLine(var SalesLine: Record "Sales Line"; var ResJnlLine: Record "Res. Journal Line")
    begin
        ResJnlLine."Work Done" := SalesLine."Work Done";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Transfer Line", 'OnAfterFromPlanningSalesLineToJnlLine', '', false, false)]
    local procedure OnAfterFromPlanningSalesLineToJnlLine(var JobJnlLine: Record "Job Journal Line"; JobPlanningLine: Record "Job Planning Line"; SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; EntryType: Enum "Job Journal Line Entry Type")
    begin
        JobJnlLine."Work Done" := SalesLine."Work Done";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Transfer Line", 'OnAfterFromJnlToPlanningLine', '', false, false)]
    local procedure OnAfterFromJnlToPlanningLine(var JobPlanningLine: Record "Job Planning Line"; JobJournalLine: Record "Job Journal Line")
    begin
        JobPlanningLine."Work Done" := JobJournalLine."Work Done";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Transfer Line", 'OnAfterFromJobLedgEntryToPlanningLine', '', false, false)]
    local procedure OnAfterFromJobLedgEntryToPlanningLine(var JobPlanningLine: Record "Job Planning Line"; JobLedgEntry: Record "Job Ledger Entry")
    begin
        JobPlanningLine."Work Done" := JobLedgEntry."Work Done";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Time Sheet Approval Management", OnBeforeInsertEmployeeAbsence, '', false, false)]
    local procedure OnBeforeInsertEmployeeAbsence(TimeSheetLine: Record "Time Sheet Line"; var EmployeeAbsence: Record "Employee Absence")
    begin
        EmployeeAbsence."Work Done" := TimeSheetLine."Work Done";
    end;

    var
        JJPLine: Codeunit "Job Jnl.-Post Line";
}