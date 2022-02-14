/*
    DeveloperName: Himansu Kesari
    CreatedDate : 13th Feb 2022
    Description: This trigger will be executed when any Insert Or Update DML operation will happen on
                Transaction_Item__c Object
*/
trigger TransactionItemTrigger on Transaction_Item__c(After insert, After update) {
    TransactionItemTriggerHandler.Intialise(Trigger.New);
}