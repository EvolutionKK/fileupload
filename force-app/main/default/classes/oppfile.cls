public class oppfile {

@AuraEnabled(cacheable=true)
public static List<Opportunity> fnoppfile() {
List<Opportunity> opplist = [Select Name, StageName, ExpectedRevenue from Opportunity Limit 10];

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
                                        CreatedDate, ContentDocumentId, ContentDocument.FileType, evolution__isValid__c, evolution__Category__c,evolution__Action__c, evolution__getyear__c, evolution__year__c
                                        FROM   ContentVersion 
                                        WHERE  ContentDocumentId IN :contentDocumentId order by CreatedDate DESC];
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

@AuraEnabled
public static void updatecontent(String recId, Boolean bool, String cat){
List<ContentVersion> contentVersionList = [SELECT Id, FileType, Title, FileExtension,
                                        ContentDocument.CreatedBy.Name, ContentDocument.ContentSize,
                                        CreatedDate, ContentDocumentId, ContentDocument.FileType, evolution__isValid__c, evolution__Category__c,evolution__Action__c, evolution__getyear__c, evolution__year__c
                                        FROM   ContentVersion 
                                        WHERE  Id = :recId];
                                        System.debug(contentVersionList[0]);
contentVersionList[0].evolution__isValid__c = bool;
contentVersionList[0].evolution__Category__c = cat;
update contentVersionList[0];
}

@AuraEnabled
public static List<ContentVersion> getAllContentDetails(String recordId, String check, String sel) {
    List<ContentVersion> contentVersionList = new List<ContentVersion>  ();
if(check == 'All' && sel == 'All'){
    List<ContentDocumentLink> contentDocumentList = [SELECT ContentDocumentId, LinkedEntityId 
                                                    FROM   ContentDocumentLink 
                                                    WHERE  LinkedEntityId =:recordId];
    Set<Id> contentDocumentId = new Set<Id>();
    
    for(ContentDocumentLink cdl : contentDocumentList){
        contentDocumentId.add(cdl.ContentDocumentId);
    }
    
contentVersionList = [SELECT Id, VersionData, FileType, Title, FileExtension,
                                            ContentDocument.CreatedBy.Name, ContentDocument.ContentSize,
                                            CreatedDate, ContentDocumentId, ContentDocument.FileType, evolution__isValid__c, evolution__Category__c,evolution__Action__c, evolution__getyear__c, evolution__year__c
                                            FROM   ContentVersion 
                                            WHERE  ContentDocumentId IN :contentDocumentId];

    return contentVersionList;
}else if(check== 'Valid' && sel == 'All'){
    List<ContentDocumentLink> contentDocumentList = [SELECT ContentDocumentId, LinkedEntityId 
                                                    FROM   ContentDocumentLink 
                                                    WHERE  LinkedEntityId =: recordId];
    Set<Id> contentDocumentId = new Set<Id>();
    
    for(ContentDocumentLink cdl : contentDocumentList){
        contentDocumentId.add(cdl.ContentDocumentId);
    }
    
contentVersionList = [SELECT Id, VersionData, FileType, Title, FileExtension,
                                            ContentDocument.CreatedBy.Name, ContentDocument.ContentSize,
                                            CreatedDate, ContentDocumentId, ContentDocument.FileType, evolution__isValid__c, evolution__Category__c,evolution__Action__c, evolution__getyear__c,evolution__year__c
                                            FROM   ContentVersion 
                                            WHERE  ContentDocumentId IN :contentDocumentId AND evolution__isValid__c = true];

    return contentVersionList;
}else if(check== 'Not Valid' && sel == 'All'){
    List<ContentDocumentLink> contentDocumentList = [SELECT ContentDocumentId, LinkedEntityId 
                                                    FROM   ContentDocumentLink 
                                                    WHERE  LinkedEntityId =: recordId];
    Set<Id> contentDocumentId = new Set<Id>();
    
    for(ContentDocumentLink cdl : contentDocumentList){
        contentDocumentId.add(cdl.ContentDocumentId);
    }
    
contentVersionList = [SELECT Id, VersionData, FileType, Title, FileExtension,
                                            ContentDocument.CreatedBy.Name, ContentDocument.ContentSize,
                                            CreatedDate, ContentDocumentId, ContentDocument.FileType, evolution__isValid__c, evolution__Category__c,evolution__Action__c, evolution__getyear__c,evolution__year__c
                                            FROM   ContentVersion 
                                            WHERE  ContentDocumentId IN :contentDocumentId AND evolution__isValid__c = false];

    return contentVersionList;
}else if(check == 'All'){
    List<ContentDocumentLink> contentDocumentList = [SELECT ContentDocumentId, LinkedEntityId 
                                                    FROM   ContentDocumentLink 
                                                    WHERE  LinkedEntityId =:recordId];
    Set<Id> contentDocumentId = new Set<Id>();
    
    for(ContentDocumentLink cdl : contentDocumentList){
        contentDocumentId.add(cdl.ContentDocumentId);
    }
    
contentVersionList = [SELECT Id, VersionData, FileType, Title, FileExtension,
                                            ContentDocument.CreatedBy.Name, ContentDocument.ContentSize,
                                            CreatedDate, ContentDocumentId, ContentDocument.FileType, evolution__isValid__c, evolution__Category__c,evolution__Action__c, evolution__getyear__c,evolution__year__c
                                            FROM   ContentVersion 
                                            WHERE  ContentDocumentId IN :contentDocumentId AND evolution__Category__c = :sel];

    return contentVersionList;
}else if(check == 'Valid'){
    List<ContentDocumentLink> contentDocumentList = [SELECT ContentDocumentId, LinkedEntityId 
                                                    FROM   ContentDocumentLink 
                                                    WHERE  LinkedEntityId =: recordId];
    Set<Id> contentDocumentId = new Set<Id>();
    
    for(ContentDocumentLink cdl : contentDocumentList){
        contentDocumentId.add(cdl.ContentDocumentId);
    }
    
contentVersionList = [SELECT Id, VersionData, FileType, Title, FileExtension,
                                            ContentDocument.CreatedBy.Name, ContentDocument.ContentSize,
                                            CreatedDate, ContentDocumentId, ContentDocument.FileType, evolution__isValid__c, evolution__Category__c,evolution__Action__c,evolution__getyear__c,evolution__year__c
                                            FROM   ContentVersion 
                                            WHERE  ContentDocumentId IN :contentDocumentId AND evolution__isValid__c = true AND evolution__Category__c = :sel];

    return contentVersionList;
}else if(check == 'Not Valid'){
    List<ContentDocumentLink> contentDocumentList = [SELECT ContentDocumentId, LinkedEntityId 
                                                    FROM   ContentDocumentLink 
                                                    WHERE  LinkedEntityId =: recordId];
    Set<Id> contentDocumentId = new Set<Id>();
    
    for(ContentDocumentLink cdl : contentDocumentList){
        contentDocumentId.add(cdl.ContentDocumentId);
    }
    
contentVersionList = [SELECT Id, VersionData, FileType, Title, FileExtension,
                                            ContentDocument.CreatedBy.Name, ContentDocument.ContentSize,
                                            CreatedDate, ContentDocumentId, ContentDocument.FileType, evolution__isValid__c, evolution__Category__c,evolution__Action__c,evolution__getyear__c,evolution__year__c
                                            FROM   ContentVersion 
                                            WHERE  ContentDocumentId IN :contentDocumentId AND evolution__isValid__c = false AND evolution__Category__c = :sel];

    return contentVersionList;
}

return contentVersionList;
}
}

