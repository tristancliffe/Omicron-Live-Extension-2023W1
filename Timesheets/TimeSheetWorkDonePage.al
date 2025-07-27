Page 50101 "Work Done Dialog"
{
    Caption = 'Work Detail Worksheet';
    PageType = StandardDialog;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field(Instructions1; Instructions1) { ShowCaption = false; Style = StrongAccent; }
            field(Instructions2; Instructions2) { ShowCaption = false; Style = StrongAccent; }
            field(WorkDoneText; WorkDoneText)
            {
                Caption = 'Work done';
                ShowCaption = false;
                Multiline = true;
                Importance = Standard;
                InstructionalText = 'Type as much description of the work done here as appropriate.';

                trigger OnValidate()
                begin
                    CharacterCount := StrLen(WorkDoneText);
                end;
            }
            field(CharacterCount; CharacterCount)
            {
                Caption = 'No. of characters (max 700):';
                Editable = false;
                Importance = Promoted;
            }
            field(Reminder1; Reminder1) { ShowCaption = false; Style = Unfavorable; }
            field(Reminder2; Reminder2) { ShowCaption = false; Style = Unfavorable; }
        }
    }
    var
        WorkDoneText: text[700];
        CharacterCount: Integer;
        Instructions1: Label 'Type your text below. To save it click OK.';
        Instructions2: Label 'For long entries, consider clicking OK occasionally then editing again to save progress.';
        Reminder1: Label 'DON''T FORGET TO SUBMIT YOUR TIMESHEETS REGULARLY (DAILY) WHEN FINISHED.';
        Reminder2: Label 'DON''T FORGET TO TAKE AND UPLOAD PICTURES/VIDEOS OF PROGRESS.';

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