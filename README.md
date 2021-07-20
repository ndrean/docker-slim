# 3 branches

- master <=> run with `overmind start`

- dock-dev <=> run `docker-compose up --build`

- docker-prod <=> run `docker-compose up --build`

## Create Rails app without Sprockets

Create a Rails app running "Webpack only", without using Sprockets:

```sh
> rails new my-app --skip-sprockets
```

It's much easier to start an app with this flag than change an app already using Sprockets.

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
```

## Note on Rails errors

<https://github.com/rails/rails/search?utf8=%E2%9C%93&q=standarderror&type=Code>

<https://github.com/rails/rails/issues/41492>

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

## Nginx

```sh
 cp nginx/k8nginx.conf /usr/local/etc/nginx/servers/
 nginx -s stop && nginx
```

## Nginx & Rails in same pod

Use `localhost` in nginx.conf as Nginx & Rails simply communicate

## Postgres

```sh
pg_ctl -D /usr/local/var/postgres start
pg_ctl -D /usr/local/var/postgres stop
```

## AWS - EC2

Create a key/value in the console, then:

````sh
mv ~/Downloads/aws-ec2.pem ~/.ssh/
chmod 400 ~/.ssh/aws-ec2.pem
ssh -i "~/.ssh/aws-ec2.pem" ubuntu@ec2-15-236-179-33.eu-west-3.compute.amazonaws.com

## Ansible - Create EC2

- need AWS credentials,
- Boto, Boto3 is a Python package which provides an interface to AWS (`pip install boto boto3`)

Then run the playbook locally on our localhost:

`ansible-playbook -v ./create-aws-ec2-ansible/launch.yml -vv`

<https://github.com/ansible-community/molecule/issues/1229>
<https://github.com/boto/boto/issues/3783>

```sh
sudo -H pip install virtualenv
virtualenv molecule
source molecule/bin/activate
pip install ansible molecule boto boto3
export BOTO_USE_ENDPOINT_HEURISTICS=True
pip install --update boto boto3
````

and exit vitualenv with `exit``

<https://stackoverflow.com/questions/36447118/ansible-amazon-ec2-the-key-pair-does-not-exist>

The key parameter for the ec2 module is looking for the key pair name that has been already uploaded to AWS, not a local key.

If you want to get Ansible to upload a public key you can use the ec2_key module.

```yml
tasks:
  - name: Provision instance
    ec2:
      aws_access_key: "{{ aws_access_key_id }}"
      aws_secret_key: "{{ aws_secret_access_key }}"
      key_name: "aws-ec2"
      # <- existing on AWS, not "~/.ssh/aws-ec2.pem"
      instance_type: t2.micro
      image: ami-0f7cd40eac2214b37
```

`ansible-galaxy install geerlingguy.docker `
