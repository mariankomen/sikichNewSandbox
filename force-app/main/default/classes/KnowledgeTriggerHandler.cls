public class KnowledgeTriggerHandler {
   public KnowledgeTriggerHandler(List<Knowledge__kav> knwowleges){
       system.debug(knwowleges);
       Set<Id> ids = new Set<Id>();
        for(Knowledge__kav k: knwowleges){
ids.add(k.Id);
        }
       List<ContentDocumentLink>  documents;
       if(Test.isRunningTest()){
       documents = (List<ContentDocumentLink>) System.JSON.deserialize(KnowlageTriggerHandlerTest.docString, List<ContentDocumentLink>.class);

       }
       else{
           documents =[SELECT Id,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN:ids];
       }

       system.debug(documents);

        for(Knowledge__kav k: knwowleges){

                if(!String.isBlank(k.Ad__c)){
                    if(String.isBlank(k.Ad_Description__c)){
                    k.addError('Please enter ad description');
                    }else if(String.isBlank(k.Ad_Link__c)){
                        k.addError('Please enter link to ad');
                    }
                }
                else if(!String.isBlank(k.Ad_Description__c)){
                    if(String.isBlank(k.Ad__c)){
                        k.addError('Please enter ad title');
                    }else if(String.isBlank(k.Ad_Link__c)){
                        k.addError('Please enter link to ad');
                    }
                }
                else if(!String.isBlank(k.Ad_Link__c)){
                    if(String.isBlank(k.Ad__c)){
                        k.addError('Please enter ad title');
                    }else if(String.isBlank(k.Ad_Description__c)){
                        k.addError('Please enter ad description');
                    }
                }
            if(k.Ad_Enabled__c==true){
            if(documents.isEmpty()){

                    k.addError('Please disable ad and  add file for ad as different draft');
                }
            }


        }
   }
}