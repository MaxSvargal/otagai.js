![Otagai.js](https://dl.dropboxusercontent.com/u/931817/POST/otagai.png)
### Otagai is a micro architecture application skeleton that allows you to develop websites rapidly in Node.js and Express.

----
## How to install

1. Download and install [Node.js](http://nodejs.org/), [MongoDB](http://mongodb.org/) and [Python](http://python.org/) (for mongodb bson npm module).
2. Install Otagai globally (only for dev):
   ```sh
   npm install -g otagai
   ```

3. Install the Node package for the grunt command line interface globally.
   ```sh
   npm install -g grunt-cli
   ```

4. Navigate to a directory where you have rights to create files, and type:

   ```sh
   otagai new app
   ```
   This will create an otagai.js application called App in a directory called app and install the npm dependencies.

5. Change into the app directory.

6. Start dev server from shell script (recommended)
   ```sh
   chmod +x ./bin/dev.sh && ./bin/dev.sh
   ```
  or start grunt directly
   ```sh
   grunt
   ```

## Generators
   Coming soon...


## Inspiration
Project based on [form5-node-express-mongoose-coffeescript](https://github.com/olafurnielsen/form5-node-express-mongoose-coffeescript)

Otagai.js thinks to develop as modular framework, focused on convenience and speed of development: livereload, fast transparent preprocessing, easy database migrations and deploying. This is collection of massive patterns and best Node.js practicals.
