report 50108 "Timesheet Instructions"
{
    ApplicationArea = All;
    Caption = 'Timesheet Instructions';
    Description = 'Shows the timesheet instructions';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Word;
    WordLayout = './OmicronTimeSheetInstructions.docx';
    PreviewMode = PrintLayout;

    // dataset
    // {
    //     dataitem(Job; Job)
    //     {
    //         RequestFilterFields = "No.", "Status";
    //         DataItemTableView = SORTING("No.");
    //         column(No_Job; "No.")
    //         { }
    //     }
    // }
    // requestpage
    // {
    //     SaveValues = true;

    //     layout
    //     { }
    //     actions
    //     { }
    // }

}
