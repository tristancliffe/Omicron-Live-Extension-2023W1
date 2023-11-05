tableextension 50105 JobNotes extends Job
{
    fields
    {
        // modify("No.")
        // {
        //     trigger OnAfterValidate()
        //     var
        //         DefaultTask: Record "Job Task";
        //     begin

        //     end;
        // }
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                DimensionValue: record "Dimension Value";
                DimensionDefault: Record "Default Dimension";
                DefaultTask: Record "Job Task";
                DefaultTaskDimension: Record "Job Task Dimension";
                VarPurch: Code[10];
                VarStock: Code[10];
                VarSubContr: Code[11];
                VarTransp: Code[10];
                VarAdmin: Code[5];
                Workshop: Code[10];
                PartsDept: Code[10];
                JobPostingGroup: Code[3];
                Customer: Record Customer;
            begin
                VarPurch := 'PURCHASES';
                VarStock := 'STOCK';
                VarSubContr := 'SUBCONTRACT';
                VarTransp := 'TRANSPORT';
                VarAdmin := 'ADMIN';
                Workshop := 'WORKSHOP';
                PartsDept := 'PARTSDEPT';
                JobPostingGroup := 'JOB';
                "Your Reference" := CopyStr("No." + ' ' + "Sell-to Customer No." + ' ' + "Car Make/Model", 1, MaxStrLen("Your Reference"));

                DimensionValue.Reset();
                DimensionValue.SetRange("Dimension Code", 'JOB NO');
                DimensionValue.SetRange("Code", "No.");
                if not DimensionValue.FindSet() then begin
                    DimensionValue.Init();
                    DimensionValue.Validate("Dimension Code", 'JOB NO');
                    DimensionValue.Validate(Code, Rec."No.");
                    DimensionValue.Validate(Name, CopyStr(Rec.Description, 1, MaxStrLen(DimensionValue.Name)));
                    DimensionValue.Validate("Dimension Value Type", DimensionValue."Dimension Value Type"::Standard);
                    DimensionValue.Insert();
                end;
                DimensionDefault.Init();
                DimensionDefault.Validate("Table ID", 167);
                DimensionDefault.Validate("No.", Rec."No.");
                DimensionDefault.Validate("Dimension Code", 'JOB NO');
                DimensionDefault.Validate("Dimension Value Code", Rec."No.");
                DimensionDefault.Validate("Value Posting", DimensionDefault."Value Posting"::"Code Mandatory");
                DimensionDefault.Insert();
                DimensionDefault.Init();
                DimensionDefault.Validate("Table ID", 167);
                DimensionDefault.Validate("No.", Rec."No.");
                DimensionDefault.Validate("Dimension Code", 'DEPARTMENT');
                if StrPos(rec."No.", 'P') = 1 then
                    DimensionDefault.Validate("Dimension Value Code", PartsDept)
                else
                    DimensionDefault.Validate("Dimension Value Code", Workshop);
                DimensionDefault.Validate("Value Posting", DimensionDefault."Value Posting"::"Code Mandatory");
                DimensionDefault.Insert();
                DimensionDefault.Init();
                DimensionDefault.Validate("Table ID", 167);
                DimensionDefault.Validate("No.", Rec."No.");
                DimensionDefault.Validate("Dimension Code", 'PROJECTTYPE');
                if StrPos(rec."No.", 'P') = 1 then
                    DimensionDefault.Validate("Dimension Value Code", PartsDept)
                else
                    DimensionDefault.Validate("Dimension Value Code", Workshop);
                DimensionDefault.Validate("Value Posting", DimensionDefault."Value Posting"::"Code Mandatory");
                DimensionDefault.Insert();
                Message('Please check Dimension values for Department and Job Type, if not WORKSHOP.\ \Workshop J-Jobs should be Department = WORKSHOP and Project Type = WORKSHOP. \Bodyshop J-Jobs should be Department = BODYSHOP and Project Type = BODYSHOP. \Parts Department P-Jobs should be Department = WORKSHOP/BODYSHOP and Project Type = PARTSDEPT.');

                DefaultTask.Init();
                DefaultTask."Job No." := Rec."No.";
                DefaultTask."Job Task No." := VarStock;
                DefaultTask.Description := 'Stock used on job';
                DefaultTask."Job Task Type" := DefaultTask."Job Task Type"::Posting;
                DefaultTask."Job Posting Group" := JobPostingGroup;
                DefaultTask.Insert();
                DefaultTaskDimension.Init();
                DefaultTaskDimension."Job No." := Rec."No.";
                DefaultTaskDimension."Job Task No." := VarStock;
                DefaultTaskDimension.Validate("Dimension Code", 'DEPARTMENT');
                if StrPos(rec."No.", 'P') = 1 then
                    DefaultTaskDimension.Validate("Dimension Value Code", PartsDept)
                else
                    DefaultTaskDimension.Validate("Dimension Value Code", Workshop);
                DefaultTaskDimension.Insert();
                DefaultTaskDimension.Init();
                DefaultTaskDimension."Job No." := Rec."No.";
                DefaultTaskDimension."Job Task No." := VarStock;
                DefaultTaskDimension.Validate("Dimension Code", 'JOB NO');
                DefaultTaskDimension.Validate("Dimension Value Code", Rec."No.");
                DefaultTaskDimension.Insert();
                DefaultTaskDimension.Init();
                DefaultTaskDimension."Job No." := Rec."No.";
                DefaultTaskDimension."Job Task No." := VarStock;
                DefaultTaskDimension.Validate("Dimension Code", 'PROJECTTYPE');
                if StrPos(rec."No.", 'P') = 1 then
                    DefaultTaskDimension.Validate("Dimension Value Code", PartsDept)
                else
                    DefaultTaskDimension.Validate("Dimension Value Code", Workshop);
                DefaultTaskDimension.Insert();

                DefaultTask.Init();
                DefaultTask."Job No." := Rec."No.";
                DefaultTask."Job Task No." := VarPurch;
                DefaultTask.Description := 'Purchases made for job';
                DefaultTask."Job Task Type" := DefaultTask."Job Task Type"::Posting;
                DefaultTask."Job Posting Group" := JobPostingGroup;
                DefaultTask.Insert();
                DefaultTaskDimension.Init();
                DefaultTaskDimension."Job No." := Rec."No.";
                DefaultTaskDimension."Job Task No." := VarPurch;
                DefaultTaskDimension.Validate("Dimension Code", 'DEPARTMENT');
                if StrPos(rec."No.", 'P') = 1 then
                    DefaultTaskDimension.Validate("Dimension Value Code", PartsDept)
                else
                    DefaultTaskDimension.Validate("Dimension Value Code", Workshop);
                DefaultTaskDimension.Insert();
                DefaultTaskDimension.Init();
                DefaultTaskDimension."Job No." := Rec."No.";
                DefaultTaskDimension."Job Task No." := VarPurch;
                DefaultTaskDimension.Validate("Dimension Code", 'JOB NO');
                DefaultTaskDimension.Validate("Dimension Value Code", Rec."No.");
                DefaultTaskDimension.Insert();
                DefaultTaskDimension.Init();
                DefaultTaskDimension."Job No." := Rec."No.";
                DefaultTaskDimension."Job Task No." := VarPurch;
                DefaultTaskDimension.Validate("Dimension Code", 'PROJECTTYPE');
                if StrPos(rec."No.", 'P') = 1 then
                    DefaultTaskDimension.Validate("Dimension Value Code", PartsDept)
                else
                    DefaultTaskDimension.Validate("Dimension Value Code", Workshop);
                DefaultTaskDimension.Insert();

                DefaultTask.Init();
                DefaultTask."Job No." := Rec."No.";
                DefaultTask."Job Task No." := VarSubContr;
                DefaultTask.Description := 'Subcontracted services used for job';
                DefaultTask."Job Task Type" := DefaultTask."Job Task Type"::Posting;
                DefaultTask."Job Posting Group" := JobPostingGroup;
                DefaultTask.Insert();
                DefaultTaskDimension.Init();
                DefaultTaskDimension."Job No." := Rec."No.";
                DefaultTaskDimension."Job Task No." := VarSubContr;
                DefaultTaskDimension.Validate("Dimension Code", 'DEPARTMENT');
                if StrPos(rec."No.", 'P') = 1 then
                    DefaultTaskDimension.Validate("Dimension Value Code", PartsDept)
                else
                    DefaultTaskDimension.Validate("Dimension Value Code", Workshop);
                DefaultTaskDimension.Insert();
                DefaultTaskDimension.Init();
                DefaultTaskDimension."Job No." := Rec."No.";
                DefaultTaskDimension."Job Task No." := VarSubContr;
                DefaultTaskDimension.Validate("Dimension Code", 'JOB NO');
                DefaultTaskDimension.Validate("Dimension Value Code", Rec."No.");
                DefaultTaskDimension.Insert();
                DefaultTaskDimension.Init();
                DefaultTaskDimension."Job No." := Rec."No.";
                DefaultTaskDimension."Job Task No." := VarSubContr;
                DefaultTaskDimension.Validate("Dimension Code", 'PROJECTTYPE');
                if StrPos(rec."No.", 'P') = 1 then
                    DefaultTaskDimension.Validate("Dimension Value Code", PartsDept)
                else
                    DefaultTaskDimension.Validate("Dimension Value Code", Workshop);
                DefaultTaskDimension.Insert();

                DefaultTask.Init();
                DefaultTask."Job No." := Rec."No.";
                DefaultTask."Job Task No." := VarTransp;
                DefaultTask.Description := 'Transport mileage on our trailer';
                DefaultTask."Job Task Type" := DefaultTask."Job Task Type"::Posting;
                DefaultTask."Job Posting Group" := JobPostingGroup;
                DefaultTask.Insert();
                DefaultTaskDimension.Init();
                DefaultTaskDimension."Job No." := Rec."No.";
                DefaultTaskDimension."Job Task No." := VarTransp;
                DefaultTaskDimension.Validate("Dimension Code", 'DEPARTMENT');
                DefaultTaskDimension.Validate("Dimension Value Code", 'TRANSPORT');
                DefaultTaskDimension.Insert();
                DefaultTaskDimension.Init();
                DefaultTaskDimension."Job No." := Rec."No.";
                DefaultTaskDimension."Job Task No." := VarTransp;
                DefaultTaskDimension.Validate("Dimension Code", 'JOB NO');
                DefaultTaskDimension.Validate("Dimension Value Code", Rec."No.");
                DefaultTaskDimension.Insert();
                DefaultTaskDimension.Init();
                DefaultTaskDimension."Job No." := Rec."No.";
                DefaultTaskDimension."Job Task No." := VarTransp;
                DefaultTaskDimension.Validate("Dimension Code", 'PROJECTTYPE');
                if StrPos(rec."No.", 'P') = 1 then
                    DefaultTaskDimension.Validate("Dimension Value Code", PartsDept)
                else
                    DefaultTaskDimension.Validate("Dimension Value Code", Workshop);
                DefaultTaskDimension.Insert();

                DefaultTask.Init();
                DefaultTask."Job No." := Rec."No.";
                DefaultTask."Job Task No." := VarAdmin;
                DefaultTask.Description := 'Admin and clerical time';
                DefaultTask."Job Task Type" := DefaultTask."Job Task Type"::Posting;
                DefaultTask."Job Posting Group" := JobPostingGroup;
                DefaultTask.Insert();
                DefaultTaskDimension.Init();
                DefaultTaskDimension."Job No." := Rec."No.";
                DefaultTaskDimension."Job Task No." := VarAdmin;
                DefaultTaskDimension.Validate("Dimension Code", 'DEPARTMENT');
                if StrPos(rec."No.", 'P') = 1 then
                    DefaultTaskDimension.Validate("Dimension Value Code", PartsDept)
                else
                    DefaultTaskDimension.Validate("Dimension Value Code", Workshop);
                DefaultTaskDimension.Insert();
                DefaultTaskDimension.Init();
                DefaultTaskDimension."Job No." := Rec."No.";
                DefaultTaskDimension."Job Task No." := VarAdmin;
                DefaultTaskDimension.Validate("Dimension Code", 'JOB NO');
                DefaultTaskDimension.Validate("Dimension Value Code", Rec."No.");
                DefaultTaskDimension.Insert();
                DefaultTaskDimension.Init();
                DefaultTaskDimension."Job No." := Rec."No.";
                DefaultTaskDimension."Job Task No." := VarAdmin;
                DefaultTaskDimension.Validate("Dimension Code", 'PROJECTTYPE');
                if StrPos(rec."No.", 'P') = 1 then
                    DefaultTaskDimension.Validate("Dimension Value Code", PartsDept)
                else
                    DefaultTaskDimension.Validate("Dimension Value Code", Workshop);
                DefaultTaskDimension.Insert();

                Rec.Validate("Starting Date", Today);
                Rec.Validate("Date of Arrival", Today);
                Customer.SetRange("No.", Rec."Sell-to Customer No.");
                if Customer.FindSet() then begin
                    Rec.Validate("Sell-to Mobile Number", Customer."Mobile Phone No.");
                end;
            end;
        }
        field(50100; "Parts Location"; Text[100])
        { CaptionML = ENU = 'Parts Location'; DataClassification = CustomerContent; }
        field(50101; "Vehicle Reg"; Text[20])
        { CaptionML = ENU = 'Vehicle Reg'; DataClassification = CustomerContent; }
        field(50102; "Date of Arrival"; Date)
        { CaptionML = ENU = 'Date of Arrival'; DataClassification = CustomerContent; }
        field(50103; "Job Notes"; Text[1000])
        { CaptionML = ENU = 'Job Notes'; DataClassification = CustomerContent; }
        field(50104; "Car Make/Model"; Text[100])
        { CaptionML = ENU = 'Car Make/Model/Series'; DataClassification = CustomerContent; }
        field(50105; "Work Required"; Text[500])
        { CaptionML = ENU = 'Work Required'; DataClassification = CustomerContent; }
        field(50106; "Sell-to Mobile Number"; Text[30])
        { Caption = 'Mobile No.'; DataClassification = CustomerContent; ExtendedDatatype = PhoneNo; }
        field(50107; TotalHours; Decimal)
        {
            Caption = 'Total Hours';
            FieldClass = FlowField;
            CalcFormula = sum("Job Ledger Entry".Quantity where("Job No." = field("No."),
                                                                "Entry Type" = filter('Usage'),
                                                                Type = filter('Resource'),
                                                                "Unit of Measure Code" = filter('HOUR')));
        }
        field(50108; InvoicedHours; Decimal)
        {
            Caption = 'Invoiced Hours';
            FieldClass = FlowField;
            CalcFormula = sum("Job Ledger Entry".Quantity where("Job No." = field("No."),
                                                                "Entry Type" = filter('Sale'),
                                                                Type = filter('Resource'),
                                                                "Unit of Measure Code" = filter('HOUR')));
        }
        field(50109; ChassisNo; Code[30])
        { CaptionML = ENU = 'Chassis No.'; DataClassification = CustomerContent; }
        field(50110; EngineNo; Code[30])
        { CaptionML = ENU = 'Engine No.'; DataClassification = CustomerContent; }
        field(50111; Mileage; Code[30])
        { CaptionML = ENU = 'Recorded mileage'; DataClassification = CustomerContent; }
        field(50112; TotalValue; Decimal)
        {
            Caption = 'Committed Value';
            FieldClass = FlowField;
            CalcFormula = sum("Job Ledger Entry"."Total Cost" where("Job No." = field("No."),
                                                                "Entry Type" = filter('Usage')));
            AutoFormatExpression = '£<precision, 2:2><standard format, 0>';
            AutoFormatType = 1;
        }
        field(50113; InvoicedValue; Decimal)
        {
            Caption = 'Invoiced Value';
            FieldClass = FlowField;
            CalcFormula = sum("Job Ledger Entry"."Total Price" where("Job No." = field("No."),
                                                                "Entry Type" = filter('Sale')));
            AutoFormatExpression = '£<precision, 2:2><standard format, 0>';
            AutoFormatType = 1;
        }
    }

    fieldgroups
    {
        addlast(DropDown; "Car Make/Model", "Vehicle Reg")
        { }
    }

    trigger OnAfterModify()
    begin
        Validate("Parts Location", UpperCase("Parts Location"));
        Validate("Vehicle Reg", UpperCase("Vehicle Reg"));
        Validate("Car Make/Model", UpperCase("Car Make/Model"));
        Validate("Work Required", UpperCase("Work Required"));
    end;
}
