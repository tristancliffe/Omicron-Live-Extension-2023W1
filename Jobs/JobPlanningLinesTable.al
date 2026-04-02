tableextension 50107 JobPlanningLinesExt extends "Job Planning Line"
{
    fields
    {
        field(50100; "Work Done"; Text[1000])
        {
            Caption = 'Work Done';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies information in addition to the description.';
            OptimizeForTextSearch = true;
        }
        field(50101; "InvoicePrice"; Decimal) { Caption = 'Price to Invoice'; DataClassification = CustomerContent; }
        field(50102; "InvoiceCost"; Decimal) { Caption = 'Cost for Invoice'; DataClassification = CustomerContent; }
        field(50103; "VAT"; Decimal) { Caption = 'VAT at 20%'; DataClassification = CustomerContent; }
        field(50104; "InvoicePriceInclVAT"; Decimal) { Caption = 'Invoice Price Incl. VAT'; DataClassification = CustomerContent; }
        field(50105; "Invoicable Qty"; Decimal)
        {
            Caption = 'Invoicable Qty';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }

    trigger OnModify()
    begin
        if ((rec."Line Type" = Rec."Line Type"::Billable) or (rec."Line Type" = Rec."Line Type"::"Both Budget and Billable")) then begin
            Rec.Validate(InvoicePrice, round((Rec."Unit Price (LCY)" * Rec."Qty. to Transfer to Invoice") - "Line Discount Amount (LCY)", 0.01));
            Rec.Validate(InvoiceCost, round(Rec."Total Cost", 0.01));
            Rec.Validate(VAT, round(Rec.InvoicePrice * 0.2, 0.01));
            Rec.Validate(InvoicePriceInclVAT, round(Rec.InvoicePrice + Rec.VAT, 0.01));
        end;
    end;

    // trigger OnBeforeModify()
    // begin
    //     UpdateInvoicableQty();
    // end;

    // trigger OnAfterInsert()
    // begin
    //     UpdateInvoicableQty();
    // end;

    // local procedure UpdateInvoicableQty()
    // begin
    //     if "Qty. Invoiced" <> 0 then
    //         "Invoicable Qty" := "Qty. Invoiced"
    //     else if "Qty. to Invoice" <> 0 then
    //         "Invoicable Qty" := "Qty. to Invoice"
    //     else
    //         "Invoicable Qty" := "Qty. to Transfer to Invoice";
    // end;
}

codeunit 50108 "Job Planning Line Events"
{
    Subtype = Normal;

    [EventSubscriber(ObjectType::Table, Database::"Job Planning Line", 'OnAfterValidateEvent', 'Qty. Invoiced', false, false)]
    local procedure OnQtyInvoicedValidate(var Rec: Record "Job Planning Line")
    begin
        RecalculateInvoicableQty(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Planning Line", 'OnAfterValidateEvent', 'Qty. Transferred to Invoice', false, false)]
    local procedure OnQtyTransferredValidate(var Rec: Record "Job Planning Line")
    begin
        RecalculateInvoicableQty(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Planning Line", 'OnAfterValidateEvent', 'Qty. to Transfer to Invoice', false, false)]
    local procedure OnQtyToTransferValidate(var Rec: Record "Job Planning Line")
    begin
        RecalculateInvoicableQty(Rec);
    end;

    local procedure RecalculateInvoicableQty(var Rec: Record "Job Planning Line")
    var
        NewValue: Decimal;
    begin
        // Ensure FlowFields have correct values
        Rec.CalcFields("Qty. Invoiced", "Qty. Transferred to Invoice");

        // Determine the correct Invoicable Qty
        if Rec."Qty. Invoiced" <> 0 then
            NewValue := Rec."Qty. Invoiced"
        else if Rec."Qty. Transferred to Invoice" <> 0 then
            NewValue := Rec."Qty. Transferred to Invoice"
        else
            NewValue := Rec."Qty. to Transfer to Invoice";

        // Only validate if value has changed to minimize writes
        if Rec."Invoicable Qty" <> NewValue then
            Rec.Validate("Invoicable Qty", NewValue);
    end;
}

codeunit 50109 "Update Invoicable JPLs"
{
    Subtype = Normal;

    trigger OnRun()
    var
        JobPlanningLine: Record "Job Planning Line";
        CountUpdated: Integer;
        NewValue: Decimal;
    begin
        if not Confirm('This will update the "Invoicable Qty" field for all Job Planning Lines. Continue?') then
            exit;

        CountUpdated := 0;
        JobPlanningLine.Reset();

        if JobPlanningLine.FindSet() then
            repeat
                // Calculate FlowFields for this line
                JobPlanningLine.CalcFields("Qty. Transferred to Invoice", "Qty. Invoiced");

                NewValue := CalcInvoicableQty(JobPlanningLine);

                // Only update when different to reduce writes
                if JobPlanningLine."Invoicable Qty" <> NewValue then begin
                    JobPlanningLine.Validate("Invoicable Qty", NewValue);
                    JobPlanningLine.Modify();
                    CountUpdated += 1;
                end;
            until JobPlanningLine.Next() = 0;

        Message('Updated %1 job planning lines.', CountUpdated);
    end;

    local procedure CalcInvoicableQty(var JPL: Record "Job Planning Line"): Decimal
    begin
        if JPL."Qty. Invoiced" <> 0 then
            exit(JPL."Qty. Invoiced")
        else if JPL."Qty. Transferred to Invoice" <> 0 then
            exit(JPL."Qty. Transferred to Invoice")
        else
            exit(JPL."Qty. to Transfer to Invoice");
    end;
}