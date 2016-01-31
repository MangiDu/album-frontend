'use strict'

var gulp = require('gulp');
var gulpSequence = require('gulp-sequence');
var del = require('del');
var babel = require('gulp-babel');
var sass = require('gulp-sass');
var changed = require('gulp-changed');
var browserSync = require('browser-sync');
var reload = browserSync.reload;

var SRC = './app/'
var DEST = './build/';

// single tasks
gulp.task('clean', function(cb){
  return del([
    './build/**/*'
  ], cb);
});

gulp.task('compile:js', function(){
  gulp.src(SRC + 'script/**/*.js')
    .pipe(babel({
      presets: ['es2015']
    }))
    .pipe(gulp.dest(DEST + 'js'));
});

gulp.task('compile:css', function(){
  gulp.src(SRC + 'style/**/*.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest(DEST + 'css'));
});

gulp.task('copy:tpl', function(){
  var destPath = DEST + 'tpl'
  gulp.src(SRC + 'template/**/*.html')
    .pipe(changed(destPath))
    .pipe(gulp.dest(destPath));
});

gulp.task('copy:static', function(){
  gulp.src(SRC + 'static/**/*')
    .pipe(changed(DEST))
    .pipe(gulp.dest(DEST));
});

gulp.task('watch:compile', function(){
  gulp.watch([SRC + 'script/**/*.js', SRC + 'style/**/*.scss'], ['compile'])
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

gulp.task('serve', function(){
  browserSync({
    server: {
      baseDir: './build'
    }
  });
  gulp.watch(['*.html', 'css/**/*.css', 'js/**/*.js', 'tpl/**/*.html'], {cwd: 'app'}, reload);
});

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
  'watch:static'
]);

gulp.task('build', gulpSequence(
  'clean',
  ['compile', 'copy']
));

gulp.task('dev', gulpSequence(
  'build',
  'watch',
  'serve')
);

gulp.task('default', ['dev']);
