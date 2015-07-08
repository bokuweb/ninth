gulp           = require 'gulp'
watchify       = require 'gulp-watchify'
plumber        = require 'gulp-plumber'
rename         = require 'gulp-rename'

watching = off

gulp.task 'enable-watch-mode', -> watching = on

gulp.task 'build:app', watchify (watchify)->
  gulp.src 'src/main.coffee'
    .pipe plumber()
    .pipe watchify
      watch     : watching
      extensions: ['.coffee', '.js']
      transform : ['coffeeify']
    .pipe rename
      extname: ".js"
    .pipe gulp.dest 'dist'

gulp.task 'build', ['build:app']

gulp.task 'watch:app', ['enable-watch-mode', 'build:app']

