-- DROP FUNCTION gw_fct_cm_topological_trace(json);

CREATE OR REPLACE FUNCTION cm.gw_fct_cm_topological_trace(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*EXAMPLE


SELECT gw_fct_cm_topological_trace($${"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{"parameters":{"nodeId":1}}}$$);

*/

DECLARE

-- Init params
v_version text;
v_srid integer;

v_lot_id integer;
v_node_id integer;
v_campaign_id integer;
-- Vars
v_pgrouting_graph TEXT;
v_sql_result TEXT;
v_lot_id_array integer[];
v_count_graph numeric;
v_count_network numeric;
v_connected_network NUMERIC;
v_exists bool;

-- Return
v_result json;
v_result_info json;
v_result_line json;



BEGIN

    SET search_path = "SCHEMA_NAME", public;

	-- Init params
	SELECT giswater, epsg INTO v_version, v_srid FROM sys_version ORDER BY id DESC LIMIT 1;
   
   	v_node_id := (p_data ->'data' ->'parameters'->>'nodeId')::integer;
   	v_lot_id := (p_data ->'data' ->'parameters'->>'lotId')::integer;
	v_campaign_id := (p_data ->'data' ->'parameters'->>'campaignId')::integer;

	CREATE TEMP TABLE IF NOT EXISTS t_audit_check_data (LIKE audit_check_data INCLUDING ALL);

	IF v_lot_id IS NULL THEN
		SELECT array_agg(lot_id) INTO v_lot_id_array FROM cm.om_campaign_lot WHERE status IN (3,4,6) AND campaign_id = v_campaign_id GROUP BY campaign_id;
	ELSE
		v_lot_id_array := array[v_lot_id];
	END IF;

	-- om_campaign_x_arc is the reference table to build the graph
   	v_pgrouting_graph = format('
	SELECT b.arc_id as id, b.node_1 as source, b.node_2 as target, 1 as cost 
	from cm.om_campaign_x_arc b
	join cm.om_campaign_lot_x_arc c using (arc_id)
	WHERE b.node_1 IS NOT NULL AND b.node_2 IS NOT null and b.the_geom is not null
	AND c.lot_id in (%s)',
	array_to_string(v_lot_id_array, ',')
    );

   	v_sql_result := format(
    'SELECT b.arc_id, b.arccat_id, b.the_geom FROM pgr_drivingDistance(%L::text, %L::bigint, 999999, false)a 
	LEFT JOIN cm.om_campaign_x_arc b on b.arc_id = a.edge WHERE b.the_geom is not null',
	v_pgrouting_graph,    
    v_node_id
    );
   
    -- Control Input vars

	execute 'SELECT EXISTS('||v_sql_result||')' into v_exists;

	if v_exists is not true then

		INSERT INTO t_audit_check_data (fid, criticity, error_message)
		SELECT 999, log_level, concat(error_message, ' ', hint_message) FROM PARENT_SCHEMA.sys_message WHERE id = 4444;	
			
	end if;

	

   	-- stats: percentage of connected network
   	EXECUTE 'select count(*) from ('||v_sql_result||')' INTO v_count_graph;
   	EXECUTE 'select count(*) from ('||v_pgrouting_graph||')' INTO v_count_network;
   
	-- Control division by 0
	IF v_count_network = 0 then v_count_network = 1; END IF;

   	SELECT round((v_count_graph/v_count_network)*100, 2) INTO v_connected_network;
	
   
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
	
	INSERT INTO t_audit_check_data (fid, criticity, error_message)
	SELECT 999, 1, concat('Percentage of topological connected network from the node_id ', v_node_id, ' : ', v_connected_network, ' %.') FROM PARENT_SCHEMA.sys_message WHERE id = 3700;

	  
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM t_audit_check_data WHERE fid = 999) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');


	DROP TABLE IF EXISTS t_audit_check_data;

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_line := COALESCE(v_result_line, '{}');

	--  Return
	RETURN PARENT_SCHEMA.gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"line":'||v_result_line||
			'}}'||
	    '}')::json, 2110, null, null, null);
   
END;
$function$
;