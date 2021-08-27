# Set up

Run `rails webpacker:compile assets:clean` to build the Nginx image, then:
`docker-compose up --build`

Using **Preact**

## Self certificate

```sh
openssl genrsa 2048 > host.key
chmod 600 host.key
openssl req -new -x509 -nodes -sha256 -days 365 -key host.key -out host.cert
```

## Remote PostgreSQL database: ElephantSQL

No migration needed:

- create a PG instance:
  <https://api.elephantsql.com/console/19d1af1d-e34a-4a3c-9359-3637e53748b7/details?>

- create a table by running:

```sql
CREATE TABLE COUNTERS (id serial PRIMARY KEY, nb integer, created_at TIMESTAMP, updated_at TIMESTAMP);
```

- connect Rails to the db with the url:

`REMOTE_URL=postgres://ortkcbqt:fhSBQrF3Dzl9WWA1FfRIjQmU7u3pBtTd@batyr.db.elephantsql.com/ortkcbqt`

where the user and database name is "ortkcbqt" followed by the password.
