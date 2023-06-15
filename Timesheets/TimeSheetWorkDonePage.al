Page 50101 "Work Done Dialog"
{
    Caption = 'Work Done';
    PageType = StandardDialog;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field(WorkDoneText; WorkDoneText)
            {
                Caption = 'Work done';
                ShowCaption = false;
                Multiline = true;
            }
        }
    }
    var
        WorkDoneText: text[700];

    procedure GetText(_text: text[700])
    begin
        WorkDoneText := _text
    end;

    procedure SaveText(): Text[700]
    begin
        exit(WorkDoneText);
    end;
}