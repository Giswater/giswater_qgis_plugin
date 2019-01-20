/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2464

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setvalurn()
  RETURNS integer AS
$BODY$

DECLARE 
query_text 	text;
sys_rows_aux 	text;
parameter_aux   text;
audit_rows_aux 	integer;
compare_sign_aux text;
enabled_bool 	boolean;
diference_aux 	integer;
error_aux integer;
count integer;
table_host_aux text;
table_dbname_aux text;
table_schema_aux text;
table_record record;
query_string text;
max_aux int8;
project_type_aux text;
rolec_rec record;
psector_vdef_aux text;

BEGIN 

	-- search path
	SET search_path = "SCHEMA_NAME", public;
	SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;
	
	--urn
	IF project_type_aux='WS' THEN
		SELECT GREATEST (
		(SELECT max(node_id::int8) FROM node WHERE node_id ~ '^\d+$'),
		(SELECT max(arc_id::int8) FROM arc WHERE arc_id ~ '^\d+$'),
		(SELECT max(connec_id::int8) FROM connec WHERE connec_id ~ '^\d+$'),
		(SELECT max(element_id::int8) FROM element WHERE element_id ~ '^\d+$'),
		(SELECT max(pol_id::int8) FROM polygon WHERE pol_id ~ '^\d+$')
		) INTO max_aux;
	ELSIF project_type_aux='UD' THEN
		SELECT GREATEST (
		(SELECT max(node_id::int8) FROM node WHERE node_id ~ '^\d+$'),
		(SELECT max(arc_id::int8) FROM arc WHERE arc_id ~ '^\d+$'),
		(SELECT max(connec_id::int8) FROM connec WHERE connec_id ~ '^\d+$'),
		(SELECT max(gully_id::int8) FROM gully WHERE gully_id ~ '^\d+$'),
		(SELECT max(element_id::int8) FROM element WHERE element_id ~ '^\d+$'),
		(SELECT max(pol_id::int8) FROM polygon WHERE pol_id ~ '^\d+$')
		) INTO max_aux;
	END IF;	
	
return max_aux;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;