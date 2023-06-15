pageextension 50151 SelfServiceExt extends "Team Member Activities No Msgs"
{
    layout
    {
        modify("Current Time Sheet")
        {
            Visible = False;
        }
        modify("Time Sheets")
        {
            Visible = False;
        }
    }
}