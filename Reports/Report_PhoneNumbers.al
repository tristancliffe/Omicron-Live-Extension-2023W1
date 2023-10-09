report 50107 "Phone Numbers"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = PhoneNumbers;
    Caption = 'Phone Numbers List';
    //ExcelLayoutMultipleDataSheets = true;


    dataset
    {
        dataitem(Customers; Customer)
        {
            DataItemTableView = sorting("No.") where(Blocked = filter(" " | Invoice | Ship));
            column(Customer_No_; "No.")
            { }
            column(Customer_Name; Name)
            { }
            column(Customer_Phone_No_; ConvertStr(DelChr(DelChr("Phone No."), '=', '-().'), '++', '00'))
            { }
            column(Customer_Mobile_Phone_No_; ConvertStr(DelChr(DelChr("Mobile Phone No."), '=', '-().'), '++', '00'))
            { }
            trigger OnAfterGetRecord()
            begin
                if not "Phone Numbers Exist" then
                    CurrReport.Skip();
            end;
        }
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = sorting("No.") where(Blocked = filter(" " | Payment));
            column(Vendor_No_;
            "No.")
            { }
            column(Vendor_No_Name; Name)
            { }
            column(Vendor_No_Phone_No_; ConvertStr(DelChr(DelChr("Phone No."), '=', '-().'), '++', '00'))
            { }
            column(Vendor_No_Mobile_Phone_No_; ConvertStr(DelChr(DelChr("Mobile Phone No."), '=', '-().'), '++', '00'))
            { }
            trigger OnAfterGetRecord()
            begin
                if not "Phone Numbers Exist" then
                    CurrReport.Skip();
            end;
        }
        dataitem(Employee; Employee)
        {
            DataItemTableView = sorting("No.");
            column(Employee_First_Name; "First Name")
            { }
            column(Employee_Last_Name; "Last Name")
            { }
            column(Employee_Phone_No_; ConvertStr(DelChr(DelChr("Phone No."), '=', '-().'), '++', '00'))
            { }
            column(Employee_Mobile_Phone_No_; ConvertStr(DelChr(DelChr("Mobile Phone No."), '=', '-().'), '++', '00'))
            { }
            trigger OnAfterGetRecord()
            begin
                if not "Phone Numbers Exist" then
                    CurrReport.Skip();
            end;
        }
    }
    rendering
    {
        layout(PhoneNumbers)
        {
            Type = Excel;
            LayoutFile = 'Omicron_Phone_Numbers.xlsx';
            Caption = 'Phone Number Export';
            Summary = 'Excel Export of Customer, Vendor and Employee phone numbers for VOIP systems';
        }
    }
}