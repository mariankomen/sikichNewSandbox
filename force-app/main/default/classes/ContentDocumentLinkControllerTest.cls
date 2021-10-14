@isTest
public with sharing class ContentDocumentLinkControllerTest {
    
    @isTest
    public static void getUploadedFilesTest(){
        try{
            ContentDocumentLinkController.getUploadedFiles('0698G00000005whQAA,0698G00000005wiQAA,0698G00000005wmQAA');
        } catch(Exception e){
            ContentDocumentLinkController.getUploadedFiles('0698G00000005whQAA');

        }
    }
}