table 50100 "Stock Used"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Job No."; Code[20])
        {
            Caption = 'Project No.';
            ToolTip = 'Specifies the value of the Project No. field.', Comment = '%';
            TableRelation = Job."No." where(Status = filter(Open | Completed | Paused));

            trigger OnValidate()
            begin
                if "Job No." <> '' then begin
                    Job.Get("Job No.");
                end;
            end;
        }
        field(3; "Entered"; Boolean)
        {
            Caption = 'Entered to Project';
            ToolTip = 'Specifies the value of the Entered to Project field.', Comment = '%';
        }
        field(4; "Date"; Date)
        {
            Caption = 'Date';
            ToolTip = 'Specifies the value of the Date field.', Comment = '%';
        }
        field(5; "Resource No."; code[20])
        {
            Caption = 'Resource No.';
            ToolTip = 'Will auto populate when a line is entered.', Comment = '%';
        }
        field(6; "Quantity"; Decimal)
        {
            Caption = 'Qty';
            ObsoleteState = Removed;
            ObsoleteReason = 'Changed to Code[10] so units can be added';
        }
        field(7; "Item No."; Code[20])
        {
            Caption = 'Part No.';
            ToolTip = 'Item part number, if known', Comment = '%';
            //TableRelation = Item."No." where(Blocked = const(false), "Sales Blocked" = const(false));

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if Item.Get("Item No.") then
                    Rec.Description := Item.Description
                else
                    exit;
            end;
        }
        field(8; "Description"; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Part description - can be changed by the user.', Comment = '%';
            //!OptimizeForTextSearch = true;
        }
        field(9; StockQty; Code[10])
        {
            Caption = 'Qty';
            ToolTip = 'Quantity used', Comment = '%';
        }
        field(10; "Stock Name"; Text[100])
        {
            Caption = 'Stock Name';
            //!OptimizeForTextSearch = true;
            ToolTip = 'Technican''s description of the item.';
        }
        field(11; LastOne; Boolean)
        {
            Caption = 'Last';
            ToolTip = 'Last one in stock - message for parts department to order more';
            ObsoleteState = Pending;
            ObsoleteReason = 'No longer used - staff recommended to tell management in person.';
        }
    }


    keys
    {
        key(Line; "Job No.", "Line No.") { Clustered = true; }
        key(Date; Date) { }
    }

    var
        Job: Record Job;

    trigger OnDelete()
    begin
        if Rec.Entered = true then begin
            message('This line cannot be deleted as it has been posted. To reverse a posted line create a new line with a negative quantity.');
            Error('This line has been entered and cannot be deleted.');
        end;
    end;
}