/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- DROP FUNCTION PARENT_SCHEMA.gw_fct_cm_check_node_document(json);

CREATE OR REPLACE FUNCTION PARENT_SCHEMA.gw_fct_cm_check_node_document(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*EXAMPLE


SELECT gw_fct_cm_check_node_document($${"client":{"device":4, "lang":"es_CR", "version":"4.7.0", "infoType":1, "epsg":8908}, "form":{}, "feature":{}, 
"data":{"filterFields":{}, "pageInfo":{}, "parameters":{"lotId":"16", "excludeNodecatId":null}, "aux_params":null}}$$);

*/

DECLARE

-- Init params
v_version text;
v_srid integer;

v_lot_id integer;


-- Vars

v_sql_result TEXT;
v_count int = 0;
v_tolerance NUMERIC = 0;
rec record;
v_exclude_nodecat text;



-- Return
v_result json;
v_result_info json;
v_result_point json;



BEGIN

    SET search_path = "PARENT_SCHEMA","cm", public;

	-- Init params
	SELECT giswater, epsg INTO v_version, v_srid FROM sys_version ORDER BY id DESC LIMIT 1;
   
   	v_lot_id := (p_data ->'data' ->'parameters'->>'lotId')::integer;
   	v_tolerance := (p_data ->'data' ->'parameters'->>'searchTolerance')::numeric;
   	v_exclude_nodecat := (p_data ->'data' ->'parameters'->>'excludeNodecatId')::text;

	SELECT string_agg(quote_literal(trim(elemento)), ', ') into v_exclude_nodecat
	from unnest(string_to_array(v_exclude_nodecat, ',')) AS elemento;

	v_exclude_nodecat = coalesce(v_exclude_nodecat, quote_literal(''));

	CREATE TEMP TABLE IF NOT EXISTS t_audit_check_data (LIKE audit_check_data INCLUDING ALL);

	CREATE TEMP TABLE IF NOT EXISTS t_count_nodes ( -- store all the nodes from a specific lot
		feature_type text,
		"uuid" uuid,
		tiene_geom bool,
		the_geom public.geometry(point, 8908) NULL
	);

	FOR rec in 
	select concat('PARENT_SCHEMA_', lower(id)) as table_child, id as feature_type from PARENT_SCHEMA.cat_feature_node where concat('PARENT_SCHEMA_', lower(id)) in 
	(select table_name from information_schema.tables where table_schema = 'cm')

	loop

		execute format(
			'insert into t_count_nodes
			select %L, uuid, coalesce(st_isvalid(the_geom), false), the_geom from cm.%I where lot_id = %L',
			rec.feature_type,
			rec.table_child,
			v_lot_id
		);

	end loop;

	-- 
	v_sql_result = '
	with mec as (
		select node_uuid as uuid, count(*) as n_doc from cm.doc_x_node group by node_uuid
	)
	select a.* from t_count_nodes a
	left join mec using (uuid) 
	where n_doc is null and feature_type NOT IN ('||v_exclude_nodecat||')';

	
   	EXECUTE 'select count(*) from ('||v_sql_result||')' INTO v_count;
   
   	-- Report results
   	INSERT INTO t_audit_check_data (fid, criticity, error_message)
	SELECT 999, 1, concat('There are ', v_count, 'nodes without related documents in the lot ', v_lot_id, '.');

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
	DROP TABLE IF EXISTS t_count_nodes;


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
