@isTest
public with sharing class UpdateTestNumberAnswersBatchTest {
    public static String CRON_EXP = '0 54 19 * * ?';

    @TestSetup
    static void setup() {
        Integer numElements = 3;

        EmployeeTest__c employeeTest = TestDataFactory.getEmployeeTestBuilder()
            .buildEmployeeTest();

        insert employeeTest;

        List<TestQuestion__c> questions = new List<TestQuestion__c>();
        for (Integer i = 0; i < numElements; i++) {
            TestQuestion__c question = TestDataFactory.getTestQuestionBuilder()
                .setName('Question ' + i)
                .setEmployeeTest(employeeTest)
                .buildTestQuestion();

            questions.add(question);
        }
        insert questions;

        List<TestQuestionAnswer__c> answers = new List<TestQuestionAnswer__c>();      
        for (TestQuestion__c question : questions) {
            for (Integer i = 0; i < numElements; i++) {
                TestQuestionAnswer__c answer = TestDataFactory.getTestQuestionAnswerBuilder()
                    .setName('Answer ' + i)
                    .setTestQuestion(question)
                    .buildTestQuestionAnswer();
    
                answers.add(answer);
            }    
        }      
        insert answers;
    } 
    
    @isTest
    static void executeTest() {
        Test.startTest();

        String mail = 'test@gmail.com';
        UpdateTestNumberAnswersScheduledBatch updBatch = new UpdateTestNumberAnswersScheduledBatch(mail);
        Id batchId = Database.executeBatch(updBatch);

        Test.stopTest();

        EmployeeTest__c empTest = [SELECT Id, NumberAnswers__c FROM EmployeeTest__c WHERE Name = 'Test' LIMIT 1];

        Integer expected = 9;
        Integer actual = Integer.valueOf(empTest.NumberAnswers__c);

        System.assertEquals(expected, actual, 'Number of answers must be equal to amount of all test question answers related to employee test');
    }

    @isTest
    static void executeWithDeletionRecordsTest() {
        List<TestQuestionAnswer__c> answers = [SELECT Id FROM TestQuestionAnswer__c WHERE TestQuestion__r.Employee_test__r.Name = 'Test'];
        delete answers;

        Test.startTest();
        String mail = 'test@gmail.com';
        UpdateTestNumberAnswersScheduledBatch updBatch = new UpdateTestNumberAnswersScheduledBatch(mail);
        Id batchId = Database.executeBatch(updBatch);

        Test.stopTest();

        EmployeeTest__c empTest = [SELECT Id, NumberAnswers__c FROM EmployeeTest__c WHERE Name = 'Test' LIMIT 1];

        Integer expected = 0;
        Integer actual = Integer.valueOf(empTest.NumberAnswers__c);

        System.assertEquals(expected, actual, 'Number of answers must be equals ' + expected);
    }

    @isTest
    static void executeWithCronExpTest() {
        List<EmployeeTest__c> tests = [SELECT Id FROM EmployeeTest__c WHERE Name = 'Test' LIMIT 1];
        List<Id> testsIds = new List<Id>(new Map<Id, EmployeeTest__c>(tests).keySet());

        Test.startTest();

        String mail = 'test@gmail.com';
        UpdateTestNumberAnswersScheduledBatch updBatch = new UpdateTestNumberAnswersScheduledBatch(mail);
        String jobId = System.schedule('UpdateTestNumberAnswers', CRON_EXP, updBatch);

        Test.stopTest();

        List<Task> lt = [SELECT Id FROM Task WHERE WhatId IN : testsIds];

        Integer expected = testsIds.size();
        Integer actual = lt.size();

        System.assertEquals(expected, actual, 'Tasks were not created');
    }
}
