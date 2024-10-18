pageextension 50215 DocumentAttachmentFactboxExt extends "Doc. Attachment List Factbox"
{
    layout
    {
        addlast(Group)
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