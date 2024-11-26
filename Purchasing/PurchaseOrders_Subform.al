pageextension 50128 PurchOrderSubformExt extends "Purchase Order Subform"
{
    layout
    {
        addbefore(Type)
        {
            field(IsJobLine; IsJobLine)
            { ApplicationArea = all; Caption = 'Job Line'; Editable = false; QuickEntry = false; }
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                GetInventory();
                if (rec."Unit Price (LCY)" < rec."Unit Cost (LCY)") and ((Rec.Type = Rec.Type::Item) or (Rec.Type = Rec.Type::Resource)) and ((Rec."No." <> 'JOB-PURCHASES') or (Rec."No." <> 'TEXT') or (rec."No." = 'SUBCONTRACT')) then
                    if ((rec."No." = 'JOB-PURCHASES') or (rec."No." = 'TEXT') or (rec."No." = 'SUBCONTRACT')) then
                        exit
                    else
                        message('Selling price of %1 is less than cost price. Be sure to update selling price and any relevant sales orders', Rec."No.")
            end;
        }
        modify(Description)
        { StyleExpr = CommentStyle; }
        modify(Quantity)
        { style = Strong; }
        modify("Bin Code")
        { Visible = false; }
        addafter(Description)
        {
            field("Vendor Item No.40789"; Rec."Vendor Item No.")
            { ApplicationArea = All; }
        }
        addafter("Unit of Measure Code")
        {
            field(Instock_PurchLine; rec.Instock_PurchLine)
            {
                Editable = false;
                Caption = 'Qty in Stock';
                ApplicationArea = All;
                Visible = true;
                BlankZero = true;
                Style = StandardAccent;
                Width = 5;
                DecimalPlaces = 0 : 2;
            }
        }
        modify("Item Reference No.")
        { Visible = false; }
        modify("Promised Receipt Date") { Visible = false; }
        movebefore("Qty. to Receive"; "VAT Prod. Posting Group")
        moveafter("Expected Receipt Date"; "Gen. Prod. Posting Group", "Job No.", "Job Task No.", "Job Line Type", "Job Unit Price", "Job Line Amount", "Job Line Amount (LCY)")
        modify("VAT Prod. Posting Group") { Visible = true; Style = AttentionAccent; }
        modify("Job No.")
        {
            Width = 8;
            Visible = True;
            trigger OnAfterValidate()
            begin
                Rec.ValidateShortcutDimCode(3, Rec."Job No.");
                JobPriceMandatory := true;
                if (Rec.Type = Rec.Type::"G/L Account") and (Rec."No." <> '1115') then
                    message('Using this G/L Account will probably result in the job invoice line not posting to a sales account. \Consider using ''Item: Job-Purchases'' instead.')
            end;
        }
        modify("Job Task No.")
        {
            ShowMandatory = JobPriceMandatory;
            Visible = True;
            trigger OnAfterValidate()
            begin
                Rec.Validate("Job Line Type", Rec."Job Line Type"::Billable)
            end;
        }
        modify("Job Line Type") { ShowMandatory = true; Visible = True; }
        modify("Job Unit Price") { Visible = True; }
        modify("Job Line Amount (LCY)") { Width = 8; ShowMandatory = JobPriceMandatory; Visible = True; }
        // addafter("Expected Receipt Date")
        // {
        //     field("VAT Prod. Posting Group1"; Rec."VAT Prod. Posting Group")
        //     { ApplicationArea = All; style = AttentionAccent; }
        //     field("Job No.1"; Rec."Job No.")
        //     {
        //         ApplicationArea = All;
        //         Width = 8;
        //         trigger OnValidate()
        //         begin
        //             Rec.ValidateShortcutDimCode(3, Rec."Job No.");
        //             // Rec.Modify();
        //             JobPriceMandatory := true;
        //             if (Rec.Type = Rec.Type::"G/L Account") and (Rec."No." <> '1115') then
        //                 message('Using this G/L Account will probably result in the job invoice line not posting to a sales account. \Consider using ''Item: Job-Purchases'' instead.')
        //             //Rec."Shortcut Dimension 2 Code" := Rec."Job No.";
        //         end;
        //     }
        //     field("Job Task No.1"; Rec."Job Task No.")
        //     {
        //         ApplicationArea = All;
        //         ShowMandatory = JobPriceMandatory;
        //         trigger OnValidate()
        //         begin
        //             Rec.Validate("Job Line Type", Rec."Job Line Type"::Billable)
        //         end;
        //     }
        //     field("Job Line Type2"; Rec."Job Line Type")
        //     { ApplicationArea = All; ShowMandatory = true; }
        //     field("Job Unit Price2"; Rec."Job Unit Price")
        //     { ApplicationArea = All; Width = 8; ShowMandatory = JobPriceMandatory; }
        //     field("Job Line Amount (LCY)2"; Rec."Job Line Amount (LCY)")
        //     { ApplicationArea = All; }
        // }
        moveafter("Expected Receipt Date"; "Gen. Prod. Posting Group")
        moveafter("Direct Unit Cost"; "Unit Cost (LCY)", "Unit Price (LCY)", "Line Discount Amount", "Line Discount %")
        modify("Gen. Prod. Posting Group")
        { Style = Ambiguous; Visible = true; }
        modify("Direct Unit Cost")
        {
            trigger OnAfterValidate()
            begin
                if (rec."Unit Price (LCY)" < rec."Unit Cost (LCY)") and ((Rec.Type = Rec.Type::Item) or (Rec.Type = Rec.Type::Resource)) then
                    if ((rec."No." = 'JOB-PURCHASES') or (rec."No." = 'TEXT') or (rec."No." = 'SUBCONTRACT')) then
                        exit
                    else
                        message('Selling price of %1 is less than cost price. Be sure to update selling price and any relevant sales orders', Rec."No.")
            end;
        }
        modify("Unit Price (LCY)")
        {
            Visible = true;
            Style = Ambiguous;
            Editable = false;
            BlankZero = true;
        }
        modify("Unit Cost (LCY)")
        {
            Visible = true;
            Style = Ambiguous;
            Editable = false;
            BlankZero = true;
        }
        modify("Line Discount Amount")
        { BlankZero = true; Visible = true; }
        modify("Line Discount %")
        { BlankZero = true; Visible = true; }
        modify("Qty. to Assign")
        { QuickEntry = true; }
        addafter("Line Amount")
        {
            field(LineAmountInclVAT; Rec."Amount Including VAT")
            { ApplicationArea = All; Visible = true; Caption = 'Line Amount incl. VAT'; }
        }
        movebefore("Over-Receipt Quantity"; "Prepayment %")
        modify("Prepayment %")
        { Visible = true; }
        addafter(Description)
        {
            field("Attached Doc Count"; Rec."Attached Doc Count")
            {
                ApplicationArea = All;
                Caption = 'Files';
                ToolTip = 'Number of files attached to this record. Click to open and then print. Can be brought into emails sent within Business Central.';
                Width = 2;
                BlankZero = true;

                trigger OnDrillDown()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal();
                end;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action(SummaryPage)
            {
                ApplicationArea = All;
                Caption = 'Summary';
                Image = PurchaseCreditMemo;
                RunObject = page "PurchaseOrderLineSummary";
                RunPageOnRec = true;
                RunPageView = sorting("Document Type", "Document No.", "Line No.");
                // RunPageLink = "No." = field("No.");
                Description = 'View a summary of this line';
                ToolTip = 'Opens the summary card for this line';
                Scope = Repeater;
                Visible = true;
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
            action(GLLedgerLink)
            {
                ApplicationArea = All;
                Image = GLJournal;
                Caption = 'G/L Ledger';
                RunObject = page "General Ledger Entries";
                RunPageLink = "G/L Account No." = field("No.");
                Description = 'See the G/L Ledger for this line';
                ToolTip = 'Opens the G/L Ledger for this line';
                Scope = Repeater;
                Visible = true;
                Enabled = Rec.Type = Rec.Type::"G/L Account";
            }
            action(DocAttach2)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal();
                end;
            }
        }
    }

    var
        JobPriceMandatory: Boolean;
        CommentStyle: Text;
        IsJobLine: Boolean;

    trigger OnAfterGetRecord()
    begin
        GetInventory();
        CommentStyle := SetCommentStyle();
        JobPriceMandatory := false;
        IsJobLineCheck();
    end;

    local procedure GetInventory()
    var
        Item: Record Item;
    begin
        if Rec.Type <> Rec.Type::Item then
            Rec.Instock_PurchLine := 0
        else
            if Item.Get(Rec."No.") and (Item.Type = Item.Type::Inventory) then begin
                Item.CalcFields(Inventory, "Reserved Qty. on Inventory");
                // Rec.Instock_PurchLine := Item.Inventory;
                // Rec.Modify();
                Rec.Validate(Instock_PurchLine, Item.Inventory - Item."Reserved Qty. on Inventory");
            end
            else
                if Item.Get(Rec."No.") and ((Item.Type = Item.Type::"Non-Inventory") or (Item.Type = Item.Type::Service)) then begin
                    // Rec.Instock_PurchLine := 999;
                    // Rec.Modify()
                    Rec.Validate(Rec.Instock_PurchLine, 999);
                end;
    end;

    procedure SetCommentStyle(): Text
    begin
        If Rec.Type = Rec.Type::" " then
            exit('Strong');
        exit('');
    end;

    local procedure IsJobLineCheck()
    begin
        IsJobLine := false;
        if rec."Job No." <> '' then
            IsJobLine := true;
    end;
}