/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE:3148


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_import_cat_feature(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_import_cat_feature($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{}}$$)

--fid:v_fid

*/

DECLARE


v_result_id text= 'import cat feature';
v_result json;
v_result_info json;
v_project_type text;
v_version text;
v_count integer;
v_label text;
v_error_context text;
v_level integer;
v_status text;
v_message text;
v_audit_result text;
v_fid integer;
v_shortcut text;
BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get system parameters
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;


   	v_fid = ((p_data ->>'data')::json->>'fid')::text;


	-- manage log (fid:  v_fid)
	DELETE FROM audit_check_data WHERE fid = v_fid AND cur_user=current_user;
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3148", "fid":"'||v_fid||'", "result_id":"'||v_result_id||'", "is_process":true, "is_header":"true"}}$$)';

	-- control of rows
	SELECT count(*) INTO v_count FROM temp_csv WHERE cur_user=current_user AND fid = v_fid;

	IF v_count =0 THEN
		INSERT INTO audit_check_data (fid, result_id, error_message) VALUES (v_fid, v_result_id, concat('Nothing to import'));
	ELSE
		--check if shortcut_key is duplicated with excisting data
		IF v_fid !=445 THEN
			SELECT csv5 FROM temp_csv INTO v_shortcut WHERE cur_user=current_user AND fid=v_fid
			AND csv5 IN (SELECT shortcut_key FROM cat_feature) AND  csv1 NOT IN (SELECT id FROM cat_feature) LIMIT 1;
		ELSE
			IF v_project_type = 'WS' THEN
				SELECT csv10 FROM temp_csv INTO v_shortcut WHERE cur_user=current_user AND fid=v_fid
				AND csv10 IN (SELECT shortcut_key FROM cat_feature) AND  csv1 NOT IN (SELECT id FROM cat_feature) LIMIT 1;
			ELSIF v_project_type = 'UD' THEN
				SELECT csv8 FROM temp_csv INTO v_shortcut WHERE cur_user=current_user AND fid=v_fid
				AND csv8 IN (SELECT shortcut_key FROM cat_feature) AND  csv1 NOT IN (SELECT id FROM cat_feature) LIMIT 1;
			END IF;
		END IF;

		IF v_shortcut IS NOT NULL THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3196", "function":"3148","parameters":{"shortcut":"'||v_shortcut||'"}, "is_process":true}}$$);'INTO v_audit_result;
		END IF;

		--insert configuration
		IF v_fid = 444 THEN
			--arc
			INSERT INTO ve_cat_feature_arc(id, feature_class, epa_default, code_autofill, shortcut_key, link_path, descript, active)
			SELECT csv1, csv2, csv3, csv4::boolean, csv5, csv6, csv7, csv8::boolean
			FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv1 NOT IN (SELECT id FROM cat_feature);

		ELSIF v_fid=445 THEN
			--node
			IF v_project_type = 'WS' THEN
				INSERT INTO ve_cat_feature_node(id, feature_class, epa_default, isarcdivide, isprofilesurface, choose_hemisphere,
   	    code_autofill, double_geom, num_arcs, graph_delimiter, shortcut_key, link_path, descript, active)
				SELECT csv1, csv2, csv3, csv4::boolean, csv5::boolean, csv6::boolean,
				csv7::boolean,csv8::json, csv9::integer, csv10, csv11, csv12, csv13, csv14::boolean
				FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv1 NOT IN (SELECT id FROM cat_feature);

			ELSIF v_project_type = 'UD' THEN
				INSERT INTO ve_cat_feature_node (id, feature_class, epa_default, isarcdivide, isprofilesurface, code_autofill,
       	choose_hemisphere, double_geom, num_arcs, isexitupperintro, shortcut_key, link_path, descript, active)
				SELECT csv1, csv2, csv3, csv4::boolean, csv5::boolean, csv6::boolean,
				csv7::boolean, csv8::json, csv9::integer, et.id::integer, csv11, csv12, csv13, csv14::boolean
  			FROM temp_csv
  			LEFT JOIN edit_typevalue et ON et.id=csv10 AND  typevalue = 'value_boolean'
  			WHERE  cur_user=current_user AND fid=v_fid AND csv1 NOT IN (SELECT id FROM cat_feature);
			END IF;

		ELSIF v_fid=446 THEN
		--connec
			IF v_project_type = 'WS' THEN
				INSERT INTO ve_cat_feature_connec(id, feature_class, epa_default, code_autofill, shortcut_key, link_path, descript, active)
				SELECT csv1, csv2, csv3, csv4::boolean, csv5, csv6, csv7, csv8::boolean
				FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv1 NOT IN (SELECT id FROM cat_feature);
			ELSIF v_project_type = 'UD' THEN
				INSERT INTO ve_cat_feature_connec(id, feature_class, code_autofill, double_geom, shortcut_key, link_path, descript, active)
				SELECT csv1, csv2, csv3::boolean, csv4::json, csv5, csv6, csv7, csv8::boolean
				FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv1 NOT IN (SELECT id FROM cat_feature);
			END IF;

		ELSIF v_fid=447 THEN
		--gully
			INSERT INTO ve_cat_feature_gully(id, feature_class, code_autofill, double_geom, shortcut_key, link_path, descript, active)
			SELECT csv1, csv2, csv3::boolean, csv4::json, csv5, csv6, csv7, csv8::boolean
			FROM temp_csv WHERE cur_user=current_user AND fid=v_fid AND csv1 NOT IN (SELECT id FROM cat_feature);
		END IF;

		-- manage log (fid: v_fid)
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3908", "function":"3148", "fid":"'||v_fid||'", "result_id":"'||v_result_id||'", "is_process":true}}$$)';

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3946", "function":"3148", "fid":"'||v_fid||'", "result_id":"'||v_result_id||'", "is_process":true}}$$)';

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3948", "function":"3148", "fid":"'||v_fid||'", "result_id":"'||v_result_id||'", "is_process":true}}$$)';

	END IF;

	-- get log (fid: v_fid)
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message AS message FROM audit_check_data WHERE cur_user="current_user"() AND fid = v_fid) row;

	IF v_audit_result is null THEN
        v_status = 'Accepted';
        v_level = 3;
        v_message = 'Process done successfully';
    ELSE

        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status;
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;

    END IF;


	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	-- Control nulls
	v_version := COALESCE(v_version, '{}');
	v_result_info := COALESCE(v_result_info, '{}');

	-- Return
	RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
            ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||'}}'||
	    '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
