reportextension 50106 JobPlanningLinesRepExt extends "Job - Planning Lines"
{
    dataset
    {
        add("Job Planning Line")
        {
            column(Work_Done_PlanningLine; "Work Done")
            {
                IncludeCaption = true;
            }
        }
    }

    rendering
    {
        layout("./OmicronJobPlanningLines.rdlc")
        {
            Type = RDLC;
            LayoutFile = './OmicronJobPlanningLines.rdlc';
        }
    }
}
