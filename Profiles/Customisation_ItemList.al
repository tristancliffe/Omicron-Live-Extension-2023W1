pagecustomization "Teams Item List" customizes "Item List"
{
    layout
    {
        modify("Item Category Code") { Visible = false; }
        modify(Type) { Visible = false; }
        modify("Unit Cost") { Visible = false; }
        modify("Profit %") { Visible = false; }
    }
}