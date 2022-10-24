trigger TestQuestionAnswerTrigger on TestQuestionAnswer__c (after insert, after update, after delete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            TestQuestionAnswerTriggerHandler.changeEmployeeTestNumberAnswers(Trigger.new);
            //TestQuestionAnswerTriggerHandler.changeEmployeeTestNumberAnswersWithMap(Trigger.new);    
        }
        else if (Trigger.isUpdate) {
            TestQuestionAnswerTriggerHandler.changeUpdatedEmployeeTestNumberAnswers(Trigger.new, Trigger.oldMap);    
        }
        else if (Trigger.isDelete) {
            TestQuestionAnswerTriggerHandler.changeEmployeeTestNumberAnswers(Trigger.old);    
        }       
    }
}