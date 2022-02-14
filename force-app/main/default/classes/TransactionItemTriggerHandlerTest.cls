/*
    DeveloperName: Himansu Kesari
    CreatedDate : 13th Feb 2022
    Description: This Class is created to methods will be called when any Insert Or Update DML operation will happen on
                Transaction_Item__c Object
*/
@IsTest
public class TransactionItemTriggerHandlerTest {
    
    @TestSetup
    static void makeData() {
        List<Transaction__c> transactionRecords = new List<Transaction__c>();
        Transaction__c transactionRecord = new Transaction__c();
        transactionRecords.add(transactionRecord);

        Transaction__c transactionRecord2 = new Transaction__c();
        transactionRecords.add(transactionRecord2);

        insert transactionRecords;
    }

    @IsTest
    static void InsertScenarioUnitTest() {
        List<Transaction__c> transactionRecords = new List<Transaction__c>();
        transactionRecords = [SELECT Id, CreatedDate FROM Transaction__c];

        List<Transaction_Item__c> transactionItems = new List<Transaction_Item__c>();

        for(Transaction__c transactionRecord : transactionRecords) {
            Transaction_Item__c transactionItem = new Transaction_Item__c();
            transactionItem.ItemCost__c = 100;
            transactionItem.Discount__c  = 10;
            transactionItem.Transaction__c = transactionRecord.Id;
            transactionItems.add(transactionItem);
        }
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
            insert transactionItems;
        Test.stopTest();
        System.AssertEquals(transactionItems.size(), 2);
        System.AssertNotEquals(transactionItems.size(), 0);
    }
    
    @IsTest
    static void UpdateScenarioUnitTest() {
        List<Transaction__c> transactionRecords = new List<Transaction__c>();
        transactionRecords = [SELECT Id, CreatedDate FROM Transaction__c];

        List<Transaction_Item__c> transactionItems = new List<Transaction_Item__c>();

        for(Transaction__c transactionRecord : transactionRecords) {
            Transaction_Item__c transactionItem = new Transaction_Item__c();
            transactionItem.ItemCost__c = 100;
            transactionItem.Discount__c  = 10;
            transactionItem.Transaction__c = transactionRecord.Id;
            transactionItems.add(transactionItem);
        }
        insert transactionItems;

        for(Transaction_Item__c transactionItemRecord : transactionItems) {
            transactionItemRecord.ItemCost__c = 210;
            transactionItemRecord.Discount__c  = 15;
        }
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
            update transactionItems;
        Test.stopTest();
        System.AssertEquals(transactionItems.size(), 2);
        System.AssertNotEquals(transactionItems.size(), 0);
    }
}
