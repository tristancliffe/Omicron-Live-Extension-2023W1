tableextension 50201 "Job Journal Line Ext" extends "Job Journal Line"
{
    fields
    {
        field(50100; "Work Done"; Text[700])
        {
            CaptionML = ENG = 'Work Done', ENU = 'Work Done';
            DataClassification = CustomerContent;
            ToolTip = 'Description of work carried out. Maximum of 700 characters';
            OptimizeForTextSearch = true;
        }
        field(50101; Instock_JobJournalLine; Decimal)
        {
            Caption = 'Available';
            DecimalPlaces = 0 : 2;
            Editable = false;
            DataClassification = CustomerContent;
            ToolTip = 'The known quantity in stock at the moment';
        }
    }
}

//? JobJnlLine."Line Type" := JobJnlLine."Line Type"::"Both Budget and Billable";