# grunt-autowatch

This plugin supplies default `task` and `files` to [watch](https://github.com/gruntjs/grunt-contrib-watch) targets that don't have them.
If a watch target has no `task` property, it is given a task that matches its name.
If a watch target has no `files` property, it is given the files from its tasks.

Together, these defaults allow one to write _e.g._

```js
grunt.initConfig({
  watch: {
    coffee: {}
    jade: {}
  }
})
```

to create watchers that watch the sources to the `coffee` and `jade` tasks, and respectively invoke
those tasks when their corresponding sources are changed.

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

### Usage Examples

Fill the `task` and `files` properties:

```js
grunt.initConfig({
  coffee: { ... }
  jade: { ... }
  watch: {
    coffee: {}
    jade: {}
  }
})
```

Fill in the `files` property based on the `coffeelint:gruntfile` configuration:

```js
grunt.initConfig({
  coffeelint: {gruntfile: {...}},
  watch: {
    grunt: {tasks: ['coffeelint:gruntfile']}
  }
})
```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

## Release History

* September 24, 20012 -- initial release
