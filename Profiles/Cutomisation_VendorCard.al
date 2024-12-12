pagecustomization "Teams Vendor Card" customizes "Vendor Card"
{
    layout
    {
        modify("Balance (LCY)") { Visible = false; }
        modify("Balance Due (LCY)") { Visible = false; }
        modify(BalanceAsCustomer) { Visible = false; }
        modify("Search Name") { Visible = false; }
        modify(Invoicing) { Visible = false; }
        modify(Payments) { Visible = false; }
        modify(Receiving) { Visible = false; }
    }
}