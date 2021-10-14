@isTest
public with sharing class articleDetailPageControllerTest {
    
    @isTest
    public static void getArticleByTitleTest(){
        Knowledge__kav knowKAV = new Knowledge__kav(Title = 'Salesforce CRM', UrlName = 'salesgaDDsdfaforce-crm');
        insert knowKAV;
        articleDetailPageController.getArticleByTitle(knowKav.UrlName);
    }
}