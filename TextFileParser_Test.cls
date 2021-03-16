@isTest
public class TextFileParser_Test {

    //--list variables used by all test methods
    public static Case testCase = new Case();
    public static EmailMessage testEmail = new EmailMessage();
    public static ContentVersion testVersion = new ContentVersion();
    public static ContentDocumentLink testLink = new ContentDocumentLink();
    
    //--public class used to populate and insert the records used in testing
    public static void testRecords(){
        
        //--populate necessary case fields and insert the test case
        testCase.Status = 'New';
        testCase.Origin = 'Email';
        insert testCase;
        
        //--query for the inserted test case so that the ID can be used later
        Case testCase = [SELECT Id FROM Case WHERE Status = 'New' AND Origin = 'Email' LIMIT 1];
        
        //--populate the test case as the parent and insert the email message
        testEmail.parentId = testCase.Id;
        insert testEmail;
        
        //--query for the inserted email message so that the ID can be used later
        EmailMessage testEmail = [SELECT Id FROM EmailMessage WHERE parentId = :testCase.Id LIMIT 1];
        
        //--populate necessary case fields and insert the test content version
        testVersion.Title = 'test';
        testVersion.PathOnClient = 'Test.ics';
        testVersion.IsMajorVersion = true;
        testVersion.VersionData = blob.valueof('DTSTART:20210316T000001DTEND');
        insert testVersion;
        
        //--query the newly created content document record so that the ID can be used to create a 
        //  content link record
        ContentDocument testDocument = [Select Id FROM ContentDocument LIMIT 1];
        
        //--populate the linked entity id field as the test email record and the content document
        //  id field as the test document record and insert the test content document link record
        testLink.LinkedEntityId = testEmail.Id;
        testLink.ContentDocumentId = testDocument.Id;
        testLink.Visibility = 'AllUsers';
        insert testLink;
        
        //--get the content version record so it can be passed in as a parameter during the test
        ContentVersion testVersion = [SELECT Id FROM ContentVersion LIMIT 1];
    }
    
    //--test method for testing the date parser
    private static testMethod void testBasicQuery(){
        
        //--run testRecords method to create the necessary test records
        testRecords();
        
        //--create a list variable for the test parameters
        list<TextFileParser.InputParameters> testParams = new list<TextFileParser.InputParameters>();
        
        //--build the parameters for the parser class
        testParams.add(new TextFileParser.InputParameters());
        testParams[0].contentVersionRecord = testVersion;
        testParams[0].startString = 'DTSTART:';
        testParams[0].endString = 'DTEND';
        
        //--run the actual parsing method to get back results
        list<TextFileParser.DateResult> testResults = TextFileParser.parseDateValue(testParams);
        
        //--expect the datetime to match what is provided in the assertion
        System.assertEquals(Datetime.newInstance(2021,3,16,0,0,1), testResults[0].dateValue);
    }   

}
