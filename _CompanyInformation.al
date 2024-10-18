tableextension 50123 CompanyInfoTableExt extends "Company Information"
{
    fields
    {
        field(50100; CompanyNotes; Text[2000])
        {
            Caption = 'Notes';
            DataClassification = CustomerContent;
            ToolTip = 'Notes about the company';
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
                MultiLine = true;
            }
        }
    }
}