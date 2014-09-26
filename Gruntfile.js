module.exports = function(grunt) {
  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    watch: {
      files: ['package/coffee/**/*.coffee'],
      tasks: 'coffee'
    },
    coffee: {
      compile: {
        files: [{
          expand: true,
          cwd: 'package/coffee/',
          package: ['**/*.coffee'],
          dest: 'package/js/',
          ext: '.js',
        }, {
          'package/js/trello_client.js': 'bower_components/trello_client/index.coffee',
        }]
      }
    }
  });

  // TASK:coffee
  grunt.loadNpmTasks("grunt-contrib-coffee");

  // TASK: default
  grunt.registerTask(
    'default',
    'build a package.',
    function() {
      grunt.task.run('coffee');
      grunt.file.copy('bower_components/jquery/dist/jquery.min.js', 'package/js/jquery.js');
      grunt.file.copy('package/manifest.json', 'package');
      grunt.file.copy('package/icon', 'package/icon');
      grunt.file.copy('package/manifest.json');
    }
  );
  grunt.registerTask('watch', ['watch']);
}
