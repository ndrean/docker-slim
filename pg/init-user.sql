DO $$
BEGIN
  CREATE ROLE postgres WITH SUPERUSER CREATEDB LOGIN PASSWORD 'dockerpassword';
  EXCEPTION WHEN DUPLICATE_OBJECT THEN
  RAISE NOTICE 'not creating role my_role -- it already exists';

END
$$;