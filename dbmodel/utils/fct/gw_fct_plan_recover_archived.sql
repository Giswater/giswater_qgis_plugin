/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- DROP FUNCTION SCHEMA_NAME.gw_fct_plan_recover_archived(json);


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_plan_recover_archived(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/* EXAMPLE 

id = 3512

SELECT gw_fct_plan_recover_archived($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"parameters":{"psectorId":"1"}}}$$);


*/


DECLARE

-- input params
v_psector_id integer;
v_project_type TEXT;
v_version TEXT;

-- code
rec_feature text;

-- return
v_message JSON;

BEGIN 
	
	-- input params
	v_psector_id := (p_data->'data'->'parameters'->>'psectorId')::integer;

	SELECT giswater, UPPER(project_type) INTO v_version, v_project_type FROM sys_version LIMIT 1;
	SELECT json_build_object('level', 1, 'text', error_message) INTO v_message FROM sys_message WHERE id = 3700;


	-- recover data
	FOR rec_feature IN SELECT lower(id) FROM sys_feature_type WHERE classlevel < 3 -- arc/node/connec/gully
	LOOP
	
		EXECUTE '
		INSERT INTO plan_psector_x_'||rec_feature||' ('||rec_feature||'_id, psector_id, state, doable, descript, addparam)
		SELECT '||rec_feature||'_id::INT, psector_id, state, doable, descript, 
		to_jsonb(t) - ''id'' - ''psector_id'' - ''state'' - ''doable'' - ''descript''
		FROM archived_psector_'||rec_feature||' t
		WHERE psector_id = '||v_psector_id||'
		';
	
		EXECUTE '
		DELETE FROM archived_psector_'||rec_feature||' WHERE psector_id = '||v_psector_id||'
		';
	
	END LOOP;

	-- set status and inactive
	UPDATE plan_psector SET status = 2, active = false WHERE psector_id = v_psector_id;



RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":'||v_message||', "version":"'||v_version||'"'||
		 ',"body":{"form":{}'||
		 ',"data":{ "info":{}}}'||
	'}')::json, 3512, null, null, null);

	

END;
$function$
;
