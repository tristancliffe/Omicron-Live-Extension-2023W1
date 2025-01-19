page 50114 "API Job Planning Lines"
{
    DelayedInsert = true;
    APIVersion = 'v2.0';
    EntityCaption = 'Project Planning Line';
    EntitySetCaption = 'Project Planning Lines';
    PageType = API;
    APIPublisher = 'Omicron';
    APIGroup = 'Projects';
    ODataKeyFields = SystemId;
    EntityName = 'projectplanningline';
    EntitySetName = 'projectplanninglines';
    SourceTable = "Job Planning Line";
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(PlanningLines)
            {
                field(id; Rec.SystemId) { }
                field("LineType"; LineType) { }
                field("JobNo"; Rec."Job No.") { }
                field("JobTaskNo"; Rec."Job Task No.") { }
                field("PlanningDate"; Rec."Planning Date") { }
                field(Type; Rec.Type) { }
                field("No"; Rec."No.") { }
                field("UnitOfMeasure"; Rec."Unit of Measure Code") { }
                field(Quantity; Rec.Quantity) { }
                field("TotalCost"; Rec.InvoiceCost) { }
                field("TotalInvoice"; Rec.InvoicePrice) { }
                field(TotalInvoiced; Rec."Invoiced Amount (LCY)") { }
            }
        }
    }
    var
        LineType: Text[24];

    trigger OnAfterGetRecord()
    begin
        case rec."Line Type" of
            Rec."Line Type"::Billable:
                LineType := 'Billable';
            Rec."Line Type"::"Both Budget and Billable":
                LineType := 'Both Budget and Billable';
            Rec."Line Type"::Budget:
                LineType := 'Budget';
        end;
    end;
}