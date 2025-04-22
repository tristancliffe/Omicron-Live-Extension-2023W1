pageextension 50173 "General Journal Batches Ext" extends "General Journal Batches"
{
    views
    {
        addfirst
        {
            view(GeneralJournals)
            {
                Caption = 'General Journals';
                Filters = where("Template Type" = const(General), Recurring = const(false));
            }
            view(RecurringGenJournals)
            {
                Caption = 'Recurring General Journals';
                Filters = where("Template Type" = const(General), Recurring = const(true));
            }
            view(PurchaseJournals)
            {
                Caption = 'Purchase Journals';
                Filters = where("Template Type" = const(Purchases), Recurring = const(false));
            }
            view(SalesJournals)
            {
                Caption = 'Sales Journals';
                Filters = where("Template Type" = const(Sales), Recurring = const(false));
            }
        }
    }
}