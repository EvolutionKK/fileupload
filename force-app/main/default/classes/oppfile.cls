public class oppfile {

@AuraEnabled(cacheable=true)
public static List<Opportunity> fnoppfile() {
List<Opportunity> opplist = [Select Name from Opportunity Limit 10];
return opplist;
}
    @AuraEnabled
    public static void del(String a)
    {
        database.delete(a);
    }

@AuraEnabled
public static List<ContentVersion> getContentDetails(String recordId) {
    List<ContentDocumentLink> contentDocumentList = [SELECT ContentDocumentId, LinkedEntityId 
                                                        FROM   ContentDocumentLink 
                                                        WHERE  LinkedEntityId =: recordId];
    Set<Id> contentDocumentId = new Set<Id>();
        
    for(ContentDocumentLink cdl : contentDocumentList){
        contentDocumentId.add(cdl.ContentDocumentId);
    }
        
    List<ContentVersion> contentVersionList = [SELECT Id, VersionData, FileType, Title, FileExtension,
                                                ContentDocument.CreatedBy.Name, ContentDocument.ContentSize,
                                                CreatedDate, ContentDocumentId, ContentDocument.FileType
                                                FROM   ContentVersion 
                                                WHERE  ContentDocumentId IN :contentDocumentId];
    return contentVersionList;
}

@AuraEnabled
public static void deleteContentDocument(String recordId) {
    Database.delete(recordId);
}

    @AuraEnabled
    public static void sendmail(String email, String body)
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddress = new String[]{email};
        mail.setToAddresses(toAddress); 
        mail.setSubject('Notes & Attachments');
        mail.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    }
}

