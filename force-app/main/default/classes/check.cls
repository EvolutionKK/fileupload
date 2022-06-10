public class check {
    public static void numberofpeople(List<evolution__SeminarAccount__c> semiacc)
    {
        List<evolution__SeminarAccount__c> oldrec = [Select evolution__Semi__c, evolution__WL__c from evolution__SeminarAccount__c];
        for(evolution__SeminarAccount__c sam : semiacc)
        {
            Integer count = 0;
            Integer countwl = 0;
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
                
            }
            if(sam.evolution__WL__c != null && count < 12)
            {
                sam.addError('Can not add in waiting until Seminar is full !!');
            } 
            if(sam.evolution__WL__c != null && sam.evolution__Semi__c != null)
            {
                sam.addError('Either add in Waiting list or Seminar');
            }
            for(evolution__SeminarAccount__c a : oldrec)
            {
                if(a.evolution__WL__c == sam.evolution__WL__c)
                {
                    countwl++;
                }
            }
            if(sam.evolution__WL__c != null && countwl >=3)
            {
                sam.addError('Can not create add more than three people in a waiting list');
            }
        }
    }
    
    
    public static void numberofsemi(List<evolution__WL__c> wlacc)
    {
        List<evolution__WL__c> oldrec = [Select evolution__Semi__c from evolution__WL__c];
        for(evolution__WL__c wl : wlacc)
        {
            for(evolution__WL__c ol : oldrec)
            {
                if(wl.evolution__Semi__c == ol.evolution__Semi__c)
                {
                    wl.addError('Can not add more than one Waiting List in a Seminar');
                }
            }
        }
    }
    
    
}