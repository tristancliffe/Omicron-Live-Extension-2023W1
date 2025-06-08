// This code extends the "Ship-to Address" page in Dynamics 365 Business Central.
// The modification adds a caption and tooltip to the "Code" field, which is renamed to "Address Code."
// The modification also adds a field for "Address Notes" after the "Name" field.
// The "GLN" field is set to be invisible.
pageextension 50104 ShipToCardExt extends "Ship-to Address"
{
    layout
    {
        modify(Code) { Caption = 'Address Code'; ToolTipML = ENG = 'Specifies a ship-to address code. Use 1,2,3 or 10000,20000,30000, or "Minerva" for Minerva Cottage'; }
        addafter(Name)
        {
            field("Address Notes"; Rec."Address Notes") { MultiLine = true; ApplicationArea = All; }
        }
        modify(GLN) { Visible = false; }
        modify("Phone No.") { Importance = Standard; }
        modify("E-Mail") { Importance = Standard; }
    }
}