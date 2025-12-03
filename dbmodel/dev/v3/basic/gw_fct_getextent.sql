/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getextent(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*example
SELECT SCHEMA_NAME.gw_fct_getextent($${}$$);
*/

DECLARE


--	Variables
	v_version json;
	v_geometry text;
	v_geometry_aux text;
	v_return json;
	v_filterfrominput text;
	v_tiled_filter text;

BEGIN


-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
		INTO v_version;

-- get v_tiled_filter (in this case, tiled_filter is expl_id from config_user_x_expl where current_user)
-- this could be uncommented if you need to send the expl_id into v_tiled_filter to use a different tiles according to expl
	/*IF (SELECT expl_id FROM config_user_x_expl WHERE username = current_user limit 1) IS NOT NULL THEN
		SELECT expl_id INTO v_tiled_filter FROM config_user_x_expl WHERE username = current_user limit 1;
	ELSE*/
    -- if v_tiled_filter is sent as null, default tiles will be used
		v_tiled_filter = 'null';
	--END IF;

-- getting from expl_x_user variable to setup v_filterfrominput

	v_filterfrominput = ' WHERE expl_id IN (SELECT expl_id FROM config_user_x_expl WHERE username = current_user)';


-- get envelope
	EXECUTE 'SELECT row_to_json (a) 
	FROM (SELECT st_xmin(the_geom)::numeric(12,2) as x1, st_ymin(the_geom)::numeric(12,2) as y1, st_xmax(the_geom)::numeric(12,2) as x2, st_ymax(the_geom)::numeric(12,2) as y2 
	FROM (SELECT st_collect(the_geom) as the_geom FROM ve_arc '||v_filterfrominput||') b) a' INTO v_geometry;

	IF v_geometry::json->>'x1' IS NOT NULL THEN
		v_geometry_aux = concat('[',v_geometry::json->>'x1',', ', v_geometry::json->>'y1',', ',v_geometry::json->>'x2',', ',v_geometry::json->>'y2',']');
	ELSE
		v_geometry_aux = 'null';
	END IF;


-- Return
	RETURN ('{"status":"Accepted"' ||
	', "version":'|| v_version ||
	', "client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"tiled_filter":'||v_tiled_filter||', "geometry":'||v_geometry_aux||'}}')::json;


-- Exception handling
--	EXCEPTION WHEN OTHERS THEN
		--RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "version":"'|| v_version || '","SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$function$
;

-- Permissions
GRANT ALL ON FUNCTION SCHEMA_NAME.gw_fct_getextent(json) TO public;
GRANT ALL ON FUNCTION SCHEMA_NAME.gw_fct_getextent(json) TO role_basic;
