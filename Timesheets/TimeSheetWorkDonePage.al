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

                // trigger OnValidate()
                // begin
                //     CharacterCount := StrLen(WorkDoneText);
                // end;
            }
            // field(CharacterCount; CharacterCount)
            // {
            //     Caption = 'No. of characters';
            //     Editable = false;
            // }
        }
    }
    var
        WorkDoneText: text[700];
    // CharacterCount: Integer;

    procedure GetText(_text: text[700])
    begin
        WorkDoneText := _text
    end;

    procedure SaveText(): Text[700]
    begin
        exit(WorkDoneText);
    end;

    // trigger OnOpenPage()
    // begin
    //     CharacterCount := StrLen(WorkDoneText);
    // end;
}