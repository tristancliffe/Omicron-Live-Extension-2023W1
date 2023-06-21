#pragma implicitwith disable
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
        addafter(Quantity)
        {
            field("Location Code1"; Rec."Location Code")
            {
                ShowMandatory = true;
                ApplicationArea = All;
            }
        }
        moveafter(Quantity; "Unit of Measure Code")
        modify("Unit of Measure Code")
        { Visible = true; }
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
        {
            Visible = true;
            BlankZero = true;
        }
        modify("Qty. to Transfer to Invoice")
        {
            BlankZero = true;
            Style = Strong;
            Visible = true;
        }
        modify("Invoiced Amount (LCY)")
        { BlankZero = true; }
        movebefore("Invoiced Amount (LCY)"; "Qty. to Transfer to Invoice")
        // addbefore("Invoiced Amount (LCY)")
        // {
        //     field("Qty. to Transfer to Invoice1"; Rec."Qty. to Transfer to Invoice")
        //     { ApplicationArea = All; }
        // }
        movebefore("Invoiced Amount (LCY)"; "Qty. Invoiced")
        modify("Qty. Invoiced")
        {
            Visible = true;
            Style = Favorable;
        }
        movelast(Control1; "User ID")
        modify("User ID")
        { Visible = true; }
        movebefore("Qty. Invoiced"; "Qty. Transferred to Invoice")
        modify("Qty. Transferred to Invoice")
        {
            Visible = true;
            Editable = false;
            ApplicationArea = All;
        }
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
                Enabled = true;
            }
        }
        modify("Create &Sales Invoice")
        { Visible = false; }
    }

    var
        CurrentJob: Code[20];

    trigger OnAfterGetCurrRecord()
    begin
        if (Rec."Work Done" = '') and (Rec.Type = Rec.Type::Resource) then
            rec."Work Done" := rec.Description;
        rec.Modify()
    end;

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Planning Date", "Line No.");
        Rec.Ascending(true);
    end;
}
#pragma implicitwith restore
