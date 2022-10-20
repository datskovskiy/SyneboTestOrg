trigger TestQuestionAnswerTrigger on TestQuestionAnswer__c (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            TestQuestionAnswerTriggerHandler.changeEmployeeTestNumberAnswers(Trigger.new);    
        }       
    }
}