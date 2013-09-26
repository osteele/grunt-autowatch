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

    testTask:
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

    testTaskTwo:
      target:
        src: 'test/files/one.txt'
      targetTwo:
        src: 'test/files/two.txt'

    autowatch:
      options:
        run: false
        tasks: ['testTaskTwo', 'testTaskTwo:targetTwo']

    watch:
      testTask: {}
      defined:
        tasks: ['defined']
        files: ['test/files/defined.txt']
      fileString:
        tasks: ['testTask:fileString']
      filesArray:
        tasks: ['testTask:filesArray']
      fileObject:
        tasks: ['testTask:fileObject']
      compactFiles:
        tasks: ['testTask:compactFiles', 'testTask:compactFilesCwd']
      mergeNegativePatterns:
        tasks: ['testTask:negative1', 'testTask:negative2']

  grunt.loadTasks 'tasks'

  require('load-grunt-tasks')(grunt)

  grunt.registerTask 'testTask', []

  grunt.registerTask 'test', ['autowatch', 'nodeunit']
  grunt.registerTask 'default', ['coffeelint', 'test']
