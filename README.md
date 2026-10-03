# Rotten Potatoes

A minimal Rails movie catalog with an alphabetical collection, movie details, shared add/edit forms, validation, and deletion.

## reqs

- Ruby 4.0.6
- Rails 8.1.4 (pinned in the Gemfile)
- SQLite for development/test; PostgreSQL for production

## run locally

If you use rbenv, initialize it in your shell (`eval "$(rbenv init - zsh)"`). The `.ruby-version` file selects the correct Ruby from this directory.

```sh
bundle config set --local without production
bundle install
bin/rails db:prepare
bin/rails server
```

open http://localhost:3000. The homepage redirects to `/movies`. Seeds don't include the four films from the assignment but rather 3 of my choosing.

## verification

```sh
RAILS_ENV=test bin/rails db:prepare
RAILS_ENV=test bin/rails runner script/verify.rb
bin/rails zeitwerk:check
bin/rubocop
bundle exec brakeman --no-pager
```

the verification script exercises all CRUD actions, invalid submissions, seed idempotence, missing records, empty collections, and `/up`. It uses a transaction in the test database and rolls back its changes.

## deploy to Render

the Git repository root is this `rottenpotatoes` directory. Push it to a private GitHub repository, then follow `../docs/part-4--deploy-to-the-cloud--including-the-production-database.md`.

create a PostgreSQL database and a Ruby web service in the same region. Use:

- Build: `bash bin/render-build.sh`
- Start: `bundle exec puma -C config/puma.rb -b tcp://0.0.0.0:$PORT`
- Health check: `/up`
- Environment: `RAILS_ENV=production`, `BUNDLE_WITHOUT=development:test`, `WEB_CONCURRENCY=1`
- `DATABASE_URL`: Render's internal PostgreSQL connection URL
- `RAILS_MASTER_KEY`: the value in your local `config/master.key` (never commit it)
- `SEED_DATABASE=true` for the first deployment, then change it to `false`

The build applies migrations without resetting the database. Production uses PostgreSQL through `DATABASE_URL`. Verify all four movie actions on Render and put the public app URL in `../rottenpotatoes-url.txt`.

## submission

Application: https://cs457-project3-rottenpotatoes-6cmg.onrender.com

Private source repository: https://github.com/HaidanP/cs457-project3-rottenpotatoes

Render uses the `main` branch, Ruby 4.0.6, Rails 8.1.4, and a separate PostgreSQL database. The free database expires October 31, 2026; it must remain available until grading is complete.

The submission archive excludes credentials, local databases, dependencies, logs, caches, and Git internals. Keep the local master key separately for Render. The public application URL is recorded in `../rottenpotatoes-url.txt`.
