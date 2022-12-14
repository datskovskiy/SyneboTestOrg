@isTest
public with sharing class TestDataFactory {

    public with sharing class PassingTestBuilder {
        private PassingTest__c passingTest = new PassingTest__c();

        private PassingTestBuilder() {
            this.passingTest.Name = 'Test';
            this.passingTest.StartDate__c = Datetime.now();  
        }

        public PassingTestBuilder setEmployee(Employee__c employee) {
            this.passingTest.Employee__c = employee.Id;
            return this;
        }

        public PassingTestBuilder setEmployeeTest(EmployeeTest__c test) {
            this.passingTest.Test__c = test.Id;
            return this;
        }

        public PassingTestBuilder setStartDate(Datetime startDate) {
            this.passingTest.StartDate__c = startDate;
            return this;
        }

        public PassingTestBuilder setEndDate(Datetime endDate) {
            this.passingTest.EndDate__c = endDate;
            return this;
        }

        public PassingTest__c buildPassingTest() {
            return this.passingTest;
        }
    }

    public with sharing class EmployeeBuilder {
        private Employee__c employee = new Employee__c();
        private EmployeeBuilder() {
            this.employee.Name = 'Test Employee';
            this.employee.Active__c = true;
            this.employee.EmploymentDate__c = Date.today();    
        }

        public EmployeeBuilder setName(String name) {
            this.employee.Name = name;
            return this;
        }

        public EmployeeBuilder setActive(Boolean active) {
            this.employee.Active__c = active;
            return this;
        }

        public EmployeeBuilder setEmploymentDate(Date employmentDate) {
            this.employee.EmploymentDate__c = employmentDate;
            return this;
        }

        public Employee__c buildEmployee() {
            return this.employee;
        }
    }

    public with sharing class EmployeeTestBuilder {
        private EmployeeTest__c test = new EmployeeTest__c();
        private EmployeeTestBuilder() {
            this.test.Name = 'Test';
            this.test.Active__c = true;
            this.test.AccessCode__c = '1111';
            this.test.MinimumPoints__c = 20;
            this.test.MaximumPoints__c = 24;   
        }

        public EmployeeTestBuilder setName(String name) {
            this.test.Name = name;
            return this;
        }

        public EmployeeTestBuilder setActive(Boolean active) {
            this.test.Active__c = active;
            return this;
        }

        public EmployeeTestBuilder setAccessCode(String accessCode) {
            this.test.AccessCode__c = accessCode;
            return this;
        }

        public EmployeeTestBuilder setMinimumPoints(Integer minPoints) {
            this.test.MinimumPoints__c = minPoints;
            return this;
        }

        public EmployeeTestBuilder setMaximumPoints(Integer maxPoints) {
            this.test.MaximumPoints__c = maxPoints;
            return this;
        }

        public EmployeeTest__c buildEmployeeTest() {
            return this.test;
        }
    }

    public with sharing class TestQuestionBuilder {
        private TestQuestion__c question = new TestQuestion__c();
        private TestQuestionBuilder() {
            this.question.Name = 'Test Question';
            this.question.QuestionText__c = this.question.Name;
            this.question.Active__c = true; 
        } 
        
        public TestQuestionBuilder setName(String name) {
            this.question.Name = name;
            return this;
        }

        public TestQuestionBuilder setQuestionText(String text) {
            this.question.QuestionText__c = text;
            return this;
        }

        public TestQuestionBuilder setActive(Boolean active) {
            this.question.Active__c = active;
            return this;
        }

        public TestQuestionBuilder setEmployeeTest(EmployeeTest__c test) {
            this.question.Employee_Test__c = test.Id;
            return this;
        }

        public TestQuestion__c buildTestQuestion() {
            return this.question;
        }
    }

    public with sharing class TestQuestionAnswerBuilder {
        private TestQuestionAnswer__c answer = new TestQuestionAnswer__c();
        private TestQuestionAnswerBuilder() {
            this.answer.Name = 'Test answer';
            this.answer.AnswerText__c = this.answer.Name;
            this.answer.Active__c = true; 
        }
        
        public TestQuestionAnswerBuilder setName(String name) {
            this.answer.Name = name;
            return this;
        }

        public TestQuestionAnswerBuilder setAnswerText(String text) {
            this.answer.AnswerText__c = text;
            return this;
        }

        public TestQuestionAnswerBuilder setActive(Boolean active) {
            this.answer.Active__c = active;
            return this;
        }

        public TestQuestionAnswerBuilder setTestQuestion(TestQuestion__c question) {
            this.answer.TestQuestion__c = question.Id;
            return this;    
        }

        public TestQuestionAnswer__c buildTestQuestionAnswer() {
            return this.answer;
        }
    }

    public static PassingTestBuilder getPassingTestBuilder() {
        return new PassingTestBuilder();
    }

    public static EmployeeBuilder getEmployeeBuilder() {
        return new EmployeeBuilder();
    }

    public static EmployeeTestBuilder getEmployeeTestBuilder() {
        return new EmployeeTestBuilder();
    }

    public static TestQuestionBuilder getTestQuestionBuilder() {
        return new TestQuestionBuilder();
    }

    public static TestQuestionAnswerBuilder getTestQuestionAnswerBuilder() {
        return new TestQuestionAnswerBuilder();
    }
}
