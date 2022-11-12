@isTest
public with sharing class PassingTestTriggerHandlerTest {

    @TestSetup
    public static void setup() {
        Employee__c emp = TestDataFactory.getEmployeeBuilder()
            .buildEmployee();
        
        insert emp;

        EmployeeTest__c test = TestDataFactory.getEmployeeTestBuilder()
            .buildEmployeeTest();

        insert test;

        PassingTest__c passingTest = TestDataFactory.getPassingTestBuilder()
            .setEmployee(emp)
            .setEmployeeTest(test)
            .setStartDate(Datetime.now())
            .buildPassingTest();

        insert passingTest;    
    }

    @isTest
    public static void changeInvalidStartDateTest() {
        PassingTest__c passingTest = [SELECT Id FROM PassingTest__c WHERE Name = 'Test' LIMIT 1];
        passingTest.StartDate__c = Datetime.now();
        passingTest.EndDate__c = Datetime.now();

        Test.startTest();
        Database.SaveResult result = Database.update(passingTest, false);
        Test.stopTest();

        PassingTest__c updPassingTest = [SELECT Id, StartDate__c, EndDate__c FROM PassingTest__c WHERE Name = 'Test' LIMIT 1];

        Datetime expected = updPassingTest.EndDate__c - 60;
        Datetime actual = updPassingTest.StartDate__c;

        System.assertEquals(expected, actual, 'End date must be bigger than start date');
    }
}