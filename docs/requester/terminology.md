Terminology
-----------

If you are not clear about what we mean by "instructions", "tutorial", "exam", or "task set", below is a summary. Please refer to our [paper](https://arxiv.org/abs/2010.06694) for more details.

| Name on Crowdaq  | Specification on Crowdaq| Description | Note |
|:------------|:------------|:----------------------|:-------------|
|Instruction| Markdown |  It defines a task and instructs annotators how to complete the tasks. | It supports various formatting options, including images and videos. Any static annotation guidelines can be displayed here. |
|Tutorial | JSON | Additional training material that workers can use to gauge their understanding of the instruction. |  As of now tutorials are in the form of multiple-choice questions. Anyone, either through or without MTurk, can work on tutorials and see the answers and doesn't get penalized. |
Exam | JSON | | It tests annotators' understanding of the task and only those qualified can continue; this step is very important in reducing unqualified annotators. | Another collection of multiple-choice questions. Participants will only have a finite number of opportunities to work on it, and each time they will see a random subset from a larger pool. After finishing an exam, participants are informed of how many mistakes they have made and whether they have passed, but they do not receive feedback on individual questions. |
|Task set | JSON | Where qualified annotators work on the task | We provide many built-in UI components that you can use to build very complex annotation interfaces. More details in the [syntax](syntax.md) section.|

