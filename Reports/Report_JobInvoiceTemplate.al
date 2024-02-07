report 50109 "Job Invoice"
{
    Caption = 'Job Invoice';
    UsageCategory = Documents;
    ApplicationArea = All;
    DefaultRenderingLayout = JobInvoice;
    Description = 'Produces a job invoice template';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Job; Job)
        {
            RequestFilterFields = "No.";
            column(TodayFormatted; Format(Today, 0, 4))
            { }
            column(No_; "No.")
            { }
            column(Date_of_Arrival; Format("Date of Arrival", 0, 4))
            { }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            { }
            column(Car_Make_Model; "Car Make/Model")
            { }
            column(Sell_to_Address; "Sell-to Address")
            { }
            column(Sell_to_Address_2; "Sell-to Address 2")
            { }
            column(Sell_to_City; "Sell-to City")
            { }
            column(Sell_to_County; "Sell-to County")
            { }
            column(Sell_to_Post_Code; "Sell-to Post Code")
            { }
            column(Sell_to_Country_Region_Code; "Sell-to Country/Region Code")
            { }
            column(Vehicle_Reg; "Vehicle Reg")
            { }
            column(Description; Description)
            { }
            column(Job_Notes; "Job Notes")
            { }
            column(ChassisNo; ChassisNo)
            { }
            column(EngineNo; EngineNo)
            { }
            column(Mileage; Mileage)
            { }
        }
    }

    rendering
    {
        layout(JobInvoice)
        {
            Type = Word;
            LayoutFile = 'OmicronJobInvoiceTemplate.docx';
            Caption = 'Omicron Job Invoice';
            Summary = 'Omicron Template for Job Invoice';
        }
    }
}