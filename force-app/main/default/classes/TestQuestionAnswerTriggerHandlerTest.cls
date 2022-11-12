@isTest
public with sharing class TestQuestionAnswerTriggerHandlerTest {
    @TestSetup
    static void setup(){
        EmployeeTest__c employeeTest = TestDataFactory.getEmployeeTestBuilder()
            .buildEmployeeTest();

        insert employeeTest;
    }

    @isTest
    static void changeEmployeeTestNumberAnswersTest() {
        Integer numElements = 3;

        EmployeeTest__c empTest = [SELECT Id FROM EmployeeTest__c WHERE Name = 'Test' LIMIT 1];

        Test.startTest();

        List<TestQuestion__c> questions = new List<TestQuestion__c>();
        for (Integer i = 0; i < numElements; i++) {
            TestQuestion__c question = TestDataFactory.getTestQuestionBuilder()
                .setName('Question ' + i)
                .setEmployeeTest(empTest)
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

        Test.stopTest();

        empTest = [SELECT Id, NumberAnswers__c FROM EmployeeTest__c WHERE Name = 'Test' LIMIT 1];

        Integer expected = numElements * numElements;
        Integer actual = Integer.valueOf(empTest.NumberAnswers__c);

        System.assertEquals(expected, actual, 'Number of answers must be equals ' + expected);
    }

    @isTest
    static void changeUpdatedEmployeeTestNumberAnswersTest() {
        Integer numElements = 3;

        EmployeeTest__c empTest = [SELECT Id FROM EmployeeTest__c WHERE Name = 'Test' LIMIT 1];

        Test.startTest();

        List<TestQuestion__c> questions = new List<TestQuestion__c>();
        for (Integer i = 0; i < numElements; i++) {
            TestQuestion__c question = TestDataFactory.getTestQuestionBuilder()
                .setName('Question ' + i)
                .setEmployeeTest(empTest)
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

        answers[0].Active__c = false;
        update answers;

        empTest = [SELECT Id, NumberAnswers__c FROM EmployeeTest__c WHERE Name = 'Test' LIMIT 1];

        Integer expected = numElements * numElements - 1;
        Integer actual = Integer.valueOf(empTest.NumberAnswers__c);

        System.assertEquals(expected, actual, 'Number of answers must be equal to amount of all test question answers related to employee test');

        delete answers;
        
        Test.stopTest();

        empTest = [SELECT Id, NumberAnswers__c FROM EmployeeTest__c WHERE Name = 'Test' LIMIT 1];

        expected = 0;
        actual = Integer.valueOf(empTest.NumberAnswers__c);

        System.assertEquals(expected, actual, 'Number of answers must be equal to amount of all test question answers related to employee test');
    }
}
