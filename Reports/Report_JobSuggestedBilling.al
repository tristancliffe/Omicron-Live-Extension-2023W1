reportextension 50112 ActiveJobs extends "Job Suggested Billing"
{
    dataset
    {
        add(Job)
        {
            column(RegNo; Job."Vehicle Reg")
            { }

        }
    }
    rendering
    {
        layout("./OmicronActiveJobs.rdlc")
        {
            Type = RDLC;
            LayoutFile = './OmicronActiveJobs.rdlc';
            Caption = 'Omicron List of Current Jobs';
            Summary = 'Prints a list of current (active) jobs for printing';
        }
    }
}