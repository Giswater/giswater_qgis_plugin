/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


-- DROP FUNCTION cm.gw_fct_cm_update_geom(json);

CREATE OR REPLACE FUNCTION cm.gw_fct_cm_update_geom(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*
SELECT cm.gw_fct_cm_update_geom($${"data":{"parameters":{"id":"4", "cmType":"lot"}}}$$);


*/

DECLARE 



-- Init params
v_campaign_id integer;
v_lot_id integer;

v_cm_id integer;
v_cm_type text;
v_version text;
v_prev_search_path text;

-- Vars
v_sql_options text;
v_buffer numeric = 1;
v_filter text;
v_query_filter text;
rec record;

-- Return
v_message text;
v_return json;
v_result json;
v_result_info json;

	

BEGIN 

    -- Get params
	v_prev_search_path := current_setting('search_path');
    PERFORM set_config('search_path', 'cm,public', true);

	v_campaign_id := (p_data -> 'data' -> 'parameters'->>'campaignId')::integer;
	v_lot_id := (p_data -> 'data' -> 'parameters'->>'lotId')::integer;
	v_buffer := (p_data -> 'data' -> 'parameters'->>'buffer')::numeric;

	CREATE TEMP TABLE IF NOT EXISTS t_audit_check_data (LIKE audit_check_data INCLUDING ALL);

	if v_lot_id is not null then -- geom for lot
		v_cm_type = 'lot';
		v_cm_id = v_lot_id;
	else -- geom for campaign
		v_cm_type = 'campaign';
		v_cm_id = v_campaign_id;
	end if;
	

    -- Get version and input vars
    SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;
	--SELECT (value::json->> concat('buffer_', v_cm_type))::int INTO v_buffer FROM cm.config_param_system WHERE "parameter" = 'edit_campaign_lot_geom';

    v_buffer = coalesce(v_buffer, 1);

	-- Build a temp table using combinations of feature_type and lot/campaign
	v_sql_options := format('
	SELECT feature_type, cm_type, null::geometry as the_geom 
	FROM 
    (SELECT unnest(ARRAY[''arc'', ''node'', ''connec'', ''link'']) AS feature_type),
    (SELECT unnest(ARRAY[''lot'', ''campaign'']) AS cm_type)
	WHERE cm_type = %L',
	v_cm_type
	);

	EXECUTE 'CREATE TABLE cm.temp_geom AS ' || v_sql_options;

	FOR rec IN EXECUTE v_sql_options
	loop
	
		-- Build syntax query to update the temp_table with the union of the geoms for each feature_type
		if v_cm_type = 'lot' then
			v_filter = 'JOIN cm.om_campaign_lot_x_'||rec.feature_type||' l ON c.'||rec.feature_type||'_id = l.'||rec.feature_type||'_id WHERE l.';
		else
			v_filter = 'WHERE';
		end if;


		execute format (
		'UPDATE cm.temp_geom t SET the_geom = (
		SELECT ST_Union(c.the_geom) FROM %s c %s %s = %s AND c.the_geom is not null)
		WHERE t.feature_type = %L',
		'cm.om_campaign_x_' || rec.feature_type,
		v_filter,
		rec.cm_type || '_id',
		v_cm_id,
		rec.feature_type
		);

	end loop;

	-- update table of campaigns/lot with the union and buffer of the temp_geom (eventually the geom of all objects)
	execute format(
	'UPDATE om_campaign%s SET the_geom = (SELECT ST_Multi(ST_Buffer(ST_Collect(the_geom), %s)) FROM cm.temp_geom) WHERE %s = %L',
	case when v_cm_type = 'lot' then '_lot' else '' end,
	v_buffer,
	v_cm_type || '_id',
	v_cm_id
	);

	-- Report results
   	INSERT INTO t_audit_check_data (fid, criticity, error_message)
	SELECT 999, 1, concat('Geometría actualizada para ', v_cm_type, ' ', v_cm_id, '.');

	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM t_audit_check_data WHERE fid = 999) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');


	DROP TABLE IF EXISTS t_audit_check_data;
	DROP TABLE IF EXISTS cm.temp_geom;

	v_message := format('Geometry for %s %s updated successfully', v_cm_type, v_cm_id);
	v_result_info := COALESCE(v_result_info, '{}');

    --  Return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'",
	"body":{"form":{},"data":{"info":'||v_result_info||'}}}')::json;


    PERFORM set_config('search_path', v_prev_search_path, true);
	
	v_return = coalesce(v_return, '{}');



    RETURN v_return;

	EXCEPTION WHEN OTHERS THEN
    PERFORM set_config('search_path', v_prev_search_path, true);
    RETURN json_build_object('status','Failed','message',SQLERRM,'SQLSTATE',SQLSTATE);
END;
$function$
;
