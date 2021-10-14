@isTest
public with sharing class DynamicAdsControllerTest {
    
    @isTest
    public static void getImageTest(){


        
        
        Knowledge__kav ka = new Knowledge__kav(Title = 'Salesforce CRM', UrlName = 'uniqsdfgUrl133');
        insert ka;
        String k = DynamicAdsController.getImage(ka.UrlName);
        Knowledge__kav details = DynamicAdsController.getDetails(ka.UrlName);
    }
}