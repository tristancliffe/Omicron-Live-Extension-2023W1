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
        modify("Document No.")
        { Visible = Device; }
        modify("Job Task No.")
        { StyleExpr = InvoicedStyle; }
        modify(Description)
        { StyleExpr = InvoicedStyle; }
        modify(Type)
        { StyleExpr = TypeStyle; }
        modify("No.")
        { StyleExpr = TypeStyle; }
        moveafter(Quantity; "Unit of Measure Code", "Location Code", "Qty. to Transfer to Journal", "Qty. to Transfer to Invoice")
        // addafter("Unit of Measure Code")
        // {
        //     field("Location Code1"; Rec."Location Code")
        //     { ShowMandatory = MandatoryLocation; ApplicationArea = All; Caption = 'blah'; }
        // }
        modify("Unit of Measure Code")
        { Visible = true; }
        modify("Location Code")
        { Visible = true; ShowMandatory = MandatoryLocation; }
        moveafter("Line Amount"; "Line Discount %")
        modify("Line Amount")
        { BlankZero = true; }
        modify("Line Discount %")
        { Visible = true; }
        modify("Planned Delivery Date")
        { Visible = false; }
        modify("Price Calculation Method")
        { Visible = false; }
        modify("Cost Calculation Method")
        { visible = false; }
        modify("Qty. to Transfer to Journal")
        { Visible = true; BlankZero = true; }
        modify("Qty. to Transfer to Invoice")
        { BlankZero = true; Style = Strong; Visible = true; }
        modify("Invoiced Amount (LCY)")
        { BlankZero = true; }
        modify("Unit Price")
        { StyleExpr = SellingPriceStyle; }
        movebefore("Invoiced Amount (LCY)"; "Qty. Invoiced")
        modify("Qty. Invoiced")
        { Visible = true; Style = Favorable; }
        movelast(Control1; "User ID")
        modify("User ID")
        { Visible = true; }
        modify("Qty. Transferred to Invoice")
        { Visible = true; Editable = false; ApplicationArea = All; }
    }
    actions
    {
        addlast("F&unctions")
        {
            action(CopyPurchaseLinestoSalesLines)
            {
                Caption = 'Changes Purchases to Sales';
                Visible = true;
                ApplicationArea = All;
                Description = 'Changes Purchase G/L accounts to Sales G/L accounts';
                Tooltip = 'Changes Purchase G/L accounts to Sales G/L accounts';
                Image = SwitchCompanies;
                Promoted = true;
                PromotedCategory = Process;
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

                // trigger OnAction()
                // var
                //     Line: Record "Job Planning Line";
                //     NewLine: Record "Job Planning Line";
                // begin
                //     Line.SetRange("Job No.", Line."Job No.");
                //     while Line.Next() <> 0 do begin
                //         if (Line.Type = Line.Type::"G/L Account") and (Line."No." > '2000') then begin
                //             NewLine.Reset();
                //             NewLine."Job No." := Line."Job No.";
                //             NewLine."Type" := Line.Type;
                //             NewLine."No." := '1115';
                //             NewLine.Insert();
                //             Line.Delete();
                //             MESSAGE('Successfully deleted original record with Job No. %1 and No. %2 and inserted new record with Job No. %3 and No. %4', Line."Job No.", Line."No.", NewLine."Job No.", NewLine."No.");
                //         end;
                //     end;
                // end;
            }
        }
        addlast("F&unctions")
        {
            action(ItemCardLink)
            {
                ApplicationArea = All;
                Image = Item;
                Caption = 'Item Card';
                RunObject = page "Item Card";
                RunPageLink = "No." = field("No.");
                Description = 'Go to the Item Card';
                ToolTip = 'Opens the item card for this line';
                Promoted = true;
                PromotedCategory = Process;
                Scope = Repeater;
                Visible = true;
                Enabled = Rec.Type = Rec.Type::Item;
            }
        }
        // modify("Create &Sales Invoice")
        // { Caption = 'Line to Sales Order'; }
        addlast("F&unctions")
        {
            action(CreateSalesInvoice)
            {
                Caption = 'Create Job Sales Invoice';
                Image = SalesInvoice;
                ApplicationArea = All;
                //RunObject = Report "Job Create Sales Invoice";
                ToolTip = 'Create job sales invoices report';
                Visible = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    JobTask: Record "Job Task";
                    JobInvoice: Report "Job Create Sales Invoice";
                begin
                    JobTask.SetFilter("Job No.", Rec."Job No.");
                    JobInvoice.SetTableView(JobTask);
                    JobInvoice.RunModal();
                end;
            }
            action("Report Job Invoicing Excel")
            {
                ApplicationArea = Suite;
                Caption = 'Excel Invoice Planner';
                Image = "Report";
                ToolTip = 'Open the Excel worksheet for invoicing';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Job: Record Job;
                    TimesheetReport: Report "Job Billing Excel";
                begin
                    Job.SetFilter("No.", Rec."Job No.");
                    TimesheetReport.SetTableView(Job);
                    TimesheetReport.RunModal();
                end;
            }
        }
    }

    var
        CurrentJob: Code[20];
        SellingPriceStyle: Text;
        TypeStyle: Text;
        MandatoryLocation: Boolean;
        InvoicedStyle: Text;
        Device: Boolean;

    trigger OnAfterGetRecord()
    begin
        SetStyles();
        if (Rec."Work Done" = '') and (Rec.Type = Rec.Type::Resource) then
            Rec.Validate("Work Done", Rec.Description);
        //rec.Modify() - THIS BREAKS STUFF
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetStyles();
        if (Rec."Work Done" = '') and (Rec.Type = Rec.Type::Resource) then
            Rec.Validate("Work Done", Rec.Description);
        //rec.Modify() - THIS BREAKS STUFF
    end;

    trigger OnOpenPage()
    begin
        SetStyles();
        if (CurrentClientType = CurrentClientType::Phone) or (CurrentClientType = CurrentClientType::Tablet) then
            Device := false
        else
            Device := true;
        Rec.SetCurrentKey("Planning Date", "Line No.");
        Rec.Ascending(true);
    end;

    local procedure SetStyles()
    begin
        SellingPriceStyle := 'Standard';
        TypeStyle := 'Standard';
        InvoicedStyle := 'Standard';
        MandatoryLocation := false;
        if (Rec."Unit Price" < Rec."Unit Cost") then // or (Rec."Unit Price" = 0) then
            SellingPriceStyle := 'Unfavorable';
        if Rec."Unit of Measure Code" <> 'HOUR' then
            TypeStyle := 'Ambiguous';
        if Rec.Type = Rec.Type::Item then
            MandatoryLocation := true;
        if (Rec."Qty. Invoiced" > 0) or (Rec."Qty. to Transfer to Invoice" = 0) then begin
            InvoicedStyle := 'Subordinate';
            TypeStyle := 'Subordinate';
        end;
    end;
}