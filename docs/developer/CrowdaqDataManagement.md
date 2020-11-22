# Crowdaq Data Management System

This document describe the implementation of Crowdaq Data Management System Server.

## API Design

We use an unconventianial Single Endpoint API Design pattern, similar to GraphQL. Our API are served at a single URL (https://www.crowdaq.com/api)[https://www.crowdaq.com/api] and implemented using `express.js`.

### HTTP Method
POST is the only HTTP method allowed at this url. We choose this as there exist certain client library that don't support adding json body to GET requests. And in our case, the semantic meaning of HTTP method is not so important in our API design.

### Content Type

We only support two content type, `application/json` and `multipart/form-data`.

We use `multipart/form-data` when the associated request require file uploading, and `application/json` is used for all other API calls that do not requrie file uploading.

### Request Body
Each request must follow the following schema:

```json
{
    "op": String,
    "args": Object
}
```

The JSON will translate to a function call in our backend, where the `op` name will match one of the resolver name, and args will be passed to that resolver. For example:

The JSON Request:

```
{
    "op": "instruction.get",
    "args": {
        "owner": "you_username",
		"instruction_id": "some_name"
    }
}
```

In `multipart/form-data` type of response, the JSON payload should part header:
`Content-Disposition: form-data; name="op_api"`. The it will be route to the correct resolver, with each part of `multipart/form-data` filled in the `args` object.


## API

We provide list of existing OPs here along with their description and `args` type:

```json
{
	"op": "login",
	"args": {
		"perporties": {
			"username": {
				"type" : "String",
			},
			"username": {
				"type" : "String",
			},
		}
	},
	"return": {
		"perporties": {
			"token": {
				"type" : "String",
			}
		}	
	}
}

LIST TO BE FILLED..

```

### Client

We use axios in frontend for all HTTP calls. In any VUE component, you can use `$client` object, which has already included the . For example:

```js
this.$client.make_request("instruction.get", {
	owner, instruction_id
}).then(resp => {
	const {
		definition
	} = resp.data;
	console.log(definition);
}).catch(err => {...})
```

Similarly, you can use `request` library in python to call our API:
```python
resp = request.post(f"{endpoint_url}", {
	"op": "instruction.get",
	"args" : {
		"owner": "some_name",
		"instruction_id": "some_name",
	}
}, headers={
	"Authorization": f"Bearer {token}",
	"Content-Type": "application/json"
})
```

### Backend Implementation

#### Database Access and Mirgration

We rely on `knex` to query the database. And we also use `knex` to manage migration, all schema definitions can be found in `migrations` folder. For more one `knex`, you can reference their [official website](http://knexjs.org/);

#### Authencation

We use JWT Bearer Token for authencation purpose. We have a very simple middleware that parse all incoming token, and populate `req.__user__` object with `{username: verified.username}`. So in any API resolver, you can aceess this value to obtain the user identity that are making this request.

