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

var SRC = './app/';
var DEST = './build/';
var PUB = './public/';

// single task
gulp.task('clean', function(cb){
  return del([
    './build/**/*',
    './public/**/*'
  ], cb);
});

gulp.task('compile:js', function(){
  return gulp.src(SRC + '**/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest(DEST));
});

gulp.task('compile:css', function(){
  return gulp.src(SRC + '**/*.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest(DEST));
});

gulp.task('copy:tpl', function(){
  return gulp.src([SRC + '**/*.html', '!'+ SRC + 'static/**/*.html'])
    .pipe(changed(DEST))
    .pipe(gulp.dest(DEST));
});

gulp.task('copy:static', function(){
  return gulp.src(SRC + 'static/**/*')
    .pipe(changed(PUB))
    .pipe(gulp.dest(PUB));
});

gulp.task('watch:compile', function(){
  gulp.watch([SRC + '**/*.coffee', SRC + '**/*.scss'], ['compile'])
    .on('change', function(event){
      console.log('File ' + event.path + ' was ' + event.type + ', running tasks => compile');
    })
});

gulp.task('watch:static', function(){
  gulp.watch([SRC + '**/*.html'], ['copy'])
    .on('change', function(event){
      console.log('Static file ' + event.path + ' was ' + event.type + ', running tasks => copy:static');
    });
});

gulp.task('watch:bundle', function(){
   gulp.watch([
     DEST + '**/*.css',
     DEST + '**/*.js',
     DEST + '**/*.html'
   ], ['webpack']);
});

gulp.task('serve', function(){
  browserSync({
    server: {
      baseDir: PUB
    }
  });
  gulp.watch([PUB + '*.html', PUB + 'bundle.js'], reload)
  .on('change', function(event){
    console.log('Build file ' + event.path + ' was ' + event.type + ', running tasks => reload');
  });
});

gulp.task('webpack', ['compile', 'copy'], function(){
  return gulp.src(DEST + 'main.js')
    .pipe(webpack(require('./webpack.config.js')))
    .pipe(gulp.dest(PUB));
});

// combination tasks
// TODO:development or production env
// TODO:watch tasks still need optimization
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
