Scotty on Heroku
====

<http://scotty-on-heroku.herokuapp.com/>

A simple example of Scotty application on Heroku.
You can see the running application on the URL above.

Installation
----

(Heroku registration and setup are omitted.)

Clone this repository:

```bash
$ git clone git@github.com:daimatz/scotty-on-heroku.git
$ cd scotty-on-heroku
```

Create a new Heroku application:

```bash
$ heroku create --stack=cedar --buildpack https://github.com/pufuwozu/heroku-buildpack-haskell.git
```

Add PostgreSQL addon:

```bash
$ heroku addons:add heroku-postgresql:dev
```

Find out which color of db is created:

```bash
$ heroku config
=== app Config Vars
BUILDPACK_URL:                https://github.com/pufuwozu/heroku-buildpack-haskell.git
HEROKU_POSTGRESQL_ORANGE_URL: postgres://uuuuu:xxxxx@yyyyy.amazonaws.com/zzzzz
```

Set the db to primary:

```bash
$ heroku pg:promote HEROKU_POSTGRESQL_ORANGE_URL
```

Make sure that `DATABASE_URL` is set:

```bash
$ heroku config
=== app Config Vars
BUILDPACK_URL:                https://github.com/pufuwozu/heroku-buildpack-haskell.git
DATABASE_URL:                 postgres://uuuuu:xxxxx@yyyyy.amazonaws.com/zzzzz
HEROKU_POSTGRESQL_ORANGE_URL: postgres://uuuuu:xxxxx@yyyyy.amazonaws.com/zzzzz
```

Push to Heroku:

```bash
$ git push heroku master
```

Wait for 5 or 6 minutes and then access to the application:

```bash
$ heroku open
```

Running on Other Environment
----

Of cource you can run this application on localhost.
But you have to set `PORT` and `DATABASE_URL` manually.

```bash
$ cabal-dev update
$ cabal-dev install --only-dependencies
$ cabal-dev configure
$ cabal-dev build
$ PORT=3000 DATABASE_URL=postgres://uuuuu:xxxxx@yyyyy.amazonaws.com/zzzzz \
      dist/build/scotty-on-heroku/scotty-on-heroku
```

### Using SQLite

You can use SQLite database instead of PostgreSQL for local development
(and in this case you don't have to set `DATABASE_URL`).
Uncomment `#define SQLite` in `src/DBUtil.hs`:

```haskell
-- Uncomment this line:
#define SQLite
```

If you didn't install PostgreSQL to your machine,
you also have to comment out `persistent-postgresql` dependency in
`scotty-on-heroku.cabal`.

```haskell
                     , persistent                  <  1.1
--                     , persistent-postgresql
                     , persistent-sqlite
```
