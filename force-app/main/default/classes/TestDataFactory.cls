@isTest
public with sharing class TestDataFactory {
    private class PostWrapper {
        public Integer id;
        public Integer userId;
        public String title;
        public string body;
    }

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

    public static Employee__c createEmployee() {
        Employee__c employee = getEmployeeBuilder()
            .buildEmployee();
        
        insert employee;
        return employee;
    }

    public static EmployeeTest__c createEmployeeTest() {
        EmployeeTest__c test = getEmployeeTestBuilder()
            .buildEmployeeTest();

        insert test;
        return test;
    }

    public static List<EmployeeTest__c> createEmployeeTests(Integer numTests) {
        List<EmployeeTest__c> tests = new List<EmployeeTest__c>();

        for (Integer i = 0; i < numTests; i++) {
            EmployeeTest__c test = getEmployeeTestBuilder()
                .setName('Test ' + i)
                .buildEmployeeTest();

            tests.add(test);
        }

        insert tests;
        return tests;
    }

    public static List<TestQuestion__c> createTestQuestions(EmployeeTest__c test, Integer numQuestions) {
        List<TestQuestion__c> questions = new List<TestQuestion__c>();

        for (Integer i = 0; i < numQuestions; i++) {
            TestQuestion__c question = getTestQuestionBuilder()
                .setName('Question ' + i)
                .setEmployeeTest(test)
                .buildTestQuestion();

            questions.add(question);
        }

        insert questions;
        return questions;    
    }

    public static List<TestQuestionAnswer__c> createTestQuestionAnswers(List<TestQuestion__c> questions, Integer numAnswers) {
        List<TestQuestionAnswer__c> answers = new List<TestQuestionAnswer__c>();
        
        for (TestQuestion__c question : questions) {
            for (Integer i = 0; i < numAnswers; i++) {
                TestQuestionAnswer__c answer = getTestQuestionAnswerBuilder()
                    .setName('Answer ' + i)
                    .setTestQuestion(question)
                    .buildTestQuestionAnswer();
    
                answers.add(answer);
            }    
        }
        
        insert answers;
        return answers;
    }

    public static PassingTest__c createPassingTest(Employee__c employee, EmployeeTest__c test, Datetime startDate) {
        PassingTest__c passingTest = getPassingTestBuilder()
            .setEmployee(employee)
            .setEmployeeTest(test)
            .setStartDate(startDate)
            .buildPassingTest();

        insert passingTest;
        return passingTest;
    }

    public static void createPostsFromJSON(String postsJson) {
        List<Post__c> postsToUpsert = new List<Post__c>();
        List<PostWrapper> posts = (List<PostWrapper>) JSON.deserialize(postsJson, List<PostWrapper>.class);

        for (PostWrapper post : posts) { 
            Post__c postToupsert = new Post__c(ExternalId__c = post.id, 
                                                UserId__c = post.userId,
                                                Title__c = post.title,
                                                Body__c = post.body);                
            postsToUpsert.add(postToupsert);
        }

        upsert postsToUpsert ExternalId__c;
    }
}
