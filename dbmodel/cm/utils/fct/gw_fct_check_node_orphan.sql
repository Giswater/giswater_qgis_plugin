/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- DROP FUNCTION PARENT_SCHEMA.gw_fct_cm_check_node_orphan(json);

CREATE OR REPLACE FUNCTION PARENT_SCHEMA.gw_fct_cm_check_node_orphan(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*EXAMPLE


SELECT gw_fct_cm_check_node_orphan($${"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{"parameters":{"nodeId":1}}}$$);

*/

DECLARE

-- Init params
v_version text;
v_srid integer;

v_lot_id integer;


-- Vars

v_sql_result TEXT;
v_count int = 0;



-- Return
v_result json;
v_result_info json;
v_result_point json;



BEGIN

    SET search_path = "PARENT_SCHEMA","cm", public;

	-- Init params
	SELECT giswater, epsg INTO v_version, v_srid FROM sys_version ORDER BY id DESC LIMIT 1;
   
   	v_lot_id := (p_data ->'data' ->'parameters'->>'lotId')::integer;

	CREATE TEMP TABLE IF NOT EXISTS t_audit_check_data (LIKE audit_check_data INCLUDING ALL);

	-- Query for orphan nodes
   	v_sql_result := format(
    'WITH mec AS ( 
	 SELECT node_1 AS node_id FROM cm.om_campaign_x_arc WHERE node_1 IS NOT NULL UNION
	 SELECT node_2 AS node_id FROM cm.om_campaign_x_arc WHERE node_2 IS NOT NULL
	 ), moc AS ( 
	 	SELECT node_id FROM mec JOIN cm.om_campaign_lot_x_node USING (node_id) WHERE lot_id = %L
	 )
	 SELECT a.node_id, b.nodecat_id, b.the_geom FROM cm.om_campaign_lot_x_node a 
	 left join cm.om_campaign_x_node b using (node_id) 
	 left join PARENT_SCHEMA.cat_feature_node c on c.id = b.nodecat_id
	 WHERE a.lot_id = %L
	 AND a.node_id NOT IN (SELECT node_id FROM moc)',
	v_lot_id,    
    v_lot_id
    );

   	EXECUTE 'select count(*) from ('||v_sql_result||')' INTO v_count;
   
   	-- Report results
   	INSERT INTO t_audit_check_data (fid, criticity, error_message)
	SELECT 999, 1, concat('There are ', v_count, ' orphan nodes in the lot ', v_lot_id, '.');

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
	v_result_point := COALESCE(v_result, '{}');
	
   
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM t_audit_check_data WHERE fid = 999) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');


	DROP TABLE IF EXISTS t_audit_check_data;

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_point := COALESCE(v_result_point, '{}');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||
			'}}'||
	    '}')::json, 2110, null, null, null);
   
END;
$function$
;
