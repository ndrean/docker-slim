# Branches

- Deployed on Heroku: <https://pg-redis-cable-sdq.herokuapp.com>, but without Sidekiq (2 free dynos only).

- master <=> run with `overmind start -f Procfile.overmind`

- dock-dev <=> run `docker-compose up --build`

- docker-prod <=> build images and run `docker-compose up --build`

- Kubernets/Minikube <=> start Minikube and run Tilt

## Initialize the PostgreSQL database

- modifiy **/config/database.yml** (or **.env**) to pass to the Postgres adapter the desired user/password: `POSTGRES_URL=postgresql://bob:bobpwd@localhost:5432/k8_development`

- run in a terminal:

```sh
RAILS_ENV=development rails rails db:drop rails:prepare
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

Same database name for `primary` and `replica`:

Initialize ElephantSQL database:

```sql
CREATE TABLE counters (
  id bigserial PRIMARY KEY,
  nb integer,
  created_at timestamp,
  updated_at timestamp
);
```

## Run `overmind`

The app is running locally with hot static assets replacement and Rails running in dev mode (page refresh will update the app). Run `overmind start` to start the four processes _rails_, _webpack-dev-server_, _redis_ and _sidekiq_:

The following runs on OSX (use "redis-server /usr/local/etc/redis.conf" on OSX, and "/usr/local/etc/redis/redis.conf" on Linux ):

```txt
assets:  ./bin/webpack-dev-server
web:     bundle exec rails server
redis-server:   redis-server /usr/local/etc/redis.conf
worker:  bundle exec sidekiq -C config/sidekiq.yml
cable: bundle exec puma -p 28080 cable/config.ru
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

## Gem **sidekiq_alive**

<https://github.com/arturictus/sidekiq_alive_example>

<https://github.com/mhfs/sidekiq-failures>

<https://github.com/mperham/sidekiq/wiki>

## Example Rackup

Declared a controller "Example_Controller" inheriting from ApplicationController::Base
Then "config.ex.ru" and launched with:
"bundle exec puma -b tcp://0.0.0.0:3001 config.ex.ru"

=> this is used for cable with `/cable/config.ru` to run a standalone Cable.

## Nginx

```sh
 cp nginx/k8nginx.conf /usr/local/etc/nginx/servers/
 nginx -s stop && nginx
```

The config will pass the web sockets.
