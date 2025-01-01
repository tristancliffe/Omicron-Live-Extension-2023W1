pageextension 50138 JobPlanningLinePageExt extends "Job Planning Lines"
{
    layout
    {
        addafter(Description)
        {
            field("Work Done"; Rec."Work Done")
            {
                ApplicationArea = All;
                AssistEdit = true;
                StyleExpr = InvoicedStyle;

                trigger OnAssistEdit()
                var
                    Dialog: Page "Work Done Dialog";
                begin
                    Dialog.GetText(rec."Work Done");
                    if Dialog.RunModal() = Action::OK then
                        rec."Work Done" := Dialog.SaveText()
                end;
            }
        }
        modify("Document No.") { Visible = Device; }
        modify("Job Task No.") { StyleExpr = InvoicedStyle; }
        modify(Description) { StyleExpr = InvoicedStyle; }
        modify(Type) { StyleExpr = TypeStyle; }
        modify("No.") { StyleExpr = TypeStyle; }
        moveafter(Quantity; "Unit of Measure Code", "Location Code", "Qty. to Transfer to Journal", "Qty. to Transfer to Invoice")
        // addafter("Unit of Measure Code")
        // {
        //     field("Location Code1"; Rec."Location Code")
        //     { ShowMandatory = MandatoryLocation; ApplicationArea = All; Caption = 'blah'; }
        // }
        modify("Unit of Measure Code") { Visible = true; }
        modify("Location Code") { Visible = true; ShowMandatory = MandatoryLocation; }
        moveafter("Line Amount"; "Line Discount %")
        modify("Line Amount") { BlankZero = true; }
        modify("Line Discount %") { Visible = true; }
        modify("Planned Delivery Date") { Visible = false; }
        modify("Price Calculation Method") { Visible = false; }
        modify("Cost Calculation Method") { visible = false; }
        modify("Qty. to Transfer to Journal") { Visible = true; BlankZero = true; }
        modify("Qty. to Transfer to Invoice") { BlankZero = true; StyleExpr = ToInvoiceStyle; Visible = true; }
        modify("Invoiced Amount (LCY)") { BlankZero = true; }
        modify("Unit Price") { StyleExpr = SellingPriceStyle; }
        movebefore("Invoiced Amount (LCY)"; "Qty. Invoiced")
        modify("Qty. Invoiced") { Visible = true; Style = Favorable; BlankZero = true; }
        movelast(Control1; "User ID")
        modify("User ID") { Visible = true; }
        modify("Qty. Transferred to Invoice") { Visible = true; Editable = false; ApplicationArea = All; }
        addafter("User ID")
        {
            field(InvoicePrice; Rec.InvoicePrice) { ApplicationArea = All; BlankZero = true; }
        }
    }
    actions
    {
        modify("&Open Job Journal") { Visible = false; }
        addlast("F&unctions")
        {
            action(JobJournal)
            {
                Caption = 'Project Journal';
                Image = JobJournal;
                ApplicationArea = All;
                RunObject = Page "Job Journal";
                ToolTip = 'Opens the project journal';
                Visible = true;
            }
            action(CopyPurchaseLinestoSalesLines)
            {
                Caption = 'Changes Purchases to Sales';
                Visible = false;
                ApplicationArea = All;
                Description = 'Changes Purchase G/L accounts to Sales G/L accounts';
                Tooltip = 'Changes Purchase G/L accounts to Sales G/L accounts';
                Image = SwitchCompanies;
                // trigger OnAction()
                // begin
                //     message('%1', Rec."Job No.")
                // end;
                trigger OnAction()
                var
                    Line: Record "Job Planning Line";
                    NewLine: Record "Job Planning Line";
                    MaxLineNo: Integer;
                begin
                    Line.SetRange("Job No.", Rec."Job No.");
                    if Line.FindLast() then
                        MaxLineNo := Line."Line No.";
                    Line.SetRange("Job No.", Rec."Job No.");
                    if Line.FindFirst() then
                        repeat
                            if (Line.Type = Line.Type::"G/L Account") and (Line."No." > '2000') then begin
                                NewLine := Line;
                                NewLine."Line No." := MaxLineNo + 10000;
                                NewLine."No." := '1115';
                                if NewLine."Gen. Prod. Posting Group" = 'PURCHASE G/L' then
                                    NewLine."Gen. Prod. Posting Group" := 'SALES G/L';
                                NewLine.Insert();
                                MaxLineNo := MaxLineNo + 10000;
                                Line.Delete();
                            end;
                        until Line.Next = 0;
                end;
            }
            action(ItemCardLink)
            {
                ApplicationArea = All;
                Image = Item;
                Caption = 'Item Card';
                RunObject = page "Item Card";
                RunPageLink = "No." = field("No.");
                Description = 'Go to the Item Card';
                ToolTip = 'Opens the item card for this line';
                Scope = Repeater;
                Visible = true;
                Enabled = Rec.Type = Rec.Type::Item;
            }
            action(CreateSalesInvoice)
            {
                Caption = 'Create Job Sales Invoice';
                Image = SalesInvoice;
                ApplicationArea = All;
                //RunObject = Report "Job Create Sales Invoice";
                ToolTip = 'Create job sales invoices report';
                Visible = true;

                trigger OnAction()
                var
                    JobTask: Record "Job Task";
                    JobInvoice: Report "Job Create Sales Invoice";
                begin
                    JobTask.SetFilter("Job No.", Rec."Job No.");
                    JobInvoice.SetTableView(JobTask);
                    JobInvoice.RunModal();
                    Clear(JobInvoice);
                end;
            }
            action("Report Job Invoicing Excel")
            {
                ApplicationArea = Suite;
                Caption = 'Excel Invoice Planner';
                Image = "Report";
                ToolTip = 'Open the Excel worksheet for invoicing';
                Visible = true;

                trigger OnAction()
                var
                    Job: Record Job;
                    TimesheetReport: Report "Job Billing Excel";
                begin
                    Job.SetFilter("No.", Rec."Job No.");
                    TimesheetReport.SetTableView(Job);
                    TimesheetReport.RunModal();
                    Clear(TimesheetReport);
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref(ItemCardLink_promoted; ItemCardLink) { Visible = true; }
            group(ProjectActions)
            {
                ShowAs = SplitButton;
                Visible = true;
                actionref(ExcelInvoicing_promoted; "Report Job Invoicing Excel") { Visible = true; }
                actionref(CreateSalesInvoice_promoted; CreateSalesInvoice) { Visible = true; }
                actionref(ChangePurhaseLines_promoted; CopyPurchaseLinestoSalesLines) { Visible = true; }
                actionref(JobJournal_promoted; JobJournal) { }
            }
        }
    }

    var
        SellingPriceStyle: Text;
        ToInvoiceStyle: Text;
        TypeStyle: Text;
        MandatoryLocation: Boolean;
        InvoicedStyle: Text;
        Device: Boolean;
    //UpdateJobPlanningLines: Codeunit UpdateJobPlanningLines;

    trigger OnAfterGetRecord()
    begin
        SellingPriceStyle := SetSellingPriceStyle();
        ToInvoiceStyle := SetToInvoiceStyle();
        TypeStyle := SetTypeStyle();
        InvoicedStyle := SetInvoicedStyle();
        SetLocationMandatory();
        if (Rec."Work Done" = '') and (Rec.Type = Rec.Type::Resource) then
            Rec.Validate("Work Done", Rec.Description);

        //rec.Modify() - THIS BREAKS STUFF
        // Rec.InvoicePrice := round((Rec."Unit Price (LCY)") * Rec."Qty. to Transfer to Invoice", 0.01);
        // Rec.InvoiceCost := round(Rec."Total Cost (LCY)", 0.01);
        // Rec.VAT := round(Rec.InvoicePrice * 0.2, 0.01);
        // Rec.InvoicePriceInclVAT := round(Rec.InvoicePrice + Rec.VAT, 0.01);

        // Rec.Validate(InvoicePrice, round(Rec."Unit Price (LCY)" * Rec."Qty. to Transfer to Invoice", 0.01));
        // Rec.Validate(InvoiceCost, round(Rec."Total Cost", 0.01));
        // Rec.Validate(VAT, round(Rec.InvoicePrice * 0.2, 0.01));
        // Rec.Validate(InvoicePriceInclVAT, round(Rec.InvoicePrice + Rec.VAT, 0.01));
        // Rec.Modify();
        // UpdateJobPlanningLines.UpdateLines(Rec);
    end;

    trigger OnOpenPage()
    begin
        if (CurrentClientType = CurrentClientType::Phone) or (CurrentClientType = CurrentClientType::Tablet) then
            Device := false
        else
            Device := true;
        Rec.SetCurrentKey("Job No.", "Planning Date", "Line No.");
        Rec.Ascending(true);
    end;

    local procedure SetSellingPriceStyle(): Text
    begin
        if (Rec."Unit Price" < Rec."Unit Cost") then // or (Rec."Unit Price" = 0) then
            exit('Unfavorable');
        exit('');
    end;

    local procedure SetTypeStyle(): Text
    begin
        MandatoryLocation := false;
        if Rec."Unit of Measure Code" <> 'HOUR' then
            exit('Ambiguous');
        if (Rec."Qty. Invoiced" > 0) or (Rec."Qty. to Transfer to Invoice" = 0) then
            exit('Subordinate');
        exit('');
    end;

    local procedure SetInvoicedStyle(): Text
    begin
        if (Rec."Qty. Invoiced" > 0) or (Rec."Qty. to Transfer to Invoice" = 0) then
            exit('Subordinate');
        exit('');
    end;

    local procedure SetToInvoiceStyle(): Text
    begin
        if rec."Qty. to Transfer to Invoice" < rec.Quantity then
            exit('StrongAccent')
        else
            exit('Strong');
    end;

    local procedure SetLocationMandatory()
    begin
        MandatoryLocation := false;
        if Rec.Type = Rec.Type::Item then
            MandatoryLocation := true;
    end;
}