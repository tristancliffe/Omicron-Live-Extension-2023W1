Page 50101 "Work Done Dialog"
{
    Caption = 'Work Done';
    PageType = StandardDialog;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            // group(Text)
            // {
            //     Caption = 'Text Entry';
            field(WorkDoneText; WorkDoneText)
            {
                Caption = 'Work done';
                ShowCaption = false;
                Multiline = true;
                Importance = Standard;

                trigger OnValidate()
                begin
                    CharacterCount := StrLen(WorkDoneText);
                end;
            }
            // }
            // group("Character Count")
            // {
            //     Caption = 'Character Counter';
            field(CharacterCount; CharacterCount)
            {
                Caption = 'No. of characters (max 700):';
                Editable = false;
                Importance = Promoted;
            }
            // }
        }
    }
    var
        WorkDoneText: text[700];
        CharacterCount: Integer;

    procedure GetText(_text: text[700])
    begin
        WorkDoneText := _text
    end;

    procedure SaveText(): Text[700]
    begin
        exit(WorkDoneText);
    end;

    trigger OnOpenPage()
    begin
        CharacterCount := StrLen(WorkDoneText);
    end;
}