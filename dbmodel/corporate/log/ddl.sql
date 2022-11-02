/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

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
	