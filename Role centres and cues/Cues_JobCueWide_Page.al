page 50105 "Job Cues"
{
    Caption = 'Projects';
    PageType = CardPart;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "Job Cue";

    layout
    {
        area(content)
        {
            cuegroup(JobsToInvoice)
            {
                Caption = 'Projects To Invoice';
                CuegroupLayout = Wide;
                field(Invoiceable; Rec.Invoiceable)
                {
                    ApplicationArea = All;
                    Image = Cash;
                    ToolTip = 'The amount that can be currently be invoiced from all Active projects - check stock and time sheets are up to date before doing so.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        Rec.SetFilter("Date Filter", '>=%1', WorkDate());
        Rec.SetFilter("Date Filter2", '<%1&<>%2', WorkDate(), 0D);
        Rec.SetRange("User ID Filter", UserId());

        ShowIntelligentCloud := not EnvironmentInfo.IsSaaS();
    end;

    var
        EnvironmentInfo: Codeunit "Environment Information";
        ShowIntelligentCloud: Boolean;

    procedure RefreshRoleCenter()
    begin
        CurrPage.Update();
    end;
}

