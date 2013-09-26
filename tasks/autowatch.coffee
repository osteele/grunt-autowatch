# grunt-autowatch
# https://github.com/osteele/grunt-autowatch
#
# Copyright (c) 2013 Oliver Steele
# Licensed under the MIT license.

fs = require 'fs'
path = require 'path'

module.exports = (grunt) ->
  _ = grunt.util._
  path = require 'path'
  description = grunt.file.readJSON(path.join(path.dirname(module.filename), '../package.json')).description

  # from lib/grunt/task.js
  isValidMultiTaskTarget = (target) ->
    return !/^_|^options$/.test(target)

  isFileObject = (data) ->
    return false unless data
    Boolean(identifyFileObjectFormat(data))

  # These are the formats documented at http://gruntjs.com/configuring-tasks#files.
  # "Older" format is omitted.
  identifyFileObjectFormat = (data) ->
    switch
      when _.isString(data) then "String"
      when 'src' of data then "Compact"
      when grunt.util.kindOf(data.files) == 'object' then "File Object"
      when _.isArray(data.files) then "Files Array"
      else null

  # returns an array of arrays of files from a grunt configuration file mapping object
  getFileObjectSourceFileLists = (data) ->
    sourceFileExtractors =
      "String": -> [[data]]
      "Compact": -> [getCompactFormatSourceFiles(data)]
      "File Object": -> [_.values(data.files)]
      "Files Array": -> data.files.map(getCompactFormatSourceFiles)
    format = identifyFileObjectFormat(data)
    grunt.log.error "Unrecognized file spec #{data}" unless format
    return sourceFileExtractors[format]?(format) or []

  # These *expand* the set of matched files, and therefore would cause watch to miss files that
  # the invoked task would cover. And then there's 'noglobstar', which doesn't fall into this
  # category but could cause a watch target to watch a large number of unintended files if
  # ignored.
  UnwatchableFileOptions = [
    'dot', 'matchBase', # gruntjs file options
    'nocase', # additional node-glob options
    'nobrace', 'noglobstar', 'noext', 'nocomment', 'nonegate', 'flipnegate' # additional minimatch options
  ]

  getCompactFormatSourceFiles = (data) ->
    illegalOptions = UnwatchableFileOptions.filter (option) -> data[option]
    if illegalOptions.length
      ser = (items) ->
        butLast = items.slice()
        last = butLast.pop()
        return last unless butLast.length
        # console.info [butLast.join(', '), last],(', and'.slice(butLast.length == 1))
        [butLast.join(', '), last].join(', and '.slice(butLast.length == 1))
      pl = (base, count) ->
        "#{base}#{'s'.slice(count == 1)}"
      grunt.log.error "Watch cannot proceess the #{ser illegalOptions} #{pl 'option', illegalOptions.length}"
      return []

    files = data.src
    files = [files] unless _.isArray(data.src)

    prependDirectory = (cwd) -> (pattern) ->
      [__, negation, file] = pattern.match(/(!?)(.*)/)
      [negation, if file.match(/^\//) then file else path.join(data.cwd, file)].join('')
    files = files.map(prependDirectory(data.cwd)) if data.cwd

    return files

  # Combines a number of file lists into a single file list.
  #
  # Negative patterns are only preserved if they're in every input list.
  # For example, a `['**/*', '!node_modules/**/*', '!**/*.coffee']` from one task's file list
  # and a `['**/*.coffee' '!node_modules/**/*']` from a second task's file list
  # will resolve into the (harmlessley redundant) `['**/*', '**/*.coffee', '!node_modules/**/*']`,
  # include `'!node_modules/**/*'` since it occurs in both lists,
  # but omitting `'!**/*.coffee'` from the first task's list since it is not present in the second.
  #
  # Negative patterns are matched across list only by string equality (after each file object's `cwd`
  # value, if any from has been prepended to any patterns from that file object).
  combineFileLists = (fileLists) ->
    isNegativePattern = (pathname) -> /^!/.test(pathname)
    negativePatternsPerFileList = (list.filter(isNegativePattern) for list in fileLists)
    negativePatternsInAllLists = _.chain(negativePatternsPerFileList)
      .flatten(true)
      .select((n) -> negativePatternsPerFileList.every (l) -> n in l)
      .uniq()
      .value()
    return _.chain(fileLists).flatten().reject(isNegativePattern).uniq().union(negativePatternsInAllLists).value()

  collectTargetFiles = (data) ->
    _.chain(data)
      .keys()
      .filter(isValidMultiTaskTarget)
      .map((target) -> data[target])
      .filter(isFileObject)

  # returns a list of lists of files
  getTaskFileLists = (task) ->
    [task, target] = task.split(':', 2)
    target = null if target == '*'
    data = grunt.config.get(_.compact([task, target]))
    return getFileObjectSourceFileLists(data) if isFileObject(data)
    return [] if target
    return _.chain(data)
      .keys()
      .filter(isValidMultiTaskTarget)
      .map((target) -> data[target])
      .filter(isFileObject)
      .map(getFileObjectSourceFileLists)
      .flatten(true)
      .value()

  getWatchTargetFileList = (watchTargetName, data) ->
    fileLists = _.flatten((getTaskFileLists(task) for task in data.tasks), true)
    grunt.log.warn "The tasks in watch.#{watchTargetName}.tasks do not specify any files" unless fileLists.length
    return combineFileLists(fileLists)

  addWatchTargetProperties = (watchTargetName, watchTargetData) ->
    watchTargetData.tasks ?= [watchTargetName]
    watchTargetData.files ?= getWatchTargetFileList(watchTargetName, watchTargetData)

  grunt.registerTask 'autowatch', description, ->
    options = _.extend {run: true}, grunt.config([this.name, 'options']) or {}
    watchTaskName = 'watch'

    # create new targets
    for task in (options.tasks or [])
      propertyPath = [watchTaskName, task]
      data = grunt.config.getRaw(propertyPath) or {}
      grunt.log.warn "#{propertyPath.join('.')} already has a \"tasks\" property" if data.tasks
      data.tasks ?= [task]
      grunt.config.set(propertyPath, data)

    # fill in target properties
    for watchTargetName in _.keys(grunt.config.getRaw(watchTaskName)).filter(isValidMultiTaskTarget)
      propertyPath = [watchTaskName, watchTargetName]
      watchTargetData = grunt.config.get(propertyPath)
      addWatchTargetProperties watchTargetName, watchTargetData
      grunt.config.set propertyPath, watchTargetData

    grunt.task.run 'watch' if options.run and this.errorCount == 0
    return this.errorCount == 0
