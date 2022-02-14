/*
    DeveloperName: Himansu Kesari
    CreatedDate : 13th Feb 2022
    Description: This Class methods will be called when any Insert Or Update DML operation will happen on
                Transaction_Item__c Object
*/
public with sharing class TransactionItemTriggerHandler {
    public Static Map<Id, List<Transaction_Item__c>> transactionItemsWithTransactionRecord = new Map<Id, List<Transaction_Item__c>>();

    /*
        DeveloperName: Himansu Kesari
        CreatedDate : 13th Feb 2022
        Description: This method will be called when any Insert Or Update DML operation will happen on
                    Transaction_Item__c Object
    */
    public Static void Intialise(List<Transaction_Item__c> transactionItems) {
        Set<Id> transactionRecords = new Set<Id>();
        for(Transaction_Item__c transactionItem : transactionItems) {
            transactionRecords.add(transactionItem.Transaction__c);
        }

        for(Transaction_Item__c  transactionItem : [SELECT Id, Name, ItemCost__c, Discount__c, Transaction__c, Transaction__r.CreatedDate  FROM Transaction_Item__c WHERE Transaction__c IN: transactionRecords]) {
            if(!transactionItemsWithTransactionRecord.ContainsKey(transactionItem.Transaction__c)) {
                transactionItemsWithTransactionRecord.put(transactionItem.Transaction__c, new List<Transaction_Item__c>());
            }
            transactionItemsWithTransactionRecord.get(transactionItem.Transaction__c).add(transactionItem);
        }
        createJSONForAPICalls();
    }

    /*
        DeveloperName: Himansu Kesari
        CreatedDate : 13th Feb 2022
        Description: This method will create JSON request for API Calls
    */
    public Static void createJSONForAPICalls() {
        for(Id transactionRecordId : transactionItemsWithTransactionRecord.keyset()) {
            Decimal totalCost = 0.0;
            Decimal totalDiscount = 0.0;
            JSONGenerator transactionGenerator = JSON.createGenerator(true);
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartArray();
            for(Transaction_Item__c itemRecord : transactionItemsWithTransactionRecord.get(transactionRecordId)) {
                gen.writeStartObject();
                gen.writeFieldName('keys');
                gen.writeStartObject();
                gen.writeStringField('TransactionItemID', itemRecord.Id);
                gen.writeEndObject();
                gen.writeFieldName('values');
                gen.writeStartObject();
                gen.writeNumberField('ItemCost', itemRecord.ItemCost__c);
                gen.writeStringField('ItemName', itemRecord.Name);
                gen.writeEndObject();
                gen.writeEndObject();

                if(itemRecord.ItemCost__c != NULL) {
                    totalCost = totalCost + itemRecord.ItemCost__c;
                }
                if(itemRecord.Discount__c != NULL) {
                    totalDiscount = totalDiscount + itemRecord.Discount__c;
                }
            }
            gen.writeEndArray();

            Transaction_Item__c itemRecord = transactionItemsWithTransactionRecord.get(transactionRecordId)[0];
            transactionGenerator.writeStartObject();
            transactionGenerator.writeFieldName('keys');
            transactionGenerator.writeStartObject();
            transactionGenerator.writeStringField('TransactionID', transactionRecordId);
            transactionGenerator.writeEndObject();
            transactionGenerator.writeFieldName('values');
            transactionGenerator.writeStartObject();
            transactionGenerator.writeNumberField('TotalCost', totalCost);
            transactionGenerator.writeNumberField('TotalDiscount', totalDiscount);
            transactionGenerator.writeDateField('TransactionDate', date.newinstance(itemRecord.Transaction__r.CreatedDate.year(), itemRecord.Transaction__r.CreatedDate.month(), itemRecord.Transaction__r.CreatedDate.day()));
            transactionGenerator.writeEndObject();
            transactionGenerator.writeEndObject();

            makeAPICall(gen.getAsString(), transactionGenerator.getAsString());
        }
    }

    /*
        DeveloperName: Himansu Kesari
        CreatedDate : 13th Feb 2022
        Description: This method will make API Calls for Transction Item Details
    */
    @future(callout = true)
    public Static void makeAPICall(String JSONString, String transactionJSONString) {
        system.debug('JSON Value'+ JSONString);
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');     
        req.setHeader('content-type', 'application/json');       
        req.setEndpoint('https://fakeendpoint.free.beeceptor.com/my/api/path');
        req.setbody(JSONString);
        Http http = new Http();
        try {
            HTTPResponse res = http.send(req);                 
            //Executing web service call
            System.debug('STATUS:' + res.getStatus());
            System.debug('STATUS_CODE:' + res.getStatusCode());
            if(res.getStatusCode() == 200) {
                makeTranactionAPICall(transactionJSONString);
            }
        }
        catch(System.CalloutException e){
            //Exception handling goes here..
            system.debug(e);
        }
    }

    /*
        DeveloperName: Himansu Kesari
        CreatedDate : 13th Feb 2022
        Description: This method will make API Calls for Transction Details
    */
    public Static void makeTranactionAPICall(String transactionJSONString) {
        system.debug('transactionJSON Value'+ transactionJSONString);
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');     
        req.setHeader('content-type', 'application/json');       
        req.setEndpoint('https://fakeendpoint.free.beeceptor.com/my/api/path');
        req.setbody(transactionJSONString);
        Http http = new Http();
        try {
            HTTPResponse res = http.send(req);                 
            //Executing web service call
            System.debug('STATUS:' + res.getStatus());
            System.debug('STATUS_CODE:' + res.getStatusCode());
        }
        catch(System.CalloutException e) {
            //Exception handling goes here..
            system.debug(e);
        }
    }
}