tableextension 50201 "Job Journal Line Ext" extends "Job Journal Line"
{
    fields
    {
        field(50100; "Work Done"; Text[700])
        {
            CaptionML = ENG = 'Work Done', ENU = 'Work Done';
            DataClassification = CustomerContent;
        }
        field(50101; Instock_JobJournalLine; Decimal)
        {
            Caption = 'Available';
            DecimalPlaces = 1 : 2;
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
}

//? JobJnlLine."Line Type" := JobJnlLine."Line Type"::"Both Budget and Billable";