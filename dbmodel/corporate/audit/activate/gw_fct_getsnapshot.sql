/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- DROP FUNCTION SCHEMA_NAME.gw_fct_getsnapshot(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getsnapshot(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

DECLARE

v_schemaname text;
v_version text;
v_error_context text;
v_date date;
v_polygon geometry;
v_selected_features text[];
v_last_snapshot_date date;
v_tables text[];
v_table text;
v_record record;
v_temp_table_name text;
v_layer jsonb := '[]'::jsonb;
v_features jsonb := '[]'::jsonb;
v_feature jsonb;
v_geometry_type text;
v_idname text;
v_columns text;
v_feature_class text;

BEGIN
	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	-- Get api version
    SELECT value INTO v_version FROM PARENT_SCHEMA.config_param_system WHERE parameter = 'admin_version';

	v_date = ((p_data ->>'form')::json->>'date');
	v_polygon = ST_GeomFromText(((p_data ->>'form')::json->>'polygon'), 25831);
	v_selected_features := ARRAY(SELECT * FROM jsonb_array_elements_text((p_data -> 'form' ->> 'features')::jsonb));

	-- Get last snapshot date and tables
	SELECT "date", tables INTO v_last_snapshot_date, v_tables
	FROM "snapshot" WHERE "date" <= v_date ORDER BY "date" DESC LIMIT 1;

	-- Loop throught tables of the last snapshot date
	FOREACH v_table IN ARRAY COALESCE(v_tables, '{}') LOOP

		-- Get first column assumming is pk
		SELECT column_name INTO v_idname FROM information_schema.columns
	    WHERE table_schema = 'PARENT_SCHEMA' AND table_name = v_table
	    ORDER BY ordinal_position LIMIT 1;

		IF regexp_replace(v_idname, '_id$', '', 'g') = ANY(v_selected_features) THEN
			-- Set table names
			v_temp_table_name := FORMAT('temp_PARENT_SCHEMA_%I', v_table);

			-- Create temporal table with values of the last snapshot
			EXECUTE FORMAT('CREATE TABLE %I AS SELECT * FROM PARENT_SCHEMA_%I WHERE date = %L',v_temp_table_name, v_table, v_last_snapshot_date);

			-- Get logs from v_table between last snapshot date and selected date
			FOR v_record IN
				SELECT DISTINCT ON (feature_id) * FROM log WHERE tstamp::date BETWEEN v_last_snapshot_date AND v_date
				AND table_name = v_table ORDER BY feature_id, tstamp DESC
			LOOP
				-- Apply changes from logs into temporal layers
				EXECUTE (v_record.query_sql);
			END LOOP;

			-- Get column names from v_table
		    SELECT string_agg(
	        'PARENT_SCHEMA.' || v_table || '.' || column_name || ' IS NOT DISTINCT FROM row.' || column_name, ' AND ')
		    INTO v_columns
		    FROM information_schema.columns
		    WHERE table_name = v_table;

		    -- Build features
			EXECUTE format(
			    'SELECT jsonb_agg(jsonb_build_object(
			        ''type'', ''Feature'',
			        ''geometry'', ST_AsGeoJSON(the_geom)::jsonb,
			        ''properties'', to_jsonb(row) - ''the_geom'',
			        ''color'', CASE
			                    WHEN NOT EXISTS (SELECT 1 FROM PARENT_SCHEMA.%I WHERE %I = row.%I) THEN ''red''
			                    WHEN EXISTS (SELECT 1 FROM PARENT_SCHEMA.%I WHERE %s) THEN ''blue''
			                    ELSE ''yellow''
			                  END
			    )) 
			    FROM (SELECT * FROM %I WHERE ST_Within(the_geom, %L)) row',
			    v_table, v_idname, v_idname, v_table, v_columns, v_temp_table_name, v_polygon
			) INTO v_features;

			-- Get geometry type
			v_geometry_type := CASE WHEN v_idname ILIKE '%node%' OR v_idname ILIKE '%connec%'
							   THEN 'Point' ELSE 'LineString' END;

			-- Get feature class
			SELECT feature_class INTO v_feature_class
			FROM ws.cat_feature WHERE child_layer = v_table;

			v_layer := COALESCE(v_layer, '[]'::jsonb) || jsonb_build_array(
				    jsonb_build_object(
			            'layerName', initcap(lower(v_feature_class)),
						'tableName', v_table,
			            'features', v_features,
			            'geometryType', v_geometry_type,
						'group', initcap(regexp_replace(v_idname, '_id$', '', 'g'))
				    )
			);

			-- Delete temporal table
			EXECUTE FORMAT('DROP TABLE IF EXISTS %I', v_temp_table_name);

		END IF;
	END LOOP;

	-- Return JSON
	RETURN jsonb_build_object(
	        'status', 'Accepted',
	        'version', to_jsonb(v_version),
	        'body', jsonb_build_object('data', v_layer)
	    );

	EXCEPTION
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
			RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||
				',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;

$function$
;
