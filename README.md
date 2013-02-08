Scotty on Heroku
====

<http://scotty-on-heroku.herokuapp.com/>.

Example of launching scotty application on Heroku.
You can see running application on the URL above.

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

Set the database to primary db:

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

Of cource you can run the application on localhost.
But you have to set `PORT` and `DATABASE_URL` correctory.

```bash
$ cabal-dev update
$ cabal-dev install --only-dependencies
$ cabal-dev configure
$ cabal-dev build
$ PORT=3000 DATABASE_URL=postgres://uuuuu:xxxxx@yyyyy.amazonaws.com/zzzzz \
      dist/build/scotty-on-heroku/scotty-on-heroku
```

### Use SQLite

You can use SQLite database instead of PostgreSQL for local development.
Uncomment `#define SQLite` in `src/DBUtil.hs`:

```haskell
-- Uncomment this line:
#define SQLite
```

If you didn't install PostgreSQL to the machine,
you also have to comment out `persistent-postgresql` dependencies in
`scotty-on-heroku.cabal`.
