# Ruby on Rails Tutorial Sample Application

This is the sample application for [*Ruby on Rails Tutorial:
Learn Web Development with Rails*](https://www.railstutorial.org/)(6th Edition)

## Getting started

To get started with the app, clone the repo and then install the needed gems:

```
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everthing is working correctly:

```
$ rails test
```

If the test suite passes, you'll  be ready to run the app in a local server:

```
$ rails server
```
