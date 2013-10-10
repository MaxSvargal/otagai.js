module.exports =
  development:
    app:
      name: 'Otagai.js'
    root: require('path').normalize(__dirname + '/..')
    port: 3000
    db: process.env.MONGOLAB_URI || process.env.MONGOHQ_URL \
        || 'mongodb://localhost/dev'
