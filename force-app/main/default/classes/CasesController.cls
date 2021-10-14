public with sharing class CasesController {
    
    @AuraEnabled
    public static string getListCases(String ListViewID){
        List<Case> AccountList = new List<Case>();
        HttpRequest req = new HttpRequest();
        String urlInstance = URL.getOrgDomainUrl().toExternalForm();
        String endPoinURL = urlInstance+'/services/data/v32.0/sobjects/Case/listviews/'+ListViewID+'/describe';
        req.setEndpoint(endPoinURL);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        Http http = new Http();
        HTTPResponse response = http.send(req);
        System.debug(response.getBody());
        Map<String, Object> tokenResponse = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        
        String query = (String)tokenResponse.get('query');
        System.debug(query);
        query = 'SELECT Description, Type, External_Status__c, Date_Time_Opened__c, ' + query.substring(7);
        for(Case accountObj : database.query(query)){
            AccountList.add(accountObj);
        }
        
        return JSON.serialize(AccountList);
        
    }

    @AuraEnabled
    public static string getListViewTitles(){
        ListViewLabels__c mcs = ListViewLabels__c.getValues('Labels');
        List<String> labels = mcs.ListLabels__c.split(',');

        List<ListView> listViewTitle = [SELECT Id, Name FROM ListView where SobjectType = 'Case' AND Name IN: labels ORDER BY Name DESC];
        System.debug(listViewTitle);
        // List<ListView> listViewTitle = [SELECT Id, Name FROM ListView where SobjectType = 'Case'];
        return JSON.serialize(listViewTitle);
    }


    /* Case issue picklist values, now is not needed*/
    @AuraEnabled
    public static string getCreateCasePicklistValue(){
        List<String> pickListValuesList= new List<String>();
		Schema.DescribeFieldResult fieldResult = Case.Case_Issue__c .getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			pickListValuesList.add(pickListVal.getLabel());
		}     
		return JSON.serialize(pickListValuesList);
    }
    /* Case issue picklis */
    @AuraEnabled
    public static string createInquiryCase(String Description, String Name, String Email, String Organization, List<String> FilesIDs, String SerialNumber){
        List<ContentDocumentLink> dataFilesForInsert = new List<ContentDocumentLink>();
        DateTime dt = DateTime.now();
        DateTime todaysDate = System.today();
        String todaysDateStr = todaysDate.format('yyyy-MM-dd');
        Id UserID = UserInfo.getUserId();

        String RTInquiryId = [SELECT id from RecordType where Name ='Inquiry'].Id;
        User u = [SELECT Id, FirstName, LastName, Name, Email FROM User WHERE ID=:UserID LIMIT 1];
        Contact curContact = [SELECT Id, Account.Id, Name, Email FROM Contact WHERE Name=:u.Name LIMIT 1];
        Account curAccount = [SELECT Id, Name FROM Account WHERE Id=:curContact.Account.Id LIMIT 1];
        
        Case c = new Case();
        c.RecordTypeId  = RTInquiryId;
        c.AccountId = curAccount.Id;
        c.ContactId = curContact.Id;
        c.Subject = 'Community Inquiry: '+curContact.Name+' '+todaysDateStr;
        //c.Case_Issue__c = CaseIssue;
        c.Status = 'New';
        c.Origin = 'Community';
        c.Serial_Number__c = SerialNumber;
        c.Description = Description;
        c.Date_Time_Opened__c = dt;
        c.SuppliedEmail = Email;
        c.SuppliedName = Name;
        c.SuppliedCompany = Organization;

        insert c;

        for(String k: FilesIDs){
            ContentDocumentLink assignFile = new ContentDocumentLink(LinkedEntityId=c.Id, ContentDocumentId=k);
            dataFilesForInsert.add(assignFile);
        }
        insert dataFilesForInsert;
        return c.Id;

    }

}