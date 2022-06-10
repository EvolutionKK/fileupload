public class clear {
    public static void lastwl(List<evolution__Semi__c> semi)
    {
        for(evolution__Semi__c s : semi)
        {
        	List<evolution__Pro__c> p =[Select Id from evolution__Pro__c where Id = :s.evolution__Pro__c];
            evolution__WL__c wlrec = [Select Id from evolution__WL__c where evolution__Semi__c = :s.Id];
            delete wlrec;
            evolution__WL__c newwl = new evolution__WL__c();
            newwl.evolution__Semi__c = s.Id;
            insert newwl;
            
       	}
    }
}