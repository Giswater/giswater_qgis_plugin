-- DROP FUNCTION PARENT_SCHEMA.gw_fct_cm_topological_trace(json);

CREATE OR REPLACE FUNCTION PARENT_SCHEMA.gw_fct_cm_topological_trace(p_data json)
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
v_function_id int = 3542;
v_fid int = 999;
v_project_type text = 'ws'; -- WS mandatory to create temp tables

v_lot_id integer;
v_node_id integer;
v_campaign_id integer;

-- Vars
v_pgrouting_graph TEXT;
v_sql_result TEXT;
v_component int;
v_sql_connectedcomponents text;

v_count_graph numeric;
v_count_network numeric;
v_connected_network NUMERIC;
v_exists bool;
v_lot_id_array integer[];

-- Return
v_result json;
v_result_info json;
v_result_line json;



BEGIN

    SET search_path = "PARENT_SCHEMA", public;

	-- Init params
	SELECT giswater, epsg INTO v_version, v_srid FROM sys_version ORDER BY id DESC LIMIT 1;
   
	v_campaign_id := (p_data ->'data' ->'parameters'->>'campaignId')::integer;
   	v_node_id := (p_data ->'data' ->'parameters'->>'nodeId')::integer;
   	v_lot_id := (p_data ->'data' ->'parameters'->>'lotId')::integer;

	IF v_lot_id IS NULL THEN
		SELECT array_agg(lot_id) INTO v_lot_id_array FROM cm.om_campaign_lot WHERE status IN (3,4,6) AND campaign_id = v_campaign_id GROUP BY campaign_id;
	ELSE
		v_lot_id_array := array[v_lot_id];
	END IF;

	IF (SELECT lot_id FROM cm.om_campaign_lot_x_node WHERE node_id = v_node_id) <> ALL(v_lot_id_array) THEN
		EXECUTE 'SELECT PARENT_SCHEMA.gw_fct_getmessage($${"data":{"message": "4630", "function":"'||v_function_id||'", "fid":"'||v_fid||'", "is_process":true}}$$)';
	END IF;

	-- NOTE: temp tables and header to show in tab_info
	EXECUTE 'SELECT PARENT_SCHEMA.gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"CREATE", "group":"LOG"}}}$$)';
	EXECUTE 'SELECT PARENT_SCHEMA.gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"CREATE", "group":"ANL"}}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"'||v_function_id||'", "fid":"'||v_fid||'", "tempTable":"t_", "is_header":true,"separator_id":"2022"}}$$)';

	-- om_campaign_x_arc is the reference table to build the graph
   	v_pgrouting_graph := format('
	SELECT b.arc_id as id, b.node_1 as source, b.node_2 as target, 1 as cost 
	from cm.om_campaign_x_arc b
	join cm.om_campaign_lot_x_arc c using (arc_id)
	join cm.om_campaign_lot_x_node n1 ON n1.node_id = b.node_1
	join cm.om_campaign_lot_x_node n2 ON n2.node_id = b.node_2
	WHERE b.node_1 IS NOT NULL AND b.node_2 IS NOT null and b.the_geom is not null
	AND c.lot_id IN (%s) AND (c.action <> 3 OR c.action IS NULL) 
	AND (n1.action <> 3 OR n1.action IS NULL) 
	AND (n2.action <> 3 OR n2.action IS NULL)', 
	array_to_string(v_lot_id_array, ','));

	v_sql_connectedcomponents := format('SELECT * FROM pgr_connectedcomponents(%L)', v_pgrouting_graph); 

	execute format('SELECT component FROM (%s) WHERE node = %s LIMIT 1', v_sql_connectedcomponents, v_node_id) 
	INTO v_component;

	if v_component is null then

		INSERT INTO t_audit_check_data (fid, criticity, error_message)
		SELECT 999, 2, 'El node no forma parte de ningún componente. No es posible establecer una topología';

	else

	v_sql_result := format(
		'with mec as (
			%s WHERE component = %s
		), arcs_1 as (
			SELECT b.arc_id, a.component, b.the_geom from mec a
			join cm.om_campaign_x_arc b on a.node = b.node_1
			join cm.om_campaign_lot_x_arc c ON c.arc_id = b.arc_id
			WHERE (c.action <> 3 OR c.action IS NULL)
		), arcs_2 as (
			SELECT b.arc_id, a.component, b.the_geom from mec a
			join cm.om_campaign_x_arc b on a.node = b.node_2
			join cm.om_campaign_lot_x_arc c ON c.arc_id = b.arc_id
			WHERE (c.action <> 3 OR c.action IS NULL)
		), union_arcs as (
		select*from arcs_1 union select*from arcs_2
		)
		select*from union_arcs where the_geom is not null',
		v_sql_connectedcomponents,
		v_component
		);

    -- Control Input vars
	execute 'SELECT EXISTS('||v_sql_result||')' into v_exists;

	if v_exists is not true then

		INSERT INTO t_audit_check_data (fid, criticity, error_message)
		SELECT 999, log_level, concat(error_message, ' ', hint_message) FROM sys_message WHERE id = 4444;	
			
	end if;


   	-- stats: percentage of connected network
	
	execute format(
	'SELECT count(*) FROM cm.om_campaign_lot_x_node WHERE lot_id IN (%s) AND (action <> 3 OR action IS NULL)',
	array_to_string(v_lot_id_array, ',')
	) into v_count_network;



   	EXECUTE 'select count(*) from ('||v_sql_connectedcomponents||')' INTO v_count_graph;
   	--EXECUTE 'select count(*) from ('||v_pgrouting_graph||')' INTO v_count_network;
   
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
		    ''geometry'',   ST_Transform(the_geom, 4326),
		    ''properties'', to_jsonb(row) - ''the_geom''
		  	) AS feature
		  	FROM (%s) row) features',
		  	v_sql_result
	) INTO v_result;
	
	v_result_line := COALESCE(v_result, '{}');
   
	-- info
	
	INSERT INTO t_audit_check_data (fid, criticity, error_message)
	SELECT 999, 1, concat('Porcentaje de red topológicamente conectada desde el node_id ', v_node_id, ' : ', v_connected_network, ' %.') FROM sys_message WHERE id = 3700;

	end if;
	  
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM t_audit_check_data WHERE fid = 999) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');


	EXECUTE 'SELECT PARENT_SCHEMA.gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"DROP", "group":"LOG"}}}$$)';
	EXECUTE 'SELECT PARENT_SCHEMA.gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"DROP", "group":"ANL"}}}$$)';

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_line := COALESCE(v_result_line, '{}');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"line":'||v_result_line||
			'}}'||
	    '}')::json, 3542, null, null, null);
   
   -- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$function$
;
