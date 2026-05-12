/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- DROP FUNCTION PARENT_SCHEMA.gw_fct_cm_check_arc_duplicated(json);

CREATE OR REPLACE FUNCTION cm.gw_fct_cm_check_arc_duplicated(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*EXAMPLE


SELECT gw_fct_cm_check_arc_duplicated($${"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{"parameters":{"nodeId":1}}}$$);

*/

DECLARE

-- Init params
v_version text;
v_srid integer;

v_lot_id integer;
v_campaign_id integer;

-- Vars

v_sql_result TEXT;
v_count int = 0;
v_lot_id_array integer[];



-- Return
v_result json;
v_result_info json;
v_result_line json;



BEGIN

    SET search_path = "PARENT_SCHEMA","cm", public;

	-- Init params
	SELECT giswater, epsg INTO v_version, v_srid FROM sys_version ORDER BY id DESC LIMIT 1;
   
	v_campaign_id := (p_data ->'data' ->'parameters'->>'campaignId')::integer;
   	v_lot_id := (p_data ->'data' ->'parameters'->>'lotId')::integer;

	IF v_lot_id IS NULL THEN
		SELECT array_agg(lot_id) INTO v_lot_id_array FROM cm.om_campaign_lot WHERE status IN (3,4,6) AND campaign_id = v_campaign_id GROUP BY campaign_id;
	ELSE
		v_lot_id_array := array[v_lot_id];
	END IF;

	CREATE TEMP TABLE IF NOT EXISTS t_audit_check_data (LIKE audit_check_data INCLUDING ALL);


	-- Query for orphan nodes
   	v_sql_result := format(
    'WITH mec AS (
		SELECT arc_id, arccat_id, the_geom
		FROM cm.om_campaign_x_arc a
		JOIN cm.om_campaign_lot_x_arc b USING (arc_id) 
		WHERE the_geom IS NOT NULL AND lot_id IN (%s)
	)
	SELECT a.arc_id, a.arccat_id, string_agg(b.arc_id::text, '','') AS arc_id_duplicated, a.the_geom
	FROM mec a, mec b WHERE a.arc_id != b.arc_id and st_equals(a.the_geom, b.the_geom) is true
	and st_area(a.the_geom)>0
	GROUP BY a.arc_id, a.arccat_id, a.the_geom
	ORDER BY a.arccat_id',
	array_to_string(v_lot_id_array, ',')
    );

   	EXECUTE 'select count(*) from ('||v_sql_result||')' INTO v_count;
   
   	-- Report results
   	INSERT INTO t_audit_check_data (fid, criticity, error_message)
	SELECT 999, 1, concat('There are ', v_count, ' duplicated arcs in the lot ', array_to_string(v_lot_id_array, ',')||'.');

   	-- Return results
	-- temporal table for nodes
	execute FORMAT(
		'SELECT jsonb_build_object(
		    ''type'', ''FeatureCollection'',
		    ''features'', COALESCE(jsonb_agg(features.feature), ''[]''::jsonb)
		)
		FROM (
		  	SELECT jsonb_build_object(
		     ''type'',       ''Feature'',
		    ''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
		    ''properties'', to_jsonb(row) - ''the_geom''
		  	) AS feature
		  	FROM (%s) row) features',
		  	v_sql_result
	) INTO v_result;
	v_result_line := COALESCE(v_result, '{}');
	
   
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM t_audit_check_data WHERE fid = 999) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');


	DROP TABLE IF EXISTS t_audit_check_data;

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_line := COALESCE(v_result_line, '{}');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"line":'||v_result_line||
			'}}'||
	    '}')::json, 2110, null, null, null);
   
END;
$function$
;
