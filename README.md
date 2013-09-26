# grunt-autowatch

This plugin supplies default `task` and `files` to [watch](https://github.com/gruntjs/grunt-contrib-watch) targets that don't have them.
If a watch target has no `task` property, it is given a task that matches its name.
If a watch target has no `files` property, it is given the files from the configurations for those of its tasks that are plugins.

Together, these defaults allow one to write _e.g._

```js
grunt.initConfig({
  watch: {
    coffee: {}
    jade: {}
  }
})
```

to do the equivalent of

```js
grunt.initConfig({
  watch: {
    coffee: {tasks: ['coffee'], files: 'app/**/*.coffee'}
    jade: {tasks: ['jade'], files: 'app/**/*.jade'}
  }
})
```

where the actual values of the `files` property are copied from the configurations of their respective plugins,
with `cwd` properties applied to the paths,
and with the [various grunt formats for specifying files](http://gruntjs.com/configuring-tasks#files)
normalized into a single list of file pattern strings so that `watch` can understand them.

## Getting Started
This plugin requires Grunt `~0.4.1`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-autowatch --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-autowatch');
```

## The "autowatch" task
No configuration for autowatch itself is necessary.

Run this task with the `grunt autowatch` command.
With the default options, this modifies the watch configuration, and then runs `watch`.

### Options

#### options.run
Type: `Boolean`
Default value: `true`

If `true`, `grunt autowatch` runs the `watch` task after modifying the `watch` configuration.

#### options.tasks
Type: `Array`
Default value: `[]`

This is a list of `plugin` or `plugin:target` strings.
`grunt autowatch` inserts watcher configurations for these tasks into the `watch` configuration.

### Usage Examples

The following example contains stubs for `coffee` and `jade` watchers inside the `watch` configuration.
`grunt autowatch` task sets the `watch.coffee.task` and `watch.jade.task` to `['coffee']` and `['jade']` respecively
(based on name of the watcher),
and sets `watch.coffee.files` and `watch.jade.files` to a list of file patterns based on the coffee and jade configurations.

```js
grunt.initConfig({
  coffee: { ... },
  jade: { ... },
  watch: {
    coffee: {},
    jade: {}
  }
})
```

The following example defines a watcher with a configured list of tasks, but omit the `files` properties.
`grunt autowatch` sets `watch.grunt.files` to a list of file patterns based on the `gruntfile` target of the `coffeelint` plugin configuration.

```js
grunt.initConfig({
  coffeelint: {gruntfile: {...}},
  watch: {
    grunt: {tasks: ['coffeelint:gruntfile']}
  }
})
```

The following configuration omits watchers for `coffee` and `jade` entirely.
`grunt autowatch` inserts watchers for these tasks into the `watch` configuration.

```js
grunt.initConfig({
  coffee: { ... },
  jade: { ... },
  autowatch: {
    options:
      tasks: ['coffee', 'jade']
  },
})
```

The following autowatch configuration configures autowatch to *only* modify the `watch` *configuration* -- and *not* to run the `watch` *task* when it is done.
With this option, `grunt autowatch watch` is necessary in order to run the watchers.

```js
grunt.initConfig({
  autowatch: {
    options:
      run: false
  },
})
```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

## Release History

* September 24, 20012 -- initial release
