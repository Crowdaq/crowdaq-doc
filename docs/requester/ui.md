UI Design
----------

Designing user-interface (UI) is often the most time consuming part for data requesters who are often not experts on frontend design. The UI component of Crowdaq aims to separate the underlying logic of your data annotation project from frontend design, so that you can design UI *declaratively* without worrying about how to implement them in the frontend.

With Crowdaq, things that you need to focus about your exam are:
- What are the exam questions I want to use to test people's understanding of my task? 
- What is the pass score?
- How many chances do I want to give to each worker?

Similarly, things that you need to focus about your main task are:
- What type of UI I want to use, multiple-choice questions, span selections, or free text?
- Are some questions conditioned on some others?
- Do I have to enforce certain constraints so that people won't make careless mistakes?

Since all our exam questions are multiple-choice questions, you do not have to design UI for that -- we have already done that for you. This document focuses on how you design UI for your main tasks.

## UI workspace
The most convenient way of UI designing may be starting from existing examples and make changes according to one's need. You can go to our [UI workspace](https://dev2.crowdaq.com/collector_demo), where you can find some useful templates to start with.

## List of currently supported types

### text
```
{
    "type": "text",
    "prompt": "Input some text",
    "id": "id"
}
```

### datetime
```
{
    "granularities": [
        "day","month"
    ],
    "id": "id",
    "prompt": "Select a date",
    "type": "datetime"
}
```                

### span-from-text
```
{
    "type": "span-from-text",
    "prompt": "Please select multiple spans:",
    "id": "id",
    "from_context": "my_doc"
}
```

### multiple-choice
```
{
    "type": "multiple-choice",
    "prompt": "Do you use wikipedia?",
    "id": "id",
    "options": {
        "A": "Yes",
        "B": "No"
    }
}
```

### multi-label
```
{
    "type": "multi-label",
    "prompt": "Please select multiple from below",
    "id": "id",
    "options":{
        "A":"Option A",
        "B":"Option B",
        "C":"Option C"
    }
}
```

Note you can always check our [syntax](https://github.com/Crowdaq/crowdaq/tree/main/packages/schema/crowdaq/json_schema).

## Conditions
Decide whether or not to enable certain questions based on values on other questions. We support `eq`, `not`, `and`, and `or`, four logical operations. Please see [here](https://github.com/Crowdaq/crowdaq/blob/main/packages/schema/crowdaq/json_schema/condition.json).
Syntax for `eq`: enabled only when another question's answer `B`.
```
"conditions": [
    {
        "id": "id_of_another_question",
        "op": "eq",
        "value": "B"
    }
]
```

Syntax for `or` or `and`:
```
"conditions": [
    {
    	"op": "or",
        "args": [
            {
                "id": "id1",
                "op": "eq",
                "value": "A"
            },
            {
                "id": "id2",
                "op": "eq",
                "value": "B"
            }
        ]
    }
],
```

Syntax for `not`:
```
"conditions": [
    {
    	"op": "not",
        "arg": {
            "id": "id",
            "op": "eq",
            "value": "C"
        }
    }
],
```

Combining multiple conditions (implicitly these conditions are `and`). The condition below means this question is enabled only when question1 is NOT `C` AND question2 is NOT `B`.
```
"conditions": [
    {
        "arg": {
            "id": "question1",
            "op": "eq",
            "value": "C"
        },
        "op": "not"
    },
    {
        "arg": {
            "id": "question2",
            "op": "eq",
            "value": "B"
        },
        "op": "not"
    }
],
```

## Constraints
We currently support regex constraints for any type.
```
"constraints": [
    {
        "type": "regex",
        "regex": "^\\S{3,8}$",
        "description": "The span must has length 3-8, and contain no whitespaces"
    }
]
```

Within an annotation group or span-from-text annotation, you can also specify the number of repetations:
```
"repeated": true,
"min": 8,
"max": 12,
```

## Create a task set
Once you converge to a UI, do not forget to construct your task set following this [task json in a zip file](./examples/tasks-sharable.zip) and upload that to your Crowdaq website to create a task set. 