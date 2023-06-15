// pageextension 50174 SentEmailExt extends "Sent Emails"
// {
//     layout
//     {
//         addafter(SentFrom)
//         {
//             field(ToField; ToRecipient)
//             { }
//         }
//     }
//     trigger OnAfterGetRecord()
//     Begin
//         ToRecipient := EmailMessageImpl.GetRecipientsAsText(Enum::"Email Recipient Type"::"To");
//     End;

//     var
//         ToRecipient: Text;
//         EmailMessageImpl: Codeunit "EmailCodeunit";
// }

// codeunit 50101 "EmailCodeunit"
// {
//     Access = Internal;
//     InherentPermissions = X;
//     InherentEntitlements = X;
//     Permissions = tabledata "Sent Email" = r,
//                   tabledata "Email Outbox" = rim,
//                                     tabledata "Email Recipient" = rid;

//     procedure GetRecipients(): List of [Text]
//     var
//         EmailRecipients: Record "Email Recipient";
//     begin
//         EmailRecipients.SetRange("Email Message Id", GlobalEmailMessage.Id);
//         exit(GetEmailAddressesOfRecipients(EmailRecipients));
//     end;

//     procedure GetRecipients(RecipientType: Enum "Email Recipient Type"): List of [Text]
//     var
//         EmailRecipients: Record "Email Recipient";
//     begin
//         EmailRecipients.SetRange("Email Message Id", GlobalEmailMessage.Id);
//         EmailRecipients.SetRange("Email Recipient Type", RecipientType);
//         exit(GetEmailAddressesOfRecipients(EmailRecipients));
//     end;

//     local procedure GetEmailAddressesOfRecipients(var EmailRecipients: Record "Email Recipient"): List of [Text]
//     var
//         Recipients: List of [Text];
//     begin
//         if EmailRecipients.FindSet() then
//             repeat
//                 Recipients.Add(EmailRecipients."Email Address");
//             until EmailRecipients.Next() = 0;
//         exit(Recipients);
//     end;

//     procedure GetRecipientsAsText(RecipientType: Enum "Email Recipient Type"): Text
//     var
//         RecipientList: List of [Text];
//         Recipient, Result : Text;
//     begin
//         RecipientList := GetRecipients(RecipientType);

//         foreach Recipient in RecipientList do
//             Result += ';' + Recipient;

//         Result := Result.TrimStart(';'); // trim extra semicolon
//         exit(Result);
//     end;


//     var
//         GlobalEmailMessage: Record "Email Message";
//         GlobalEmailMessageAttachment: Record "Email Message Attachment";

// }