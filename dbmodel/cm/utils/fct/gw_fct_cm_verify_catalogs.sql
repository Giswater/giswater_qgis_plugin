/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3562

DROP FUNCTION IF EXISTS cm.gw_fct_cm_verify_catalogs(json);
CREATE OR REPLACE FUNCTION cm.gw_fct_cm_verify_catalogs(p_data json) RETURNS json AS
$BODY$

/*EXAMPLE
SELECT cm.gw_fct_cm_verify_catalogs('{"data":{"projectType":"CM","version":"4.0","fromProduction":false}}'::json);
*/

DECLARE

rec_check record;
v_exists boolean;
v_alias text;
querytext text;
v_column_exists boolean;
v_cm_tablename text;
v_lot_id integer;
v_campaign_id integer;
v_lot_id_array integer[];
v_version text;
v_result json;
v_result_info json;
v_fid int = 3562;
v_project_type text;

BEGIN

	SET search_path = "PARENT_SCHEMA", public;

	SELECT giswater, UPPER(project_type) INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	v_campaign_id := (p_data ->'data' ->'parameters'->>'campaignId')::integer;
	v_lot_id := (p_data ->'data' ->'parameters'->>'lotId')::integer;

	-- create temporal tables
	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"CREATE", "group":"LOG"}}}$$)';


	IF v_lot_id IS NULL THEN
		SELECT array_agg(lot_id) INTO v_lot_id_array FROM cm.om_campaign_lot WHERE status IN (3,4,6) AND campaign_id = v_campaign_id GROUP BY campaign_id;
	ELSE
		v_lot_id_array := array[v_lot_id];
	END IF;

	FOR rec_check IN SELECT formname as tablename, columnname, dv_querytext, dv_isnullvalue
					FROM PARENT_SCHEMA.config_form_fields
					WHERE widgettype = 'combo' AND dv_querytext IS NOT NULL
					AND (formname ILIKE 've_node_%' OR formname ILIKE 've_arc_%') ORDER BY formname, columnname
	LOOP

		SELECT concat('PARENT_SCHEMA_', split_part(rec_check.tablename, '_', 3)) INTO v_cm_tablename;

		SELECT EXISTS (SELECT 1
		FROM information_schema.COLUMNS
		WHERE table_schema = 'cm'
		AND table_name = v_cm_tablename
		AND column_name = rec_check.columnname) INTO v_column_exists;
		
		IF v_column_exists IS TRUE THEN
			querytext := format('SELECT EXISTS (SELECT 1 FROM cm.%I WHERE lot_id IN (%s) AND (%I IS NOT NULL OR %L IS TRUE) AND %I::text NOT IN (SELECT id::text FROM (%s))) LIMIT 1',
					v_cm_tablename, array_to_string(v_lot_id_array, ','), rec_check.columnname, rec_check.dv_isnullvalue, rec_check.columnname, rec_check.dv_querytext);

			EXECUTE querytext INTO v_exists;
			
			SELECT label INTO v_alias
			from PARENT_SCHEMA.config_form_fields
			WHERE formname = rec_check.tablename
			AND columnname = rec_check.columnname;
	
			IF v_exists IS TRUE THEN
				EXECUTE format('SELECT gw_fct_getmessage($msg${"data":{"message":"4622", "function":"3552", "parameters":{"alias":"%s", "column":"%s", "table": "%s"}, "fid":"3562", "is_process":true, "tempTable":"t_"}}$msg$)', 
							v_alias, rec_check.columnname, v_cm_tablename);
			END IF;
		END IF;
		
	END LOOP;

	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM t_audit_check_data WHERE fid = 3562) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');
	
	-- Drop temporal tables
	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"DROP", "group":"LOG"}}}$$)';

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||
			'}}'||
	    '}')::json, 3562, null, null, null);

EXCEPTION WHEN OTHERS THEN

	-- Optional: clean temp tables even on error
	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"DROP", "group":"LOG"}}}$$)';

	-- Return controlled JSON error
	RETURN gw_fct_json_create_return(
		('{"status":"Failed","message":{"level":3,"text":"' || replace(SQLERRM,'"','''') || '"}}')::json,
		3562, null, null, null
	);

END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
