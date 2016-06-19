var
browserify = require('gulp-browserify'),
coffee = require('gulp-coffee'),
del = require('del'),
exec = require('child_process').exec;
gulp = require('gulp'),
jade = require('gulp-jade'),
sourcemaps = require('gulp-sourcemaps'),
uglify = require('gulp-uglify');

var paths = {
  coffee: ['src/coffee/**/*.coffee'],
  jade: ['src/jade/*.jade'],
  output: 'bin'
};

// BUILD TASKS
// ===========

// Coffeescript
// ------------
function build_coffee() {
    return gulp.src(paths.coffee)
      .pipe(coffee())
      .pipe(gulp.dest(paths.output + '/.tmp'));
}

function build_browserify() {
    return gulp.src([paths.output + '/.tmp/**/*.js', '!' + paths.output + '/.tmp/classifier'])
        .pipe(sourcemaps.init())
        .pipe(browserify({
        //   ignoreMissing: true
        }))
        // .pipe(uglify())
        .pipe(sourcemaps.write('./'))
        .pipe(gulp.dest(paths.output));
}

gulp.task('build-browserify', ['build-coffee'], function(cb) {
    return build_browserify();
});

gulp.task('build-browserify-nt', ['build-coffee-nt'], function(cb) {
    return build_browserify();
});

gulp.task('build-coffee', ['make-classifier'], function(cb) {
    return build_coffee();
});

gulp.task('build-coffee-nt', function() {
    return build_coffee();
});

// Jade
// ----
gulp.task('build-jade', function() {
  return gulp.src(paths.jade)
    .pipe(jade())
    .pipe(gulp.dest(paths.output));
});

// OTHER BUILD-RELATED TASKS
// =========================
gulp.task('copy-manifest', function() {
    return gulp.src('./manifest.json')
        .pipe(gulp.dest('./bin'));
});

gulp.task('clean', function() {
  return del.sync([paths.output]);
});

// CLASSIFIER TASKS
// ================
gulp.task('build-trainer', function(cb) {
    return gulp.src('src/coffee/classifier/*.coffee')
      .pipe(coffee({
          compile: true
      }))
      .pipe(gulp.dest('./src/coffee/classifier/'));
      cb();
});

gulp.task('train-model', ['build-trainer'], function(cb) {
    exec('node src/coffee/classifier/train.js', function(err, stdout, stderr) {
        console.log(stdout);
        console.log(stderr);
        cb(err);
    });
});

gulp.task('make-classifier', ['train-model'], function() {
    return del.sync(['src/coffee/classifier/*.js'])
});

// USER-CENTRIC TASKS
// ==================
gulp.task('build', ['build-browserify-nt', 'build-jade', 'copy-manifest']);
gulp.task('build-no-train', ['build-browserify-nt', 'build-jade', 'copy-manifest']);
gulp.task('default', ['clean', 'build']);
