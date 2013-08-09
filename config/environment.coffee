module.exports =
  development:
    app:
      name: 'Otagai.js'
    root: require('path').normalize(__dirname + '/..')
    db: process.env.MONGOLAB_URI || process.env.MONGOHQ_URL \
        || 'mongodb://localhost/otagai'