public class checkafter {
	public static void numberofpeople(List<evolution__SeminarAccount__c> givenlist)
    {
        system.debug('chlra hu');
        List<evolution__SeminarAccount__c> oldrec = [Select evolution__Semi__c, evolution__WL__c from evolution__SeminarAccount__c];
        Integer count = 0;
        Integer countwl = 0;
        for(evolution__SeminarAccount__c sam : givenlist)
        {
            
            for(evolution__SeminarAccount__c s : oldrec)
            {
                if(s.evolution__Semi__c == sam.evolution__Semi__c)
                {
                    count++;
                }
            }
            if(sam.evolution__Semi__c != null && count > 12)
            {
                //sam.addError('Can not add more than 12 people in a Seminar !!');
                system.debug(sam);
                evolution__Semi__c rec = [Select Name, evolution__Pro__c from evolution__Semi__c where Id = :sam.evolution__Semi__c];
                evolution__Semi__c newsemi = new evolution__Semi__c();
                newsemi.Name = 'Extra'+rec.Name;
                newsemi.evolution__Pro__c = rec.evolution__Pro__c;
                system.debug(newsemi);
                insert newsemi;
                
                List<evolution__WL__c> wait = [Select evolution__Semi__c from evolution__WL__c];
                
                List<evolution__SeminarAccount__c> toupdate = new List<evolution__SeminarAccount__c>();
                for(evolution__WL__c w : wait)
                {
                    if(w.evolution__Semi__c == sam.evolution__Semi__c)
                    {
                        List<evolution__SeminarAccount__c> existingwl = [select evolution__Semi__c, evolution__WL__c from evolution__SeminarAccount__c];
                        for(evolution__SeminarAccount__c sa : existingwl)
                        {
                            sa.evolution__WL__c = null;
                            sa.evolution__Semi__c = newsemi.Id;
                            system.debug(newsemi.Id);
                            toupdate.add(sa);
                        }
                    }
                }
                //sam.evolution__Semi__c = newsemi.Id;
                update toupdate;
                
                
            }
        }
    }
}