module.exports = function(grunt) {
  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    watch: {
      files: ['coffee/**/*.coffee'],
      tasks: 'coffee'
    },
    coffee: {
      compile: {
        files: [{
          expand: true,
          cwd: 'coffee/',
          src: ['**/*.coffee'],
          dest: 'js/',
          ext: '.js',
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
      grunt.file.mkdir('./js');
      grunt.file.copy('./bower_components/jquery/dist/jquery.min.js', './js/jquery.js')
      grunt.file.copy('./bower_components/client/index.coffee', './coffee/trello_client.coffee')
      grunt.task.run('coffee')
    }
  );
  grunt.registerTask('watch', ['watch']);
}
