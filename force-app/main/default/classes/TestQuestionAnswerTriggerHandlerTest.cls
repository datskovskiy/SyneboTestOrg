@isTest
public with sharing class TestQuestionAnswerTriggerHandlerTest {
    @TestSetup
    static void setup(){
        EmployeeTest__c employeeTest = TestDataFactory.createEmployeeTest();
    }

    @isTest
    static void changeEmployeeTestNumberAnswersTest() {
        Integer numElements = 3;

        EmployeeTest__c empTest = [SELECT Id FROM EmployeeTest__c WHERE Name = 'Test' LIMIT 1];

        Test.startTest();

        List<TestQuestion__c> questions = TestDataFactory.createTestQuestions(empTest, numElements);
        List<TestQuestionAnswer__c> answers = TestDataFactory.createTestQuestionAnswers(questions, numElements);

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

        List<TestQuestion__c> questions = TestDataFactory.createTestQuestions(empTest, numElements);
        List<TestQuestionAnswer__c> answers = TestDataFactory.createTestQuestionAnswers(questions, numElements);

        answers[0].Active__c = false;
        update answers;

        empTest = [SELECT Id, NumberAnswers__c FROM EmployeeTest__c WHERE Name = 'Test' LIMIT 1];

        Integer expected = numElements * numElements - 1;
        Integer actual = Integer.valueOf(empTest.NumberAnswers__c);

        System.assertEquals(expected, actual, 'Number of answers must be equals ' + expected);

        delete answers;
        
        Test.stopTest();

        empTest = [SELECT Id, NumberAnswers__c FROM EmployeeTest__c WHERE Name = 'Test' LIMIT 1];

        expected = 0;
        actual = Integer.valueOf(empTest.NumberAnswers__c);

        System.assertEquals(expected, actual, 'Number of answers must be equals ' + expected);
    }
}
