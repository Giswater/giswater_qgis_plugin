/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3024

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setowner(p_data json)
  RETURNS json AS
$BODY$


/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_setowner($${"client":{"lang":"ES"}, 
"data":{"owner":"role_admin"}}$$);
*/



DECLARE

rec text;
v_owner text;
v_schema text;
v_version text;
v_error_context text;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	v_owner = ((p_data ->>'data')::json->>'owner')::text; 
	v_schema = 'SCHEMA_NAME';

	SELECT giswater INTO v_version FROM sys_version order by id desc limit 1;

	EXECUTE 'ALTER SCHEMA '|| v_schema ||' OWNER TO '|| v_owner ||';';

	FOR rec IN
		EXECUTE 'SELECT table_name FROM information_schema.TABLES WHERE table_schema = '|| quote_literal(v_schema)||' AND table_type = ''BASE TABLE'' ORDER BY table_name'
	LOOP

		EXECUTE 'ALTER TABLE '|| v_schema ||'.'|| rec ||' OWNER TO '|| v_owner ||';';
	END LOOP;

	FOR rec IN
		EXECUTE 'SELECT table_name, view_definition as definition  FROM information_schema.views WHERE table_schema = '|| quote_literal(v_schema)||''
	LOOP

		EXECUTE 'ALTER TABLE '|| v_schema ||'.'|| rec ||' OWNER TO '|| v_owner ||';';
	END LOOP;

FOR rec IN
		EXECUTE 'SELECT sequence_name FROM information_schema.SEQUENCES WHERE sequence_schema = '|| quote_literal(v_schema)||''
	LOOP

		EXECUTE 'ALTER SEQUENCE '|| v_schema ||'.'|| rec ||' OWNER TO '|| v_owner ||';';
	END LOOP;

FOR rec IN
	EXECUTE 'SELECT concat(routine_name,''('',string_agg(parameters.data_type,'', '' order by parameters.ordinal_position),'')'')
		FROM information_schema.routines
	   LEFT JOIN information_schema.parameters ON routines.specific_name=parameters.specific_name
		WHERE routines.specific_schema='|| quote_literal(v_schema)||' and routine_name not in (
		''gw_fct_cad_add_relative_point'') and routine_name not ilike ''%trg%''group by routines.specific_name,routine_name'
	LOOP
		IF rec ilike '%ARRAY%' THEN
			rec = replace(rec, 'ARRAY','text[]');
		ELSIF rec ilike '%USER-DEFINED%' THEN
			rec = replace(rec, 'USER-DEFINED','geometry');
		END IF;
		EXECUTE 'ALTER FUNCTION '|| v_schema ||'.'|| rec ||' OWNER TO '|| v_owner ||';';

	END LOOP;

	FOR rec IN
	EXECUTE 'SELECT concat(routine_name,''('',string_agg(parameters.data_type,'', ''),'')'') 
		FROM information_schema.routines
	   LEFT JOIN information_schema.parameters ON routines.specific_name=parameters.specific_name
		WHERE routines.specific_schema='|| quote_literal(v_schema)||' and routine_name  ilike ''%trg%'' group by routine_name'
	LOOP
		EXECUTE 'ALTER FUNCTION '|| v_schema ||'.'|| rec ||' OWNER TO '|| v_owner ||';';

	END LOOP;

	--  Return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Set owner done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":{}'||			
			'}}'||
	    '}')::json;

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;