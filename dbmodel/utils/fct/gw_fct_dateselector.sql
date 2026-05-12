/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3192

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_dateselector(p_data json)
 RETURNS json
AS $BODY$

/*EXAMPLE
--get dates for current user
SELECT SCHEMA_NAME.gw_fct_dateselector($${"client":{"device":4, "infoType":1, "lang":"ES", cur_user: "bgeo"}, "form":{}, 
"feature":{},"data":{"filterFields":{}, "pageInfo":{}, "action":"GET"}}$$);

--set dates for current user
SELECT SCHEMA_NAME.gw_fct_dateselector($${"client":{"device":4, "infoType":1, "lang":"ES", cur_user: "bgeo"}, "form":{}, 
"feature":{},"data":{"filterFields":{}, "pageInfo":{}, "action":"SET", "date_from": "", "date_to": ""}}$$);
*/

DECLARE 

v_schemaname text = 'SCHEMA_NAME';
v_project_type text;

v_device integer;
v_action text;
v_cur_user text;
v_date_from text;
v_date_to text;

v_layers text;
v_layer text;
v_rec record;
v_columns json;
v_layerColumns json;

v_return_level integer=1;
v_return_status text='Accepted';
v_return_msg text;
v_error_context text;
v_version text;
v_querytext text;

BEGIN

	-- search path
	SET search_path = "SCHEMA_NAME", public;

	-- get project type
	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;
	
	-- get parameters
	v_device = json_extract_path_text(p_data,'client','device');
	v_action = json_extract_path_text(p_data,'data','action');
	v_cur_user = json_extract_path_text(p_data,'client','cur_user');
	v_date_from = json_extract_path_text(p_data,'data','date_from');
	v_date_to = json_extract_path_text(p_data,'data','date_to');


	IF v_action = 'GET' THEN
		SELECT from_date, to_date INTO v_date_from, v_date_to FROM selector_date WHERE cur_user = v_cur_user;
		v_return_msg = 'Got dates';
	ELSIF v_action = 'SET' THEN
		IF (SELECT from_date FROM selector_date WHERE cur_user = v_cur_user) IS NULL THEN 
			-- INSERT 
			INSERT INTO selector_date (from_date, to_date, context, cur_user)
			VALUES (v_date_from::date, v_date_to::date, 'om_visit', v_cur_user);

			v_return_msg = 'Dates inserted';
		ELSE 
			-- UPDATE 
			UPDATE selector_date SET (from_date, to_date) = (v_date_from::date, v_date_to::date)
			WHERE cur_user = v_cur_user;

			v_return_msg = 'Dates updated';
		END IF;
	END IF;

	-- Manage QWC
	IF v_device = 5 THEN
		-- Get columns for layers
		v_layers := (p_data ->> 'data')::json->> 'layers';
		v_layerColumns = '{}';
		FOR v_rec IN SELECT json_array_elements(v_layers::json)
		LOOP
			v_layer = replace(replace(replace(v_rec::text, '"', ''), '(', ''), ')', '');
			SELECT json_agg(column_name) INTO v_columns FROM information_schema.columns WHERE table_schema = 'SCHEMA_NAME' AND table_name = v_layer;
			v_layerColumns := gw_fct_json_object_set_key(v_layerColumns, v_layer, v_columns);
		END LOOP;
	END IF;

	-- Control nulls
	v_version := COALESCE(v_version, ''); 
	v_layerColumns = COALESCE(v_layerColumns, '{}');

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"'||v_return_status||'", "message":{"level":'||v_return_level||', "text":"'||v_return_msg||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{"date_from":"'||v_date_from||'", "date_to":"'||v_date_to||'", "layerColumns":'||v_layerColumns||
		       '}'||
	    '}}')::json, 3192, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

