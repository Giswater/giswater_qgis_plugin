CREATE EXTENSION postgres_fdw;
CREATE SERVER logserver FOREIGN DATA WRAPPER postgres_fdw  OPTIONS (host 'hostname', dbname 'log', port '5432');
CREATE USER MAPPING FOR localUser SERVER serverName OPTIONS (user 'foreingUser', password 'foreingUserPassword');
CREATE FOREIGN TABLE ws.audit (
	id serial,
	fid smallint,
	log_message text,
	tstamp timestamp without time zone,
  cur_user text )
SERVER logserver  OPTIONS (schema_name 'utils', table_name 'audit');
	