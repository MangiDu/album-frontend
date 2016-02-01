'use strict';

var gulp = require('gulp');
var gulpSequence = require('gulp-sequence');
var del = require('del');
var coffee = require('gulp-coffee');
var gutil = require('gulp-util');
var sass = require('gulp-sass');
var changed = require('gulp-changed');
var webpack = require('webpack-stream');
var browserSync = require('browser-sync');
var reload = browserSync.reload;

var SRC = './app/'
var DEST = './build/';

// single task
gulp.task('clean', function(cb){
  return del([
    './build/**/*'
  ], cb);
});

gulp.task('compile:js', function(){
  return gulp.src(SRC + 'script/**/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest(DEST + 'script'));
});

gulp.task('compile:css', function(){
  return gulp.src(SRC + 'style/**/*.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest(DEST + 'style'));
});

gulp.task('copy:tpl', function(){
  var destPath = DEST + 'template'
  return gulp.src(SRC + 'template/**/*.html')
    .pipe(changed(destPath))
    .pipe(gulp.dest(destPath));
});

gulp.task('copy:static', function(){
  return gulp.src(SRC + 'static/**/*')
    .pipe(changed(DEST))
    .pipe(gulp.dest(DEST));
});

gulp.task('watch:compile', function(){
  gulp.watch([SRC + 'script/**/*.coffee', SRC + 'style/**/*.scss'], ['compile'])
    .on('change', function(event){
      console.log('File ' + event.path + ' was ' + event.type + ', running tasks => compile');
    })
});

gulp.task('watch:static', function(){
  gulp.watch([SRC + 'template/**/*.html', SRC + 'static/**/*'], ['copy'])
    .on('change', function(event){
      console.log('Static file ' + event.path + ' was ' + event.type + ', running tasks => copy:static');
    });
});

gulp.task('watch:bundle', function(){
   gulp.watch([
     DEST + 'style/**/*.css',
     DEST + 'script/**/*.js',
     DEST + 'template/**/*.html'
   ], ['webpack']);
});

gulp.task('serve', function(){
  browserSync({
    server: {
      baseDir: './build'
    }
  });
  gulp.watch([DEST + '*.html', DEST + 'bundle.js'], reload)
  .on('change', function(event){
    console.log('Build file ' + event.path + ' was ' + event.type + ', running tasks => reload');
  });
});

gulp.task('webpack', ['compile', 'copy'], function(){
  return gulp.src(DEST + 'script/main.js')
    .pipe(webpack(require('./webpack.config.js')))
    .pipe(gulp.dest(DEST));
});

// combination tasks
// TODO:development or production env
gulp.task('compile', [
  'compile:js',
  'compile:css'
]);

gulp.task('copy', [
  'copy:tpl',
  'copy:static'
]);

gulp.task('watch', [
  'watch:compile',
  'watch:static',
  'watch:bundle'
]);

gulp.task('build', gulpSequence(
  'clean',
  ['compile', 'copy'],
  'webpack'
));

gulp.task('dev', gulpSequence(
  'build',
  'watch',
  'serve')
);

gulp.task('default', ['dev']);
