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
                Style = StandardAccent;
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
            trigger OnAfterValidate()
            begin
                if (rec."Unit Price (LCY)" < rec."Unit Cost (LCY)") and ((Rec.Type = Rec.Type::Item) or (Rec.Type = Rec.Type::Resource)) then
                    message('Selling price of %1 is less than cost price. Be sure to update selling price and any relevant sales orders', Rec."No.")
            end;
        }
    }
    actions
    {
        addlast("&Job")
        {
            action(JobList)
            {
                Caption = 'Job List';
                Image = Job;
                ApplicationArea = All;
                RunObject = Page "Job List";
                ToolTip = 'Takes the user to the Job List';
                Visible = true;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
            }
            action(JobCard)
            {
                Caption = 'Job Card';
                Image = ViewJob;
                ApplicationArea = All;
                RunObject = Page "Job Card";
                RunPageLink = "No." = field("Job No.");
                ShortcutKey = 'Shift+Ctrl+J';
                ToolTip = 'Takes the user to the Job Card of the selected line';
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
                ToolTip = 'View the assembly order page, and create new assembly orders manually to fulfil job journal requirements. Assembly-to-order items are not automatically assembled by job journals.';
                Visible = true;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
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
        {
            Promoted = true;
            PromotedCategory = Process;
        }
    }
    trigger OnAfterGetRecord()
    begin
        GetInventory;
        SetBillableStyle();
    end;

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Posting Date", "Job Planning Line No.");
        Rec.Ascending(true);
        SetBillableStyle;
    end;

    var
        BillableStyle: Text;
        BudgetStyle: Text;

    local procedure SetBillableStyle()
    begin
        BillableStyle := 'Standard';
        BudgetStyle := 'Standard';
        case Rec."Line Type" of
            Rec."Line Type"::Budget:
                BudgetStyle := 'Attention';
            Rec."Line Type"::Billable:
                BillableStyle := 'Favorable';
            Rec."Line Type"::"Both Budget and Billable":
                BillableStyle := 'Ambiguous';
        end;
    end;

    local procedure GetInventory()
    var
        Items: Record Item;
    begin
        if Items.Get(Rec."No.") and (Items.Type = Items.Type::Inventory) then begin
            Items.CalcFields(Inventory);
            Rec.Instock_JobJournalLine := Items.Inventory;
            //Rec.Modify();
        end
        else
            if Items.Get(Rec."No.") and ((Items.Type = Items.Type::"Non-Inventory") or (Items.Type = Items.Type::Service)) then
                Rec.Instock_JobJournalLine := 999;
    end;
}