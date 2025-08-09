# README

This API is a Rails 8 (api-only) app using PostgreSQL and JWT auth.

## Prerequisites
- Ruby (see .ruby-version or Gemfile)
- Bundler
- Docker (to run Postgres locally) or a local PostgreSQL server

## Quick start (local Postgres via Docker)
Run a disposable Postgres container on port 5432 with password "test":

```bash
docker run --rm -it \
  -p 5432:5432 \
  --name test_postgres \
  -e POSTGRES_PASSWORD=test \
  postgres:latest
```

In another terminal, install gems and set up the DB:

```bash
bundle install
bundle exec rails db:create db:migrate
```

Export a JWT secret for auth (example):

```bash
export JWT_SECRET=change_me_dev_secret
```

Start the server:

```bash
bundle exec rails s
```

## Configuration
- Database: configured for localhost:5432 user `postgres` password `test` in `config/database.yml` for development and test.
- JWT secret: read from `ENV["JWT_SECRET"]`.

## API quick reference
See `README_API.md` for endpoints and payloads.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
