/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- DROP FUNCTION audit.gw_fct_getsnapshot(json);

CREATE OR REPLACE FUNCTION audit.gw_fct_getsnapshot(p_data json)
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
v_feature_type text;
v_schema_parent text;

BEGIN
	-- search path
	SET search_path = "audit", public;
	v_schemaname = 'audit';
	v_schema_parent := (p_data->'schema'->>'parent_schema');

	-- Get api version
	EXECUTE format('SELECT giswater FROM %I.sys_version ORDER BY id DESC LIMIT 1', v_schema_parent) INTO v_version;

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
	    WHERE table_schema = v_schema_parent AND table_name = v_table
	    ORDER BY ordinal_position LIMIT 1;

		-- Get feature type from column name
		v_feature_type := REPLACE(v_idname, '_id', '');

		IF v_feature_type = ANY(v_selected_features) THEN
			-- Create dinamic table name
			v_temp_table_name := FORMAT('temp_%I_%I',v_schema_parent, v_table);

			-- Create temporal table with values of the last snapshot
			EXECUTE FORMAT('CREATE TABLE %I AS SELECT * FROM %I_%I WHERE date = %L',v_temp_table_name, v_schema_parent, v_table, v_last_snapshot_date);

			-- Get logs from v_table between last snapshot date and selected date
			FOR v_record IN
				SELECT DISTINCT ON (feature_id) * FROM log WHERE tstamp::date BETWEEN v_last_snapshot_date AND v_date
				AND table_name = v_table ORDER BY feature_id, tstamp DESC
			LOOP
				-- Apply changes from logs into temporal tables
				EXECUTE (v_record.sql);
			END LOOP;

			-- Get column names from v_table
		    SELECT string_agg(
	        v_schema_parent || '.' || v_table || '.' || column_name || '::text IS NOT DISTINCT FROM row.' || column_name|| '::text ',' AND ')
		    INTO v_columns
		    FROM information_schema.columns
		    WHERE table_name = v_table AND table_schema = v_schema_parent;

		-- Get feature class
		EXECUTE format('SELECT id FROM %I.cat_feature WHERE child_layer = ''%I''', v_schema_parent, v_table) INTO v_feature_class;

	    -- Build features
		EXECUTE format(
		    'SELECT jsonb_build_object(
		        ''type'', ''FeatureCollection'',
				''layerName'', '''||initcap(lower(v_feature_class))||''',
		        ''features'', COALESCE(jsonb_agg(jsonb_build_object(
		            ''type'', ''Feature'',
		            ''geometry'', ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
		            ''properties'', to_jsonb(row) - ''the_geom'',
		            ''color'', CASE
		                        WHEN NOT EXISTS (SELECT 1 FROM %I.%I WHERE %I = row.%I) THEN ''red''
		                        WHEN EXISTS (SELECT 1 FROM %I.%I WHERE %s) THEN ''blue''
		                        ELSE ''yellow''
		                      END
		        )), ''[]''::jsonb)
		    )
		    FROM (SELECT * FROM %I WHERE ST_Intersects(the_geom, %L)) row', v_schema_parent,
		    v_table, v_idname, v_idname, v_schema_parent, v_table, v_columns, v_temp_table_name, v_polygon
		) INTO v_features;

		-- Get geometry type
		v_geometry_type := CASE WHEN v_feature_type IN ('link','arc')
						   THEN 'LineString' ELSE 'Point' END;

		v_layer := COALESCE(v_layer, '[]'::jsonb) || jsonb_build_array(
			    jsonb_build_object(
		            'features', v_features,
					'group', initcap(v_feature_type)
			    )
		);

			-- Delete temporal table
			EXECUTE FORMAT('DROP TABLE IF EXISTS %I', v_temp_table_name);

		END IF;
	END LOOP;

	-- Return JSON
	RETURN jsonb_build_object(
	        'status', 'Accepted',
	        'version', v_version,
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
