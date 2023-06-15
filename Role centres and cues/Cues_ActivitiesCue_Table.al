tableextension 50110 ActivityCueTableExt extends "Activities Cue"
{
    fields
    {
        field(50100; OngoingPurchQuote; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Quote)));
            Caption = 'Ongoing Purchase Quotes';
            FieldClass = FlowField;
        }
        // field(50101; OngoingJobs; Integer)
        // {
        //     CalcFormula = count(Job where(Status = filter(Open)));
        //     Caption = 'Ongoing Jobs';
        //     FieldClass = FlowField;
        // }
        field(50101; CustomersOpen; Integer)
        {
            CalcFormula = count("Cust. Ledger Entry" where(Open = filter(true)));
            Caption = 'Open Customer Entries';
            FieldClass = FlowField;
        }
        field(50102; SuppliersOpen; Integer)
        {
            CalcFormula = count("Vendor Ledger Entry" where(Open = filter(true)));
            Caption = 'Open Vendor Entries';
            FieldClass = FlowField;
        }
        // field(50104; OpenTimeSheetsCue; Integer)
        // {
        //     CalcFormula = count("Time Sheet Header");
        //     Caption = 'Active Time Sheets';
        //     FieldClass = FlowField;
        // }
    }
}






// page 50101 "Other Cues"
// {
//     Caption = 'Other Cues';
//     PageType = CardPart;
//     RefreshOnActivate = true;
//     SourceTable = "Activities Cue";

//     layout
//     {
//         area(Content)
//         {
//             cuegroup(OtherCues)
//             {
//                 Caption = 'Jobs';
//                 field(OngoingJobsCue; Rec.OngoingJobs)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     DrillDownPageID = "Job List";
//                     ToolTip = 'Specifies number of currently active (Open) jobs';
//                     Caption = 'Active Jobs';
//                     Visible = true;
//                 }
//                 field(OpenTimeSheetsCue; Rec.OpenTimeSheetsCue)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     DrillDownPageId = "Time Sheet List";
//                     ToolTip = 'Number of active Time Sheets';
//                     Caption = 'Time Sheets';
//                     Visible = true;
//                 }
//             }
//         }
//     }
// }