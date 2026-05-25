table 50101 "Project Enquiry"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; }
        field(2; "Date of Enquiry"; Date) { }
        field(3; "Customer Name"; Text[100]) { }
        field(4; "Contact Details"; Text[100]) { }
        field(5; "Location"; Text[100]) { }
        field(6; "Car"; Text[100]) { }
        field(7; "Requirements"; Text[1000]) { }
        field(8; "Notes"; Text[500]) { }
        field(9; "Date Contacted"; Date) { }
        field(10; "Incoming"; Boolean) { }
        field(11; "In Progress"; Boolean) { }
        field(12; "Done"; Boolean) { }
        field(13; "Cancelled"; Boolean) { }
        field(14; "Postponed"; Boolean) { }
        field(15; "Sort Priority"; Integer) { }
    }

    keys
    {
        key(PK; "Entry No.", "Date of Enquiry")
        {
            Clustered = true;
        }
        key(SortPriority; "Sort Priority", "Date of Enquiry", "Entry No.") { }
    }

    trigger OnInsert()
    begin
        if "Date of Enquiry" = 0D then
            "Date of Enquiry" := Today();
        UpdateSortPriority();
    end;

    trigger OnModify()
    begin
        UpdateSortPriority();
    end;

    local procedure UpdateSortPriority()
    begin
        if Done then
            "Sort Priority" := 4
        else if Cancelled then
            "Sort Priority" := 5
        else if Incoming then
            "Sort Priority" := 2
        else if "In Progress" then
            "Sort Priority" := 3
        else
            "Sort Priority" := 1;
    end;
}