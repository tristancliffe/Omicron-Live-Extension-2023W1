// codeunit 50104 MessageHandlePurch
// {
//     [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnShowEarlyOrderDateMessageOnAfterCalcShowMessage, '', false, false)]
//     local procedure OnShowEarlyOrderDateMessageOnAfterCalcShowMessage(PurchaseLine: Record "Purchase Line"; var ShowMessage: Boolean);
//     begin
//         ShowMessage := false;
//     end;
// }