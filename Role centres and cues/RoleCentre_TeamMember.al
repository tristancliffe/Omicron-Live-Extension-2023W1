pageextension 50121 TeamMemberRoleExt extends "Team Member Role Center"
{
    layout
    {
        modify(Control7) { Visible = false; }
        modify(Emails) { Visible = false; }
        modify(ApprovalsActivities) { Visible = false; }
        modify(Control4) { Visible = false; }
        modify("Job Queue Tasks Activities") { Visible = false; }
    }
    actions
    {
        movefirst(Embedding; Sales_CustomerList)
        moveafter(Sales_CustomerList; Purchase_VendorList)
        addafter(Purchase_VendorList)
        {
            action("Item List")
            { ApplicationArea = All; CaptionML = ENG = 'Items', ENU = 'Items'; RunObject = page "Item List"; }
            action("Job List")
            { ApplicationArea = All; CaptionML = ENG = 'Projects', ENU = 'Projects'; RunObject = page "Job List"; RunPageView = where(Status = filter(Open | Quote | Planning)); }
            action("Job Journal")
            { ApplicationArea = All; CaptionML = ENG = 'Project Journals', ENU = 'Project Journals'; RunObject = page "Job Journal"; Visible = false; }
        }
        modify(Finance) { Visible = false; }
        modify(Sales) { Visible = false; }
        modify(Purchasing) { Visible = false; }
    }
}