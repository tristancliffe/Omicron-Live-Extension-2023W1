page 50124 "Project Task List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Job Task";
    CardPageId = "Job Task Card";
    Editable = true;
    AdditionalSearchTerms = 'Job Task List, Job Task Line List, Project Task Line List';
    SourceTableView = sorting("Job Task No.") order(ascending);

    layout
    {
        area(Content)
        {
            repeater(List)
            {

                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = Basic, Suite, Jobs;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    Visible = false;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = Basic, Suite, Jobs;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite, Jobs;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                }
                field("Job Task Type"; Rec."Job Task Type")
                {
                    ApplicationArea = Basic, Suite, Jobs;

                    trigger OnValidate()
                    begin
                        StyleIsStrong := Rec."Job Task Type" <> Rec."Job Task Type"::Posting;
                        CurrPage.Update();
                    end;
                }
                field(Totaling; Rec.Totaling)
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Job Posting Group"; Rec."Job Posting Group")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DescriptionIndent := Rec.Indentation;
        StyleIsStrong := Rec."Job Task Type" <> "Job Task Type"::Posting;
        PostingTypeRow := Rec."Job Task Type" = "Job Task Type"::Posting;
    end;

    var
        DescriptionIndent: Integer;
        StyleIsStrong: Boolean;
        PostingTypeRow: Boolean;
}