Launching Jobs to MTurk
--------------

On the top right of your Crowdaq web UI, you should be able to see "UPDATE USER PROFILE". That is for providing your AWS access keys to Crowdaq. 

*As of Nov 2020, Crowdaq's website will only use AWS access keys to help you automatically assign qualifications to workers (which is indeed a very convenient feature), so you can provide us with your access keys only with permission to manage your qualifications (e.g., you can delete "publish HITs" permissions for safety)*

*Crowdaq's local client software, however, will require full access to MTurk. Note this key will stay local on your laptop and will NOT be sent to us at all.*

## Exam
Before you launch your exam to MTurk, please go to the edit page of your exam, click on "UPDATE EXAM CONFIGURATION", and check the following things:

- Instruction ID and Tutorial ID: Your exam will be associated with an instruction and a tutorial (see this [screenshot](./figs/exam-links.png)). Type in, if you haven't done so, the corresponding Instruction ID and Tutorial ID.
- MTurk Qualification ID: If a worker passes your exam, what is the qualification ID that you want to associate with this worker? You can either use [MTurk's web UI](https://docs.aws.amazon.com/AWSMechTurk/latest/RequesterUI/CreatingaQualificationType.html), or create qualifications [programmatically](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/mturk.html#MTurk.Client.create_qualification_type). If you leave this field blank, Crowdaq will not be able to assign qualifications to your workers (you will need to do it yourself).
- Number of question per exam offering: This is the number of questions a worker will see every time. For instance, you may have 50 questions in total, but you type 10 here, then a worker will only see 10 random questions from your question pool. If the worker fails and there's another chance left, the worker will see another random sample of 10 questions. This is very important to avoid trial-and-errors of workers.
- Max allowed attempts: As another method to prevent trial-and-errors, we only give a particular worker limited number of attempts. If they run out of their chances, they won't be able to work on this exam anymore (even if they see your exam HITs on MTurk, they won't be able to work on it).
- Passing Grade: If you want to allow those who are correct on 70% of your exam questions, type 0.7 here.
- Time limit in seconds: The time allowed for a worker to work on your exam in each attempt. 

Open the client software of Crowdaq, go to the exam you want to launch, and launch it. A few tips:
- Remember to set up your AWS credentials associated with your MTurk account ([AWS instruction](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)).
- Those fields required by Crowdaq's local client are exactly the same terminology as MTurk.
- It's a good practice to always launch your task to sandbox to avoid mistakes.

## Task Set
Launching a task set to MTurk is simpler than launch an exam, and you can use Crowdaq's local client to do so. One special function provided by Crowdaq, which we have found to be very useful in practice, is two counting modes.

For instance, you have 100 tasks in your task set to be launched, people have already worked on it, but haven't finished, such that 50 of them have got two different workers, 40 of them have got three different workers, and 10 have got nothing. There are two modes to launch new hits:


- Create new hits for each task item (e.g., 3): Each one of the 100 tasks will be launched 3 times.
- Create new hits until each task item has at least this amount of assignments (e.g., 3): 50 of them will be launched once, 40 will be launched zero times, and 10 will be launched 3 times.