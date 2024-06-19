pageextension 50114 JobJournalExt extends "Job Journal"
{
    layout
    {
        modify("Line Type")
        { StyleExpr = BillableStyle; }
        modify("Job No.")
        { StyleExpr = BudgetStyle; }
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                GetInventory;
                if (rec."Unit Price (LCY)" < rec."Unit Cost (LCY)") and ((Rec.Type = Rec.Type::Item) or (Rec.Type = Rec.Type::Resource)) then
                    message('Selling price of %1 is less than cost price. Be sure to update selling price and any relevant sales orders', Rec."No.");
                if (Rec.Type = Rec.Type::Item) and (Rec."Location Code" = '') then
                    Rec.Validate("Location Code", 'STORES');
                if (Rec.Type = Rec.Type::"G/L Account") and (Rec."No." <> '1115') then
                    message('Using this G/L Account will probably result in the project invoice line not posting to a sales account. \Consider using ''Item: Job-Purchases'' instead.')
            end;
        }
        addafter(Description)
        {
            field("Work Done"; Rec."Work Done")
            {
                ApplicationArea = all;
                Caption = 'Work Done';
                ToolTip = 'Description of work carried out. Maximum of 700 characters';
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
        modify("Location Code")
        { ShowMandatory = true; }
        modify("Price Calculation Method")
        { Visible = false; }
        modify("Cost Calculation Method")
        { Visible = false; }
        modify("Bin Code")
        { Visible = false; }
        modify("Work Type Code")
        { Visible = false; }
        moveafter("Work Type Code"; Quantity)
        modify("Unit Cost (LCY)")
        { Visible = false; }
        modify("Total Cost (LCY)")
        { Visible = false; }
        modify("Applies-to Entry")
        { Visible = false; }
        modify("Gen. Prod. Posting Group")
        { Visible = true; }
        modify(Quantity)
        { StyleExpr = InsufficientStockStyle; }
        addafter(Quantity)
        {
            field(Instock_SalesLine; rec.Instock_JobJournalLine)
            {
                Editable = false;
                Caption = 'Qty Avail.';
                ToolTip = 'The known quantity in stock at the moment';
                ApplicationArea = All;
                Visible = true;
                BlankZero = false;
                StyleExpr = OutOfStockStyle;
                Width = 5;
                QuickEntry = false;
            }
        }
        modify("Unit Cost")
        {
            trigger OnAfterValidate()
            begin
                if (rec."Unit Price (LCY)" < rec."Unit Cost (LCY)") and ((Rec.Type = Rec.Type::Item) or (Rec.Type = Rec.Type::Resource)) then
                    message('Selling price of %1 is less than cost price. Be sure to update selling price and any relevant sales orders', Rec."No.")
            end;
        }
        modify("Unit Price")
        {
            StyleExpr = SellingPriceStyle;

            trigger OnAfterValidate()
            begin
                if (rec."Unit Price (LCY)" < rec."Unit Cost (LCY)") and ((Rec.Type = Rec.Type::Item) or (Rec.Type = Rec.Type::Resource)) then
                    message('Selling price of %1 is less than cost price. Be sure to update selling price and any relevant sales orders', Rec."No.")
            end;
        }
        addafter(JournalErrorsFactBox)
        {
            part("Job Journal Factbox"; "Job Journal Factbox")
            { ApplicationArea = All; SubPageLink = "No." = FIELD("No."); }
        }
    }
    actions
    {
        addlast("&Job")
        {
            action(JobList)
            {
                Caption = 'Project List';
                Image = Job;
                ApplicationArea = All;
                RunObject = Page "Job List";
                RunPageView = where(Status = filter(Open | Quote | Planning));
                ToolTip = 'Takes the user to the Project List';
                Visible = true;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
            }
            action(JobCard)
            {
                Caption = 'Project Card';
                Image = ViewJob;
                ApplicationArea = All;
                RunObject = Page "Job Card";
                RunPageLink = "No." = field("Job No.");
                ShortcutKey = 'Shift+Ctrl+J';
                ToolTip = 'Takes the user to the Project Card of the selected line';
                Visible = true;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
            }
            action(AssemblyOrders)
            {
                Caption = 'Assembly Orders';
                Image = AssemblyOrder;
                ApplicationArea = All;
                RunObject = Page "Assembly Orders";
                ShortcutKey = 'Shift+Ctrl+A';
                ToolTip = 'View the assembly order page, and create new assembly orders manually to fulfil project journal requirements. Assembly-to-order items are not automatically assembled by project journals.';
                Visible = true;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Enabled = true;
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
                Promoted = true;
                PromotedCategory = Process;
                Scope = Repeater;
                Visible = true;
                Enabled = true;
            }
            action(ItemJournalLink)
            {
                ApplicationArea = All;
                Image = ItemWorksheet;
                Caption = 'Item Journal';
                RunObject = page "Item Journal";
                Description = 'Go to the Item Journal';
                ToolTip = 'Opens the item journal for entering second-hand stock';
                Promoted = true;
                PromotedCategory = Process;
                Scope = Repeater;
                Visible = true;
                Enabled = true;
            }
        }
        addlast("F&unctions")
        {
            action(TimeSheetLink)
            {
                Caption = 'Time Sheets';
                Image = Timesheet;
                ApplicationArea = All;
                RunObject = Page "Time Sheet List";
                ToolTip = 'Takes the user to the Time Sheet page';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
            }
            action(ManagerTimeSheet)
            {
                Caption = 'Manager Time Sheets';
                Image = Timesheet;
                ApplicationArea = All;
                RunObject = Page "Manager Time Sheet List";
                ShortcutKey = 'Shift+Ctrl+J';
                ToolTip = 'Takes the user to the Manager Time Sheet page';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
            }
        }
        modify(SuggestLinesFromTimeSheets)
        { Promoted = true; PromotedCategory = Process; }
    }
    trigger OnAfterGetRecord()
    begin
        GetInventory;
        BillableStyle := SetBillableStyle();
        BudgetStyle := SetBudgetStyle();
        SellingPriceStyle := SetSellingPriceStyle();
        OutOfStockStyle := SetOutOfStockStyle();
        InsufficientStockStyle := SetInsufficientStockStyle();
    end;

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Posting Date", "Job Planning Line No.");
        Rec.Ascending(true);
    end;

    var
        BillableStyle: Text;
        BudgetStyle: Text;
        OutOfStockStyle: Text;
        InsufficientStockStyle: Text;
        SellingPriceStyle: Text;

    local procedure SetBillableStyle(): Text
    begin
        case Rec."Line Type" of
            Rec."Line Type"::Billable:
                exit('Favorable');
            Rec."Line Type"::"Both Budget and Billable":
                exit('Ambiguous');
        end;
        exit('');
    end;

    local procedure SetBudgetStyle(): Text
    begin
        case Rec."Line Type" of
            Rec."Line Type"::Budget:
                exit('Attention');
        end;
        exit('');
    end;

    local procedure SetSellingPriceStyle(): Text
    begin
        if Rec."Unit Price" < Rec."Unit Cost" then
            exit('Unfavorable');
        exit('');
    end;

    local procedure SetOutOfStockStyle(): Text
    begin
        if (Rec.Type = rec.type::Item) and ((Rec.Instock_JobJournalLine = 0) or (Rec.Instock_JobJournalLine < Rec.Quantity)) then
            exit('Unfavorable');
        exit('');
    end;

    local procedure SetInsufficientStockStyle(): Text
    begin
        if (Rec.Type = rec.type::Item) and (Rec.Quantity > Rec.Instock_JobJournalLine) then
            exit('Unfavorable');
        exit('');
    end;

    local procedure GetInventory()
    var
        Item: Record Item;
    begin
        if Item.Get(Rec."No.") and (Item.Type = Item.Type::Inventory) then begin
            Item.CalcFields(Inventory, "Reserved Qty. on Inventory");
            Rec.Validate(Instock_JobJournalLine, Item.Inventory - Item."Reserved Qty. on Inventory");
            //Rec.Modify();
            //Commit();
            //Rec.Modify();
        end
        else
            if Item.Get(Rec."No.") and ((Item.Type = Item.Type::"Non-Inventory") or (Item.Type = Item.Type::Service)) then begin
                Rec.Validate(Instock_JobJournalLine, 999);
                //Rec.Modify();
                //Commit();
            end;
    end;
}