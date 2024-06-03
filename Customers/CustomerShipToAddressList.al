pageextension 50192 ShipToListExt extends "Ship-to Address List"
{
    layout
    {
        modify(Address) { Visible = true; }
        modify("Post Code") { Visible = true; }
        modify("Phone No.") { Visible = true; }
        moveafter(County; "Post Code")
    }
}