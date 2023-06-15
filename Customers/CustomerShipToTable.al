// A new table extension named "ShipToNotesExt" is created for the "Ship-to Address" table
// The extension adds a new field called "Address Notes" with a data type of Text and a maximum length of 500 characters
// The field has a caption of "Address Notes" and a data classification of "CustomerContent"
tableextension 50102 ShipToNotesExt extends "Ship-to Address"
{
    fields
    {
        field(50100; "Address Notes"; Text[500]) //! This should be 500, was 1000 to begin with
        {
            CaptionML = ENU = 'Address Notes';
            DataClassification = CustomerContent;
        }
    }
}