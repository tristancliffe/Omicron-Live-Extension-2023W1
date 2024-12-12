pagecustomization "Teams Job Card" customizes "Job Card"
{
    layout
    {
        modify("Bill-to Customer No.") { Visible = false; }
        modify("Search Description") { Visible = false; }
        modify("External Document No.") { Visible = false; }
        modify("Your Reference") { Visible = false; }
        modify("Person Responsible") { Visible = false; }
        modify(Blocked) { Visible = false; }
        modify("Last Date Modified") { Visible = false; }
        modify("Project Manager") { Visible = false; }
        modify("Customer Balance") { Visible = false; }
        modify("Job Customer Notes") { Visible = false; }
        modify(Posting) { Visible = false; }
        modify("Invoice and Shipping") { Visible = false; }
        modify(Duration) { Visible = false; }
        modify("Foreign Trade") { Visible = false; }
        modify("WIP and Recognition") { Visible = false; }
    }
    actions
    {
        modify(invoicing) { Visible = false; }
        modify("W&IP") { Visible = false; }
        modify(Prices) { Visible = false; }
        modify("&Copy") { Visible = false; }
        modify(Action26) { Visible = false; }
    }
}