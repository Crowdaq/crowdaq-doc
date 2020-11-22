# Annotation Framework Design

Hint: We heavily use [Destructuring assignment](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment) and [spread operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax) to keep our syntax clean, so make sure you are comfortable with those JS language features.

The Crowdaq Annotation Framework (CAF) is a genreal framework for building annotation UI. 

CAF has the following core components:
1. Annotation Store
2. Annotation Collector Component Collections

# Annotation Store

The Annotation Store is a standard [Vuex](https://vuex.vuejs.org/) store, with the following getter.
```js
getAnnotationGroupDefinition: {groupId} => Object;
getAnnotationCollectorDefinition: {groupId, collectorId} => Object;

// If condition is matched.
isCollectorEnabled: {groupId, repeatedGroupId, collectorId} => Boolean;

// If constrints is passed.
isCollectorConstrintPassed: {groupId, repeatedGroupId, collectorId} => Boolean;
getCollectorErrorMessage: {groupId, repeatedGroupId, collectorId} => List[String];

getCurrentAnnotationResults: {groupId, repeatedGroupId, collectorId} => Object;

getContext: {contextId} => Object;
```

And has the following mutations:
```js

registerAnnotationGroup(state, {annotationGroup})
registerContexts(state, {contextsList})

deregisterAnnotationGroup(state, {annotationGroup})
deregisterContexts(state, {contextsList})

updateAnnotation (groupId, repeatedGroupId, collectorId)
addRepeatedAnnotationGroup (groupId, repeatedGroupId)
deleteRepeatedAnnotationGroup (groupId, repeatedGroupId)
```

# Annotation Collector Component Collections

We have the following collector components implemented:
* Span From Text
* Multiple Choice
* TODO: List them all.




# Extend CrowdAQ Annotation Framework

Extend the CrowdAQ functionality is very easy. For most our readers, you may be interesting in adding functionality to one of the three:

* Condition
* Constraints
* Annotation Component

## Add new Condition type.

In order to add an Condition Type, you will need to add a handler function to `ConditionHandlers` in `annotation_system.js`. The handler will be called condition type matches the one you specified, and your handler function must return `true` when the condition is passed, and `false` if not. You handler function will be called with the store object and the condition definition along with `annotation_group_id` and `annotation_id`.

```js
const repeatedSpanCountHandler = new ConditionHandler({
	on: "RepeatedSpanCount",
	dependOn: ({
		// This object is the parent collector of this condition, 
		// and the currently used handlers in case you need to evaluate this condition recursively.
		handlers, groupId, repeatedGroupId, collectorId
	}, {
		// This is your condition definition
		operator, count, other
	}) => {
		// This function need to return signatures of all annotation results that this condition depends on.
		return [
			{
				groupId, repeatedGroupId, collectorId: other
			}
		];
	},
	handle: ({
		// This object is the parent collector of this condition.
		groupId, repeatedGroupId, collectorId
	}, {
		// This is your condition definition
		operator, count, other
	}) => {
		const length = return getCurrentAnnotationResults(groupId, repeatedGroupId, collectorId).length;
		if (operator === '>'){
			return length > count
		}else if (operator === '='){
			return length === count;
		} // The rest of your implementation...

		}
});

// Now we add this handler to handlers.
ConditionHandlers.add(repeatedSpanCountHandler);
```

Your handler will be called if any of you dependencies' annotation updated, so it is important to implement dependOn chains correctly.

## Add new Constraint type.

Adding an Constraint handler is similar to adding condition handler, but it is easier as constraint checking is local.
```js
const regexHandler = new ConstraintHandler({
	on: "string-length",
	handle: ({
		// This object is the parent collector of this condition.
		groupId, repeatedGroupId, collectorId
	}, {
		// This is your condition definition
		min, max
	}) => {
		const text = return getCurrentAnnotationResults(groupId, repeatedGroupId, collectorId);
		if (text.length > max){
			return {
				pass: false,
				messages: [
					`String must not be longer than ${max}`
				]
			}
		}else if (text.length < min){
			return {
				pass: false,
				messages: [
					`String must not be shorter than ${max}`
				]
			}
		}else{
			return {
				pass: true
			}
		}
	}
});

// Now we add this handler to handlers.
ConstraintHandlers.add(regexHandler);
```


## Add new Collector

Adding a collector is also simple, since collector Component is just an simple Vue component that follows the following behaviour:

1. It will take props `definition` which is collector definition.
2. It will update the annotation store on worker input using store mutation `updateAnnotation`.
3. It should listen for `isCollectorConstrintPassed` and display `getCollectorErrorMessage` when every possible.

```html
<template>
    <div>
        <p>
            {{this.definition.prompt}}
        </p>

        <div>
            <v-text-field
                    item-text="label"
                    v-model="current_value"
            ></v-text-field>
        </div>

        <div v-if="pass_constraint">
        	<div v-for="(msg, idx) in error_messages" :key='idx'>
        		{{message}}
        	</div>
        </div>

    </div>
</template>
```

```js
export default {
    name: "TextCollector",
    props: {
        definition: {
            type: Object
        }
    },
    data: () => ({

    }),
    computed: {

    	pass_constraint: function(){
			const {
				groupId, repeatedGroupId, collectorId
			} = this.definition;

			this.$store.getters['isCollectorConstrintPassed'](groupId, repeatedGroupId, collectorId)
		},

		error_messages: function(){
			const {
				groupId, repeatedGroupId, collectorId
			} = this.definition;

			this.$store.getters['getCollectorErrorMessage'](groupId, repeatedGroupId, collectorId)
		},

		current_value: {
			get(){
				const {
					groupId, repeatedGroupId, collectorId
				} = this.definition;

				this.$store.getters['getCurrentAnnotationResults'](groupId, repeatedGroupId, collectorId)
			},

			set(new_value){
				const {
					groupId, repeatedGroupId, collectorId
				} = this.definition;
				this.$store.commit("annotation_store/updateAnnotation", {groupId, repeatedGroupId, collectorId})
			},
		}
    }
}
```
