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
            TableRelation = Job."No.";//where(Status = filter(Open));
        }
        field(3; "Entered"; Boolean)
        {
            Caption = 'Entered to Project';
        }
        field(4; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(5; "Resource No."; code[20])
        {
            Caption = 'Resource No.';
        }
        field(6; "Quantity"; Decimal)
        {
            Caption = 'Qty';
        }
        field(7; "Item No."; Code[20])
        {
            Caption = 'Part No.';
            TableRelation = Item."No." where(Blocked = const(false), "Sales Blocked" = const(false));

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if Item.Get("Item No.") then begin
                    Rec.Description := Item.Description;
                end;
            end;
        }
        field(8; "Description"; Text[100])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Line; "Job No.", "Line No.") { Clustered = true; }
        key(Date; Date) { }
    }
    trigger OnDelete()
    begin
        if Rec.Entered = true then begin
            message('This line cannot be deleted as it has been posted. To reverse a posted line create a new line with a negative quantity.');
            Error('This line has been entered and cannot be deleted.');
        end;
    end;
}