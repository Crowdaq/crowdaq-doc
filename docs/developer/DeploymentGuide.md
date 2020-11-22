# Deploy Crowdaq

### Application Architecture

CrowdAQ is a Single Page App, and server (in express.js) and static content (in Vue.js) are developed in seperated packages.


### Deploy with Docker (Recommended)

The best way to deploy your own instance of Crowdaq is through Docker. Simply download our repo, and run 

```
./make_docker_images.sh
docker-compose -f docker-compose.yml up 
```

The standard compose file will give you three resource groups which includes:
1. PostresQL Server
2. Static assets server and reverse proxy (Nginx)
3. Load balanced backend server groups.

And then you can access your own crowdaq at `http://127.0.0.1:9999`

If you are interested in more customized way to deploy crowdaq, please read the following guide.

### Deploy Frontend

To correctly deploy frontend package, all you need to do is correctly configure the API endpoint in `client_config.js`. By default, the development mode use `http://127.0.0.1:4000/api`, and production endpoint is `https://api.crowdaq.com/api`

Then run the command:

```
npm install
npm run build
```

You servable static content will be in the folder `dist`. Simply copy the folder to you nginx (or you favioute web server) static file root, and make sure the server will serve `index.html` on missing files since we rely on [Vue Router](https://router.vuejs.org/)'s history mode feature to render the correct page.

Example NGINX config.

```
events {}
http {
	server {
	    listen 80;
		root /app;
		gzip on;
		gzip_types text/css application/javascript application/json image/svg+xml;
		gzip_comp_level 9;
		etag on;

	    location / {
	    	root /app;
	    	index index.html index.html;
		    include  /etc/nginx/mime.types;	    	
		    try_files $uri $uri/ /index.html;
	    }   
	}
}
```

### Backend Server

You need to run `npm install` to install all dependencies. 

#### Database

We require PostgresQL 10. You can find instruction of installation of Postgresql online on their official website. In development we use an simple postgres docker by this command:
```
docker run --name some-postgres -p 55432:5432 -e POSTGRES_PASSWORD=12345678 -e POSTGRES_DB=crowdaq-dev -d postgres:10.7
```

Which will create an `postgres:10.7` instance at `PORT=55432` and with `User:Pass=postgres:12345678`.

##### Configure Database Connection

To config database connection, you need to edit `packages/backend/knexfile.js`, the content should be self-explnanatory. 

##### Init And Migration

In order to prepare crowdaq database, we simply run `npx knex migrate:latest` to create all Crowdaq Table and Indices.

```
npx knex migrate:latest
```

#### Start Backend Server

Simply run `npm run start` to start the backend server. Now you have both frontend and backend started.