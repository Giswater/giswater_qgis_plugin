-- DROP FUNCTION gw_fct_cm_build_topology(json);

CREATE OR REPLACE FUNCTION gw_fct_cm_build_topology(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/* EXAMPLE:


-- From Giswater Toolbox
SELECT gw_fct_cm_build_topology($${"client":{"device":4, "lang":"", "version":"4.7.0", "infoType":1, "epsg":8908}, "form":{}, 
"feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"lotId":"25", "updateType":"1"}, "aux_params":null}}$$);


-- From Database using SQL: updateType is ignored and arcId will be taken into account)
SELECT gw_fct_cm_build_topology(concat('{
"client":{"device":4, "lang":"", "version":"4.7.0", "infoType":1, "epsg":8908}, 
"form":{}, 
"feature":{}, 
"data":{"filterFields":{}, "pageInfo":{}, "parameters":{"lotId":"22", "updateType":"1", "arcId":"', arc_id, '"}, "aux_params":null}}')::json) from 
om_campaign_lot_x_arc where lot_id = 25 and arc_id = -146;


*/

DECLARE
	-- Init params
	v_version text;
	v_schemaname text := 'SCHEMA_NAME';
	v_project_type text;

	-- Input params
	v_lot_id integer;
	v_arc_id integer;
	
	v_update_type integer;

	-- vars
	v_sql_arcs text;
	v_sql_nodes text;
v_filter_arc text;
rec record;
v_sql_topology text;
v_node text;
v_exists bool;

	-- Custom for campaign types
	v_prev_search_path text;
	v_forminfo json := '{}'::json;
	v_featureinfo JSON;

	--Return
	v_count_1 integer = 0;
	v_count_2 integer = 0;

	v_result json;
	v_result_info json;
	v_fid integer = 999;
v_message json;
	v_return json;

	
BEGIN
	-- Set search path transaction-locally
	--v_prev_search_path := current_setting('search_path');
	--PERFORM set_config('search_path', 'cm, ap, public', true);

	SET search_path = "cm","SCHEMA_NAME", public; 

	-- Get version
	select giswater, project_type into v_version, v_project_type from cm.sys_version order by id limit 1;


	-- Input params
	v_lot_id := (p_data -> 'data' -> 'parameters' ->> 'lotId')::int;
	v_update_type := (p_data -> 'data' -> 'parameters' ->> 'updateType')::int;
	v_arc_id := (p_data -> 'data' -> 'parameters' ->> 'arcId')::int;


	
	-- Choose which arcs are going to be updated
	if v_update_type is not null then

		if v_update_type = 1 then -- all the arcs of the lot
			v_filter_arc = '';

		elsif v_update_type = 2 then -- only the arcs that have node_1 = null or node_2 = null
			v_filter_arc = ' AND (b.node_1 is null or b.node_2 is null)';
		end if;

	else

	end if;

	-- OPTIONAL: execute function by SQL to update the arcs of the resulting query (only possible via SQL, not toolbox)
	if v_arc_id is not null then
		v_filter_arc = ' AND arc_id = '||v_arc_id||'';
	end if;

	-- Available nodes to build topology of arcs
	v_sql_nodes = '
		select a.node_id, b.the_geom as node_geom 	
		from cm.om_campaign_lot_x_node a 	
		join cm.om_campaign_x_node b using (node_id) 	
		where lot_id = '||v_lot_id||' and b.the_geom is not null';


	-- Arcs that are going to be updated
	v_sql_arcs = '
	select a.arc_id, b.the_geom as arc_geom 	
			 from cm.om_campaign_lot_x_arc a 	
			 join cm.om_campaign_x_arc b using (arc_id)  	
			 where lot_id = '||v_lot_id||' and b.the_geom is not null '||v_filter_arc||' and st_isvalid(b.the_geom) is true';


	-- Know if there is any arc to be updated (for later manage the process)
	execute 'SELECT EXISTS (SELECT 1 FROM ('||v_sql_arcs||'))' into v_exists;


	if v_exists then
		-- Start process	
		for rec in select 'ST_Startpoint' as vertex union select 'ST_Endpoint' as vertex
		loop
			
			v_sql_topology = '
			with resu as (
				 select row_number() over() as rwid, a.arc_id, a.arc_geom, b.node_id, 
				 ROW_NUMBER() OVER(PARTITION BY a.arc_id ORDER BY a.arc_id, ST_Distance('||rec.vertex||'(a.arc_geom), b.node_geom) asc) 
				 as rw from ('||v_sql_arcs||') a 
				 left join ('||v_sql_nodes||') b on st_dwithin ('||rec.vertex||'(a.arc_geom), b.node_geom, 0.01)
				 )
			select arc_id, node_id from resu where rw = 1';
	
						
			if rec.vertex = 'ST_Startpoint' then 
				v_node = 'node_1';
				execute 'select count(*) from ('||v_sql_topology||')' into v_count_1;
			else 
				v_node = 'node_2';
				execute 'select count(*) from ('||v_sql_topology||')' into v_count_2;
			end if;
			
			execute '
			update cm.om_campaign_lot_x_arc t
			set '||v_node||' = a.node_id from ('||v_sql_topology||')a
			where t.arc_id = a.arc_id';
	
			execute '
			update cm.ap_tuberia t
			set '||v_node||' = a.node_id from ('||v_sql_topology||')a
			where t.arc_id = a.arc_id';
	
			execute '
			update cm.om_campaign_x_arc t
			set '||v_node||' = a.node_id from ('||v_sql_topology||')a
			where t.arc_id = a.arc_id';
			
		end loop;

	end if;

	-- get diagnostics and return
	CREATE TEMP TABLE IF NOT EXISTS t_audit_check_data (LIKE audit_check_data INCLUDING ALL);


	-- Total udpated rows
	INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message)
	SELECT v_fid, 999, 0, concat((select (v_count_1+v_count_2)/2), ' updated arcs of the Lot '||v_lot_id||'');

	-- Build return	
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM t_audit_check_data order by criticity desc, id asc) row;

	
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	
	select json_build_object('level', log_level, 'text', error_message) into v_message 
	from sys_message where id = 3700;

    DROP TABLE IF EXISTS t_audit_check_data;

	-- control null values
	v_message = coalesce(v_message, '{}');
	v_version = coalesce(v_version, '');
	v_result_info = coalesce(v_result_info, '{}');

    -- Create return
	-- Return
	v_return = ('{"status":"Accepted", "message":'||v_message||', "version":"'||v_version||'",
	"body":{"form":{},"data":{"info":'||v_result_info||'}}}')::json;
	
	
	return v_return;

	

END;
$function$
;
