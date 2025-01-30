// The extension extends the existing "Customer" table with three additional fields.
// The first field is "Customer Notes," a text field with a length of 2000 characters.
// The second field is "Vehicle Model," a text field with a length of 100 characters.
// The third field is a calculated field called "No. of Jobs," which counts the number of ongoing jobs with a customer.
// The extension also includes two triggers.
// The first trigger is an OnAfterModify trigger that converts the "Vehicle Model" field value to uppercase after a modification is made to the record.
// The second trigger is an OnBeforeDelete trigger that generates a random warning message asking the user to confirm the deletion of the record. The message is randomly selected from a list of 25 messages.
// If the user confirms the deletion, the record is deleted. If not, the trigger throws an error and cancels the deletion.
tableextension 50101 CustomerTableExtCue extends Customer
{
    fields
    {
        field(50100; "Customer Notes"; text[2000]) { CaptionML = ENU = 'Customer Notes'; DataClassification = CustomerContent; OptimizeForTextSearch = true; }
        field(50101; "Vehicle Model"; text[100]) { CaptionML = ENU = 'Customer Vehicle Model'; DataClassification = CustomerContent; OptimizeForTextSearch = true; }
        field(50200; "No. of Jobs"; Integer)
        {
            FieldClass = FlowField;
            Caption = 'Number of projects with the customer';
            Editable = false;
            CalcFormula = count(Job where(Status = filter('Open|Paused'), "Sell-to Customer No." = FIELD("No.")));
            ToolTip = 'Specifies the number of projects ongoing for the customer.';
        }
        field(50201; "No. of Completed Jobs"; Integer)
        {
            FieldClass = FlowField;
            Caption = 'Number of completed projects with the customer';
            Editable = false;
            CalcFormula = count(Job where(Status = filter(Completed), "Sell-to Customer No." = FIELD("No.")));
            ToolTip = 'Specifies the number of projects completed for the customer.';
        }
        field(50102; "Phone Numbers Exist"; Boolean) { Caption = 'Phone Numbers Exist'; DataClassification = CustomerContent; }
    }
    fieldgroups
    {
        addlast(DropDown; "Mobile Phone No.", "E-Mail", "Vehicle Model") { }
    }

    trigger OnAfterModify()
    begin
        Validate("Vehicle Model", UpperCase("Vehicle Model"));
        if ((Rec."Phone No." <> '') or (Rec."Mobile Phone No." <> '')) then
            Rec."Phone Numbers Exist" := true
        else
            Rec."Phone Numbers Exist" := false;
        Rec.Modify()
    end;

    // trigger OnDelete()
    // begin
    //     if (not Confirm('Are you REALLY sure you want to delete this record? \ I mean really sure. So sure you''d ')) then
    //         ERROR('Deletion cancelled by user.');
    // end;

    trigger OnBeforeDelete()
    var
        messages: List of [Text];
        index: Integer;
    begin
        messages.Add('Deleting this record will erase it from existence like Thanos snapped his fingers. Are you sure you want to do this?');
        messages.Add('By deleting this record, you''ll be sending it on a one-way trip to the Phantom Zone. Are you sure you want to do that?');
        messages.Add('Deleting this record is like crossing the streams in Ghostbusters. It''s technically possible, but is it really a good idea?');
        messages.Add('If you delete this record, it will be gone forever, like a redshirt on an away mission. Are you sure you want to risk it?');
        messages.Add('Deleting this record is like navigating an asteroid field without a calculator. Are you feeling lucky?');
        messages.Add('By deleting this record, you''ll be unleashing a horde of Daleks. Are you sure you want to take that risk?');
        messages.Add('If you delete this record, you''ll be creating a temporal paradox that could unravel the fabric of spacetime. Are you sure you want to do that?');
        messages.Add('Deleting this record is like using a lightsaber to open a jar of pickles. It''s probably not the best idea.');
        messages.Add('By deleting this record, you''ll be crossing the event horizon of a black hole. Are you sure you want to take that leap?');
        messages.Add('If you delete this record, you''ll be triggering a self-destruct sequence that could destroy the entire universe. Are you absolutely sure?');
        messages.Add('Deleting this record is like asking the question "what could go wrong?" right before everything goes wrong. Are you sure you want to do this?');
        messages.Add('If you delete this record, it''ll be like Marty McFly fading away in Back to the Future. Are you sure you want to alter the timeline?');
        messages.Add('If you delete this record, you''ll be taking the One Ring to Mordor. Are you sure you''re up to the task?');
        messages.Add('Deleting this record is like putting a fork in a toaster. Are you sure you want to take that risk?');
        messages.Add('By deleting this record, you''ll be releasing the Kraken. Are you ready to face the consequences?');
        messages.Add('If you delete this record, you''ll be playing Russian roulette with a fully loaded gun. Are you sure you want to take that risk?');
        messages.Add('By deleting this record, you''ll be opening the Ark of the Covenant. Do you really want to face the wrath of God?');
        messages.Add('Deleting this record is like trying to swim across the English Channel with lead weights tied to your ankles. It''s probably not going to end well. Still sure?');
        messages.Add('If you delete this record, you''ll be taking a swim in the shark tank. Are you sure you''re ready for that?');
        messages.Add('Deleting this record is like trying to put out a fire with gasoline. It''s probably not the best idea, but if you''re sure...?');
        messages.Add('By deleting this record, you''ll be jumping out of an airplane without a parachute. Are you sure you want to take that leap?');
        messages.Add('If you delete this record, you''ll be walking into Mordor. One does not simply do that. Are you sure you''re up for it?');
        messages.Add('Deleting this record is like jumping into a pool full of sharks. Are you sure you want to take that risk?');
        messages.Add('By deleting this record, you''re entering a realm of chaos and madness. Are you sure you want to go down that rabbit hole?');
        messages.Add('Deleting this record is like playing a game of Minesweeper. Only instead of mines, you''re dealing with the fate of your data.');
        index := Random(messages.Count());

        if (not Confirm(messages.Get(index))) then begin
            ERROR('Deletion cancelled by user');
            exit;
        end;
    end;
}