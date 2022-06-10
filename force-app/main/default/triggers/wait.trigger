    trigger wait on evolution__WL__c (before insert) 
    {
        if(trigger.isbefore)
        {
            if(trigger.isinsert)
            {
                check.numberofsemi(trigger.new);
            }
        }
    }