# grunt-contextualize
# https://github.com/osteele/grunt-contextualize
#
# Copyright (c) 2013 Oliver Steele
# Licensed under the MIT license.

module.exports = (grunt) ->
  grunt.initConfig
    coffeelint:
      all: ['**/*.coffee', '!node_modules/**/*']
      options:
        max_line_length: { value: 120 }

    nodeunit:
      context1: 'test/**/*_test.coffee'

    dummy:
      fileString: 'test/files/string.txt'
      compactFiles:
        src: ['test/files/compact.txt']
      compactFilesCwd:
        cwd: 'test/files'
        src: ['compact-cwd.txt']
      fileObject:
        files:
          'build/object1.txt': 'test/files/object1.txt'
          'build/object2.txt': 'test/files/object2.txt'
      filesArray:
        files: [
          {src: 'test/files/array1.txt'}
          {src: ['array2.txt'], cwd: 'test/files'}
        ]
      negative1:
        src: ['test/files/negative1.txt', '!test/files/exclude1', '!test/files/exclude2', '!test/files/exclude3']
      negative2:
        files: [
          {src: ['test/files/negative2.txt', '!test/files/exclude2', '!test/files/exclude3']}
          {src: ['negative3.txt', '!exclude3', '!exclude4'], cwd: 'test/files'}
        ]

    autowatch:
      options:
        run: false

    watch:
      dummy: {}
      defined:
        tasks: ['defined']
        files: ['test/files/defined.txt']
      fileString:
        tasks: ['dummy:fileString']
      filesArray:
        tasks: ['dummy:filesArray']
      fileObject:
        tasks: ['dummy:fileObject']
      compactFiles:
        tasks: ['dummy:compactFiles', 'dummy:compactFilesCwd']
      mergeNegativePatterns:
        tasks: ['dummy:negative1', 'dummy:negative2']

  grunt.loadTasks 'tasks'

  require('load-grunt-tasks')(grunt)

  grunt.registerTask 'dummy', []

  grunt.registerTask 'test', ['autowatch', 'nodeunit']
  grunt.registerTask 'default', ['coffeelint', 'test']
