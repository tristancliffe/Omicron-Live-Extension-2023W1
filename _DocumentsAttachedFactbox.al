pageextension 50215 DocumentAttachmentFactboxExt extends "Document Attachment Factbox"
{
    layout
    {
        addlast(Control2)
        {
            repeater(Attachments)
            {
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                    Caption = 'Attachment';

                    trigger OnDrillDown()
                    begin
                        if Rec."File Name" <> '' then
                            Rec.Export(true);
                    end;
                }
                field("File Type"; Rec."File Type")
                {
                    ApplicationArea = All;
                    Caption = 'File Type';
                }
            }
        }
    }
}