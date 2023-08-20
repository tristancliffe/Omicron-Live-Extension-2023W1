tableextension 50123 CompanyInfoTableExt extends "Company Information"
{
    fields
    {
        field(50100; CompanyNotes; Text[2000])
        {
            Caption = 'Notes';
            DataClassification = CustomerContent;
        }
    }
}

pageextension 50207 CompanyInfoPageExt extends "Company Information"
{
    layout
    {
        addafter("EORI Number")
        {
            field(CompanyNotes; Rec.CompanyNotes)
            {
                ApplicationArea = All;
                ToolTip = 'Notes about the company';
                MultiLine = true;
            }
        }
    }
}