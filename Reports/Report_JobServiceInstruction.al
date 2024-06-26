report 50104 "Service Instruction"
{
    Caption = 'Service Instruction';
    UsageCategory = Documents;
    ApplicationArea = All;
    DefaultRenderingLayout = ServiceInstruction;
    Description = 'Produces a project Service Instruction card';
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
            column(Sell_to_Phone_No_; "Sell-to Phone No.")
            { }
            column(Sell_to_Mobile_Number; "Sell-to Mobile Number")
            { }
            column(Sell_to_E_Mail; "Sell-to E-Mail")
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

    // requestpage
    // {
    // layout
    // {
    //     area(Content)
    //     {
    //         group(GroupName)
    //         {
    //             field(Name; SourceExpression)
    //             {
    //                 ApplicationArea = All;

    //             }
    //         }
    //     }
    // }
    // }
    rendering
    {
        layout(ServiceInstruction)
        {
            Type = Word;
            LayoutFile = 'OmicronJobCard.docx';
            Caption = 'Omicron Job Card';
            Summary = 'Omicron Job Card';
        }
        layout(JobInvoice)
        {
            Type = Word;
            LayoutFile = 'OmicronJobInvoice.docx';
            Caption = 'Omicron Job Invoice';
            Summary = 'Omicron Template for Job Invoice';
        }
    }
}