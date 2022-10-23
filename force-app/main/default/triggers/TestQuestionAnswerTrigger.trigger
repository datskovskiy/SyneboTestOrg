trigger TestQuestionAnswerTrigger on TestQuestionAnswer__c (after insert, after update, after delete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            TestQuestionAnswerTriggerHandler.changeEmployeeTestNumberAnswers(Trigger.new);
            //TestQuestionAnswerTriggerHandler.changeEmployeeTestNumberAnswersWithMap(Trigger.new);    
        }
        else if (Trigger.isDelete) {
            TestQuestionAnswerTriggerHandler.changeEmployeeTestNumberAnswers(Trigger.old);    
        }       
    }
}