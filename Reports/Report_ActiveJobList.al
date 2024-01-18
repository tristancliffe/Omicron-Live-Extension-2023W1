report 50106 "Active Jobs"
{
    ApplicationArea = All;
    Caption = 'Active Jobs';
    Description = 'Prints a list of active, non-admin jobs';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Word;
    WordLayout = './OmicronActiveJobs.docx';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Job; Job)
        {
            RequestFilterFields = "No.", "Status";
            DataItemTableView = SORTING("No.");
            column(TodayFormatted; Format(Today, 0, 4))
            { }
            column(No_Job; "No.")
            { }
            column(Description_Job; Description)
            { }
            column(BilltoName_Job; "Bill-to Name")
            { }
            column(VehicleReg_Job; "Vehicle Reg")
            { }
            column(DateofArrival_Job; "Date of Arrival")
            { }
            column(CarMakeModel_Job; "Car Make/Model")
            { }
            column(ChassisNo_Job; ChassisNo)
            { }
            column(EngineNo_Job; EngineNo)
            { }
            column(ToInvoice; ToInvoice)
            { }
            // trigger OnAfterGetRecord()
            // var
            //     i: Integer;
            //     match: Boolean;
            //     substring: Text[5];
            // begin
            //     if Status <> Status::Open then
            //         CurrReport.Skip();
            //     if Status = Status::Open then begin
            //         substring := 'ADMIN';
            //         match := true;
            //         i := 1;
            //         while (i <= 5) and match do begin
            //             if "No."[i] <> substring[i] then
            //                 match := false;
            //             i := i + 1;
            //         end;
            //         if match then
            //             CurrReport.Skip();
            //         substring := 'CLIFF';
            //         match := true;
            //         i := 1;
            //         while (i <= 5) and match do begin
            //             if "No."[i] <> substring[i] then
            //                 match := false;
            //             i := i + 1;
            //         end;
            //         if match then
            //             CurrReport.Skip();
            //     end;
            // end;
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        { }
        actions
        { }
    }
    labels
    {
        Lbl_ReportName = 'Active Jobs', Comment = 'Report name';
        Lbl_CompanyName = 'Omicron Engineering Ltd.';
        Lbl_JobNo = 'Job No.';
        Lbl_Customer = 'Customer';
        Lbl_Vehicle = 'Make/Model';
        Lbl_Description = 'Description';
        Lbl_RegNo = 'Reg.:';
        Lbl_ChassisNo = 'Chassis No.:';
        Lbl_EngineNo = 'Engine No.:';
        Lbl_DateArrived = 'Date in:';
        Lbl_ValveToInvoice = '£ to inv:';
    }
}
