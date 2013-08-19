// Generated by CoffeeScript 1.6.3
(function() {
  var ScaffoldGenerator, fs, scaffold, _;

  _ = require('underscore');

  fs = require('fs');

  _.templateSettings = {
    interpolate: /\{\{(.+?)\}\}/g
  };

  ScaffoldGenerator = (function() {
    function ScaffoldGenerator() {}

    ScaffoldGenerator.prototype.genController = function(name, params) {
      var outputPath, templatePath;
      templatePath = "" + __dirname + "/templates/controllerTemplate.coffee";
      outputPath = "" + __dirname + "/output/controllers/" + name + ".coffee";
      return this.generate(templatePath, outputPath, params);
    };

    ScaffoldGenerator.prototype.genModel = function(name, params) {
      var outputPath, templatePath;
      templatePath = "" + __dirname + "/templates/modelTemplate.coffee";
      outputPath = "" + __dirname + "/output/model/" + name + ".coffee";
      return this.generate(templatePath, outputPath, params);
    };

    ScaffoldGenerator.prototype.generate = function(templatePath, outputPath, params) {
      return fs.readFile(templatePath, function(err, data) {
        var compilied;
        if (err) {
          throw err;
        }
        compilied = _.template(data, params);
        return fs.writeFile(outputPath, compilied, function(err) {
          if (err) {
            throw err;
          }
          return console.log('success write controller template');
        });
      });
    };

    return ScaffoldGenerator;

  })();

  scaffold = new ScaffoldGenerator;

  scaffold.genController('demo', function() {
    return {
      name: 'Demo',
      test: 'test string',
      test2: 'second test'
    };
  });

}).call(this);
