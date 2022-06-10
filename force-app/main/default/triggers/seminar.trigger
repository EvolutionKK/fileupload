trigger seminar on evolution__SeminarAccount__c (before insert, after insert) 
{
	if(trigger.isbefore)
    {
        if(trigger.isinsert)
        {
            check.numberofpeople(trigger.new);
        }
    }
    if(trigger.isafter)
    {
        if(trigger.isinsert)
        {
            checkafter.numberofpeople(trigger.new);
        }
    }
    
}