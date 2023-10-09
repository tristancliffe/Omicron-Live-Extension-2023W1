// page 50103 "Phone Number Lists"
// {
//     ApplicationArea = All;
//     Caption = 'Phone Numbers';
//     Description = 'Lists of phone numbers';
//     PageType = Card;
//     ShowFilter = true;
//     Editable = false;
//     AboutTitle = 'Company Phone Numbers';
//     AboutText = 'This page shows a list of customer, supplier and employee phone numbers for exporting to the phone system for caller ID.';
//     UsageCategory = Lists;
//     layout
//     {
//         area(Content)
//         {
//             group(Customers)
//             {
//                 part("Customer Phone Number List"; "Customer Phone Number List")
//                 { }
//             }
//             group(Vendors)
//             {
//                 part("Vendor Phone Number List"; "Vendor Phone Number List")
//                 { }
//             }
//             group(Employees)
//             {
//                 part("Employee Phone Number List"; "Employee Phone Number List")
//                 { }
//             }
//         }
//     }
// }

// page 50104 "Customer Phone Number List"
// {
//     ApplicationArea = All;
//     PageType = ListPart;
//     SourceTable = Customer;
//     SourceTableView = where(Blocked = filter(" " | Invoice | Ship));
//     layout
//     {
//         area(Content)
//         {
//             repeater(Customers)
//             {
//                 field("No."; Rec."No.")
//                 { }
//                 field(Name; Rec.Name)
//                 { }
//                 field("Phone No."; Rec."Phone No.")
//                 { ExtendedDatatype = None; }
//                 field("Mobile Phone No."; Rec."Mobile Phone No.")
//                 { }
//             }
//         }
//     }
//     trigger OnOpenPage()
//     begin
//         Rec.SetRange("Phone Numbers Exist", true);
//     end;
// }

// page 50105 "Vendor Phone Number List"
// {
//     ApplicationArea = All;
//     PageType = ListPart;
//     SourceTable = Vendor;
//     SourceTableView = where(Blocked = filter(" " | Payment));
//     ShowFilter = true;
//     layout
//     {
//         area(Content)
//         {
//             repeater(Vendors)
//             {
//                 field("No."; Rec."No.")
//                 { }
//                 field(Name; Rec.Name)
//                 { }
//                 field("Phone No."; Rec."Phone No.")
//                 { }
//                 field("Mobile Phone No."; Rec."Mobile Phone No.")
//                 { }
//             }
//         }
//     }

//     trigger OnOpenPage()
//     begin
//         Rec.SetRange("Phone Numbers Exist", true);
//     end;
// }

// page 50106 "Employee Phone Number List"
// {
//     ApplicationArea = All;
//     PageType = ListPart;
//     SourceTable = Employee;
//     //SourceTableView = where(Status = filter(Active));
//     ShowFilter = true;
//     layout
//     {
//         area(Content)
//         {
//             repeater(Vendors)
//             {
//                 field("First Name"; Rec."First Name")
//                 { }
//                 field("Last Name"; Rec."Last Name")
//                 { }
//                 field("Phone No."; Rec."Phone No.")
//                 { ExtendedDatatype = None; }
//                 field("Mobile Phone No."; Rec."Mobile Phone No.")
//                 { ExtendedDatatype = None; }
//             }
//         }
//     }

//     trigger OnOpenPage()
//     begin
//         Rec.SetRange("Phone Numbers Exist", true);
//     end;
// }