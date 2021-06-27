# Create Rails app without Sprockets

Create a Rails app running only Webpack, without using Sprockets: `rails new my-app --skip-sprockets`. It's much easier to start an app with this flag than change an app already using Sprockets.

## Initialize the PostgreSQL database

- modifiy **/config/database.yml** (or **.env**) to pass to the Postgres adapter the desired user/password: `POSTGRES_URL=postgresql://bob:bobpwd@localhost:5432/k8_development`

- run in a terminal:

```sh
RAILS_ENV=development rails rails db:drop rails:create rails:migrate
```

- connect to PostgreSQL to create ROLE 'bob' with password "bobpwd"

```sql
psql -U postgres
# get list of databases
\l
# connect to the desired database
\c k8_development
CREATE ROLE bob WITH SUPERUSER CREATEDB LOGIN PASSWORD 'bobpwd';
```

## Run `overmind`

The app is running locally with hot static assets replacement and Rails running in dev mode (page refresh will update the app). Run `overmind start` to start the four processes _rails_, _webpack-dev-server_, _redis_ and _sidekiq_:

The following runs on OSX (use "redis-server /usr/local/etc/redis.conf" on OSX, and "/usr/local/etc/redis/redis.conf" on Linux ):

```
assets:  ./bin/webpack-dev-server
web:     bundle exec rails server
redis-server:   redis-server /usr/local/etc/redis.conf
worker:  bundle exec sidekiq -C config/sidekiq.yml
```

## The Redis database

We initialize a Redis database with:

```yml
#/config/redis.yml
development: &dev
  url: redis://user:secretpwd@redisdb:6379
```

```rb
#/config/initializers/redis.rb
$redis = Redis.new(Rails.application.config_for(:redis))
```

```sh
# .env
REDIS_URL = redis://user:secretpwd@redisdb:6379
```

and use it for the background processor Sidekiq with:

```rb
# sidekiq.rb
redis_conf = {
  url: ENV['REDIS_URL'],
  network_timeout: 5
}
Sidekiq.configure_server { |cfg| cfg.redis = redis_conf }
Sidekiq.configure_client{ |cfg| cfg.redis = redis.conf }
```

and use the Redis database in the Rails app by calling `$redis.get("key")`.

We define a service **redisdb**. We secure the database with a password, `requirepass secretpwd` definded in **/usr/local/etc/redis/redis.conf** for Linux (or **/usr/local/etc/redis.conf** for OSX). We then pass it with an environment variable that contains the password and an anonymous user: `REDIS_URL=redis://user:secretpwd@redisdb:6379` to:

- to the background processor Sidekiq

- to the Rails app

To connect to the containerized Redis database, and check that the database is protected with the defined password, run:

```sh
docker-compose run --rm redisdb redis-cli -h redisdb -p 6379
127.0.0.1:6379> GET counter
(error) NOAUTH Authentication required
127.0.0.1:6379> AUTH secretpwd
OK
127.0.0.1:6379> GET counter
23
```

We can also setup Redis persistance with AOF and RDB.

## Docker

- running \*_webpack-dev-server_

- code is cached with a bind mount `.:/app:cached`

Example: change a text in "views/pages/home.html.erb", refresh, and insert or remove an image in "views/layouts/application.html.erb" and refresh.
Size is 715 Mb.

## Sidekiq

We define a worker and an ActiveJob. Both will use Sidekiq. The actions will be a remote FETCH action.
