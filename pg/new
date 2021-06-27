DO $$
BEGIN
  CREATE ROLE bob WITH SUPERUSER CREATEDB LOGIN PASSWORD 'bobpwd';

  
  EXCEPTION WHEN DUPLICATE_OBJECT THEN
  RAISE NOTICE 'not creating role my_role -- it already exists';
END
$$;