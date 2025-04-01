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
v_temp_table_name text;
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
		v_temp_table_name := FORMAT('temp_PARENT_SCHEMA_%I', v_table);

		-- Create temporal table with values of the last snapshot
		EXECUTE FORMAT('CREATE TABLE %I AS SELECT * FROM PARENT_SCHEMA_%I WHERE date = %L',v_temp_table_name, v_table, v_last_snapshot_date);

		-- Drop date column
		EXECUTE FORMAT ('ALTER TABLE %I DROP COLUMN IF EXISTS date', v_temp_table_name);

		-- Get logs from v_table between last snapshot date and selected date
		FOR v_log IN
			SELECT DISTINCT ON (feature_id) * FROM log WHERE tstamp::date BETWEEN v_last_snapshot_date AND v_date
			AND table_name = v_table ORDER BY feature_id, tstamp DESC
		LOOP
			-- Apply changes from logs into temporal layers
			EXECUTE (v_log.query_sql);
		END LOOP;

		-- Build layers for each temp table updated
		EXECUTE FORMAT('SELECT jsonb_agg(jsonb_build_object(''type'', ''Feature'',
			           ''geometry'', ST_AsGeoJSON(the_geom)::jsonb,
			        ''properties'', to_jsonb(row) - ''the_geom''
			    )) FROM (SELECT the_geom FROM %I) row;', v_temp_table_name) INTO v_features;

		-- Get geometry type
		v_geometry_type := CASE WHEN v_table ILIKE '%node%' OR v_table ILIKE '%connec%'
						   THEN 'Point' ELSE 'LineString' END;

		v_layer := COALESCE(v_layer, '[]'::jsonb) || jsonb_build_array(
			    jsonb_build_object(
		            'layerName', v_table,
		            'features', v_features,
		            'geometryType', v_geometry_type
			    )
		);

		-- Delete temporal table
		EXECUTE FORMAT('DROP TABLE IF EXISTS %I', v_temp_table_name);

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
