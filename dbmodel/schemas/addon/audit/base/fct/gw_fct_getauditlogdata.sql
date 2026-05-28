/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- DROP FUNCTION audit.gw_fct_getauditlogdata(json);

CREATE OR REPLACE FUNCTION audit.gw_fct_getauditlogdata(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

DECLARE

v_schemaname text;
v_version text;
v_error_context text;
v_log_id integer;
v_feature_id text;
v_table_name text;
v_date date;
v_olddata json;
v_newdata json;
v_idname text;
v_tstamp timestamp;
v_geometry_type text;
v_the_geom jsonb;
v_geometry text;
v_schema_parent text;

BEGIN
	-- search path
	SET search_path = "audit", public;
	v_schemaname = 'audit';

	v_schema_parent := (p_data->'schema'->>'parent_schema');
	-- Get api version
	EXECUTE format('SELECT giswater FROM %I.sys_version ORDER BY id DESC LIMIT 1', v_schema_parent) INTO v_version;

	v_log_id = ((p_data ->>'form')::json->>'logId');
	v_date = ((p_data ->>'form')::json->>'date');
	v_feature_id = ((p_data ->>'form')::json->>'featureId');
	v_table_name = ((p_data ->>'form')::json->>'tableName');

	IF v_log_id IS NOT NULL THEN
		-- Get data from specific log
		SELECT old_value, new_value INTO v_olddata, v_newdata
		FROM log WHERE id = v_log_id;

	ELSE
		SELECT new_value, tstamp, id_name
		INTO v_newdata, v_tstamp, v_idname
		FROM log
		WHERE feature_id = v_feature_id
       	AND table_name = v_table_name
		AND "schema" = v_schema_parent
		ORDER BY tstamp DESC LIMIT 1;

		SELECT new_value INTO v_olddata
		FROM log
        WHERE feature_id = v_feature_id
		AND table_name = v_table_name
		AND "schema" = v_schema_parent
        AND tstamp::date <= v_date
		AND tstamp < v_tstamp
        ORDER BY tstamp DESC LIMIT 1;

		IF v_olddata IS NULL THEN

			EXECUTE format(
                'SELECT row_to_json(t)  
                 FROM (SELECT * FROM %I 
                 WHERE %I = %L 
                 AND date <= %L 
                 ORDER BY date DESC LIMIT 1) t',
                v_schema_parent||'_' || v_table_name,
                v_idname,
                v_feature_id,
                v_date
            ) INTO v_olddata;

			v_geometry_type := CASE
								WHEN v_table_name ILIKE '%node%'
								OR v_table_name ILIKE '%connec%'
							  	THEN 'Point'
								ELSE 'LineString' END;

            v_the_geom := (v_olddata::jsonb)->'the_geom';

            IF v_geometry_type = 'Point' THEN
				    v_geometry := 'POINT (' ||
				            array_to_string(
				                ARRAY[
				                    (v_the_geom->'coordinates'->0)::text,
				                    (v_the_geom->'coordinates'->1)::text
				                ], ' '
				            ) || ')';
            ELSE
                v_geometry := 'LINESTRING (' ||
                        array_to_string(
                            ARRAY[
                                replace((v_the_geom->'coordinates'->0)::text,',',''),
                                replace((v_the_geom->'coordinates'->1)::text,',','')
                            ], ', '
                        ) || ')';
                v_geometry = regexp_replace(v_geometry, '[\[\]]', '', 'g');
            END IF;

			v_olddata := jsonb_set(v_olddata::jsonb, '{the_geom}', to_jsonb(v_geometry))::json;

		END IF;
	END IF;

	-- Return JSON
	RETURN jsonb_build_object(
	        'status', 'Accepted',
	        'version', v_version,
	        'old_value', COALESCE(v_olddata, '{}'),
			'new_value', COALESCE(v_newdata, '{}')
	    );

	EXCEPTION
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
			RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||
				',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;

$function$
;
