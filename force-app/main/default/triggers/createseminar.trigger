trigger createseminar on evolution__Semi__c (before insert) {
	if(trigger.isbefore)
    {
        if(trigger.isBefore)
        {
            clear.lastwl(trigger.new);
        }
    }
}