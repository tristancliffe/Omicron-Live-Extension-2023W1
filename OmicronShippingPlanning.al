// pageextension 50225 ShipmentPlanningExt extends WSB_ShipmentPlanningAI
// {
//     layout
//     {
//         addafter("No.")
//         {
//             field(Amount; Rec.Amount)
//             { ApplicationArea = All; }
//         }
//     }
//     trigger OnOpenPage()
//     begin
//         Rec.SetCurrentKey("No.");
//         Rec.Ascending(false);
//         Rec.FindFirst
//     end;
// }


// ,
//     {
//       "id": "6e269270-915c-4c53-919c-126cfcad6a76",
//       "name": "Inventory Availability Indicators",
//       "version": "1.52.0.0",
//       "publisher": "Apportunix"
//     }