![Otagai.js](https://dl.dropboxusercontent.com/u/931817/POST/otagai.png)
### Otagai is an architecture application skeleton and framework that allows you to develop websites rapidly in Node.js and Express.

----
See more info on [project homepage](http://otagai.maxsvargal.com)
## How to install

1. Download and install [Node.js](http://nodejs.org/), [MongoDB](http://mongodb.org/) and [Python](http://python.org/) (for mongodb bson npm module).

2. Install otagai.js globally:

   ```sh
   npm install -g otagai
   ```

3. Navigate to a directory where you have rights to create files, and type:
   ```sh
   otagai new app
   ```
   This will create an otagai.js application called App in a directory called app and install the npm dependencies.

4. Change into the app directory and start development server
   ```sh
   cd app
   otagai server dev
   ```

## CLI usage
### Server
  To use these commands you must be in app folder.
  To run application in production mode:
   ```sh
   otagai server prod
   ```
  To stop application:
   ```sh
   otagai server stop
   ```
  To restart:
   ```sh
   otagai server restart
   ```
  You may restart server forced with ```-f``` flag.
  This kill all node and mongo processes.

### Admin user
   ```sh
   otagai createuser -u username -e email@adress.com -p password
   ```
   Creates a superuser account (a user who has all default permissions).
   This command useful for create initial user account.

### Generators
   For generate model:
   ```sh
   otagai gen model demo -f name:string,count:number
   ```
   Controller:
   ```sh
   otagai gen controller demo
   ```
   Views:
   ```sh
   otagai gen views demo
   ```
   Scaffold (model, controller, views):
   ```sh
   otagai gen scaffold demo -f name:string,count:number
   ```

## Inspiration
Project based on [form5-node-express-mongoose-coffeescript](https://github.com/olafurnielsen/form5-node-express-mongoose-coffeescript)

Otagai.js thinks to develop as modular framework, focused on convenience and speed of development: livereload, fast transparent preprocessing, easy database migrations and deploying. This is collection of massive patterns and best Node.js practicals.
