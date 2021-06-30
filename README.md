# Create Rails app without Sprockets

Create a Rails app running only Webpack, without using Sprockets: `rails new my-app --skip-sprockets`. It's much easier to start an app with this flag than change an app already using Sprockets.

## Initialize the PostgreSQL database

- modifiy **/config/database.yml** (or **.env**) to pass to the Postrgres adapter the desired user/password: `POSTGRES_URL=postgresql://bob:bobpwd@localhost:5432/k8_development`

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

Modify **/usr/local/etc/redis/redis.conf** with `requirespass secretpwd`.

Once the app is running (ie **redis-server** is up), we can check that Redis is protected by the password by connecting to the redis-cli:

```sh
redis-cli
127.0.0.1:6379> GET counter
(error) NOAUTH Authentication required
127.0.0.1:6379> AUTH secretpwd
OK
127.0.0.1:6379> GET counter
23
```

We can setup Redis with AOF and RDB.