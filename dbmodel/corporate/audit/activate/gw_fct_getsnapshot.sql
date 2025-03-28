/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- DROP FUNCTION SCHEMA_NAME.gw_fct_getsnapshot();

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getsnapshot(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

DECLARE

v_schemaname text;
v_version text;
v_error_context text;
v_date date;
v_polygon text;
v_selected_features text[];
v_last_snapshot_date date;
v_tables text[];
v_table text;
v_log record;
v_result json;
v_query text;
temp_table_name text;
snapshot_table_name text;
v_counter integer;
v_columns text;
v_values text;
v_sql text;
v_set_clause text;
v_layer JSONB := '[]'::JSONB;
v_features JSONB := '[]'::JSONB;
v_geometry_type text;

BEGIN
	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	-- Get api version
    SELECT value INTO v_version FROM PARENT_SCHEMA.config_param_system WHERE parameter = 'admin_version';

	v_date = ((p_data ->>'form')::json->>'date');
	v_polygon = ((p_data ->>'form')::json->>'polygon');
	v_selected_features := ARRAY(SELECT * FROM jsonb_array_elements_text((p_data -> 'form' ->> 'features')::jsonb));

	-- Get last snapshot date and tables
	SELECT "date", tables INTO v_last_snapshot_date, v_tables
	FROM "snapshot" WHERE "date" <= v_date ORDER BY "date" DESC LIMIT 1;

	-- Loop throught tables of the last snapshot date
	FOREACH v_table IN ARRAY COALESCE(v_tables, '{}') LOOP

		-- Set table names
		snapshot_table_name = FORMAT('PARENT_SCHEMA_%I', v_table);
		temp_table_name := FORMAT('temp_%I', snapshot_table_name);

		-- Create temporal table with values of the last snapshot
		EXECUTE FORMAT('CREATE TABLE %I AS SELECT * FROM %I WHERE date = %L',
					temp_table_name, snapshot_table_name, v_last_snapshot_date);

		EXECUTE FORMAT ('ALTER TABLE %I DROP COLUMN IF EXISTS date', temp_table_name);

		-- Get logs from v_table between last snapshot date and selected date
		FOR v_log IN
			SELECT * FROM log WHERE tstamp::date BETWEEN v_last_snapshot_date AND v_date
			AND table_name = v_table ORDER BY tstamp
		LOOP
			-- Inspect if is an insert
			EXECUTE FORMAT ('SELECT count(*) FROM %I WHERE %I = ''%s''',
			temp_table_name, v_log.id_name, v_log.feature_id) INTO v_counter;

			IF v_log.action = 'U' and v_counter = 0 THEN
				UPDATE log SET action = 'I', olddata = NULL
				WHERE id = v_log.id;
				v_log.action = 'I';
			END IF;

			-- Check actions
			IF v_log.action = 'I' THEN

				-- Insert data
				v_columns := string_agg(quote_ident(key), ', ') FROM json_each(v_log.newdata);
				v_values := string_agg(quote_literal(value), ', ') FROM json_each(v_log.newdata);
				v_sql := format('INSERT INTO %I (%s) VALUES (%s);', temp_table_name, v_columns, v_values);

			ELSEIF v_log.action = 'U' THEN

				-- Get different values between old and new json
				SELECT string_agg(quote_ident(n.key) || ' = ' || quote_literal(n.value), ', ')
				INTO v_set_clause
				FROM json_each(v_log.newdata) n
				LEFT JOIN json_each(v_log.olddata) o ON n.key = o.key
				WHERE n.value::text != o.value::text OR o.value IS NULL;

				v_sql := format('UPDATE %I SET %s', temp_table_name, v_set_clause);

			ELSEIF v_log.action = 'D' THEN

				-- Delete data
				v_sql := FORMAT('DELETE FROM %I WHERE %I = ''%I''', temp_table_name, v_log.id_name, v_log.feature_id);

			END IF;

			-- Clean query and execute it
			v_sql := regexp_replace(v_sql, '''(null|true|false|[0-9]+(\\.[0-9]+)?)''', '\1', 'g');
			v_sql := REPLACE(v_sql, '"', '');

			-- RAISE NOTICE '%', v_sql;
			-- EXECUTE (v_sql);

		END LOOP;

		-- Build layers for each temp table updated
		EXECUTE FORMAT('SELECT jsonb_agg(jsonb_build_object(''type'', ''Feature'',
			           ''geometry'', ST_AsGeoJSON(the_geom)::jsonb,
			        ''properties'', to_jsonb(row) - ''the_geom''
			    )) FROM (SELECT the_geom FROM %I) row;', temp_table_name) INTO v_features;


		v_geometry_type := CASE
		WHEN v_table ILIKE '%node%' OR v_table ILIKE '%connec%' THEN 'Point'
		ELSE 'LineString' END;

		v_layer := COALESCE(v_layer, '[]'::jsonb) || jsonb_build_array(
			    jsonb_build_object(
		            'layerName', v_table,
		            'features', v_features,
		            'geometryType', v_geometry_type
			    )
		);

		-- Delete temporal table
		EXECUTE FORMAT('DROP TABLE %I', temp_table_name);

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
