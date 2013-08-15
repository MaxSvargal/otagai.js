![Otagai.js](https://dl.dropboxusercontent.com/u/931817/POST/otagai.png)
### Otagai is a micro architecture application skeleton that allows you to develop websites rapidly in Node.js and Express.

----
## How to install

1. Download and install [Node.js](http://nodejs.org/) and [MongoDB](http://www.mongodb.org/)
2. Install the Node package for the grunt command line interface globally.

   ```sh
   sudo npm install -g grunt-cli
   ```

4. Change into the Otagai.js root directory.
5. Start the build (will install dependencies and build).

   ```
   npm install
   ```
   
6. Start dev server from shell script (recommended)
   ```sh
   chmod +x ./bin/dev.sh && ./bin/dev.sh
   ```
  or start grunt directly
   ```sh
   grunt
   ```


## Inspiration
Project based on [form5-node-express-mongoose-coffeescript](https://github.com/olafurnielsen/form5-node-express-mongoose-coffeescript)

Otagai.js thinks to develop as modular framework, focused on convenience and speed of development: livereload, fast transparent preprocessing, easy database migrations and deploying. This is collection of massive patterns and best Node.js practicals.
