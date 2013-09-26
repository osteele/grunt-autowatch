grunt = require 'grunt'

exports.autowatch =
  default_tasks: (test) ->
    test.deepEqual grunt.config.get('watch.testTask.tasks'), ['testTask']
    test.done()

  dont_replace_tasks: (test) ->
    test.deepEqual grunt.config.get('watch.defined.tasks'), ['defined']
    test.done()

  dont_replace_files: (test) ->
    test.deepEqual grunt.config.get('watch.defined.files'), ['test/files/defined.txt']
    test.done()

  file_string: (test) ->
    test.deepEqual grunt.config.get('watch.fileString.files'), ['test/files/string.txt']
    test.done()

  files_array: (test) ->
    test.deepEqual grunt.config.get('watch.filesArray.files').sort(),
      ['test/files/array1.txt', 'test/files/array2.txt']
    test.done()

  file_object: (test) ->
    test.deepEqual grunt.config.get('watch.fileObject.files').sort(),
      ['test/files/object1.txt', 'test/files/object2.txt']
    test.done()

  compact_files: (test) ->
    test.deepEqual grunt.config.get('watch.compactFiles.files').sort(),
      ['test/files/compact-cwd.txt', 'test/files/compact.txt']
    test.done()

  merge_negative_patterns: (test) ->
    test.deepEqual grunt.config.get('watch.mergeNegativePatterns.files').sort(),
      [
       '!test/files/exclude3',
       'test/files/negative1.txt',
       'test/files/negative2.txt',
       'test/files/negative3.txt',
      ]
    test.done()

  combine_targets: (test) ->
    test.deepEqual grunt.config.get('watch.testTask.files').sort(),
      [
       'test/files/array1.txt',
       'test/files/array2.txt',
       'test/files/compact-cwd.txt',
       'test/files/compact.txt',
       'test/files/negative1.txt',
       'test/files/negative2.txt',
       'test/files/negative3.txt',
       'test/files/object1.txt',
       'test/files/object2.txt',
       'test/files/string.txt',
      ]
    test.done()

  create_task: (test) ->
    test.deepEqual grunt.config.get('watch.testTaskTwo.tasks'), ['testTaskTwo']
    test.deepEqual grunt.config.get('watch.testTaskTwo.files').sort(),
      ['test/files/one.txt', 'test/files/two.txt']
    test.done()

  create_task_with_target: (test) ->
    test.deepEqual grunt.config.get('watch.testTaskTwo:targetTwo.tasks'), ['testTaskTwo:targetTwo']
    test.deepEqual grunt.config.get('watch.testTaskTwo:targetTwo.files'), ['test/files/two.txt']
    test.done()
