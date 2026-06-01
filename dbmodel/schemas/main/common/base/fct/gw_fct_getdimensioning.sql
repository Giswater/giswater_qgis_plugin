/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2824

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_getdimensioning(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getdimensioning(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_getdimensioning($${
    "client":{"device":4, "infoType":1, "lang":"ES"}, 
    "form":{}, "feature":{}, 
    "data":{"filterFields":{}, "pageInfo":{}, 
        "coordinates":{"x1":418482.9909557662, "y1":4577973.008625593, "x2":418513.4491390207, "y2":4577971.030821485}}}$$)
*/

DECLARE

v_status text ='Accepted';
v_message json;
v_version text;
v_forminfo json;
v_featureinfo json;
v_linkpath json;
v_parentfields text;
v_fields_array json[];
schemas_array name[];
v_project_type text;
aux_json json;
v_fields json;
field json;
v_id int8;
v_expl integer;
v_state integer;
v_epsg integer;
v_input_geometry public.geometry;
v_x1 double precision;
v_y1 double precision;
v_x2 double precision;
v_y2 double precision;
count_aux integer;

BEGIN

	-- Get,check and set parameteres
	----------------------------
	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	schemas_array := current_schemas(FALSE);

	-- Get srid
	v_epsg = (SELECT epsg FROM sys_version ORDER BY id DESC LIMIT 1);
    
	-- Get values from config
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;
		
	-- Get project type
	SELECT project_type INTO v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data 
	v_x1 := (((p_data ->>'data')::json->>'coordinates')::json->>'x1')::float;
	v_y1 := (((p_data ->>'data')::json->>'coordinates')::json->>'y1')::float;
	v_x2 := (((p_data ->>'data')::json->>'coordinates')::json->>'x2')::float;
	v_y2 := (((p_data ->>'data')::json->>'coordinates')::json->>'y2')::float;
    
    -- Geometry column
	IF v_x2 IS NULL THEN
		v_input_geometry:= ST_SetSRID(ST_MakePoint(v_x1, v_y1),v_epsg);
	ELSIF v_x2 IS NOT NULL THEN
		v_input_geometry:= ST_SetSRID(ST_MakeLine(ST_MakePoint(v_x1, v_y1), ST_MakePoint(v_x2, v_y2)), v_epsg);
	END IF;

	EXECUTE 'SELECT gw_fct_getformfields($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)'
	INTO v_fields_array
	USING 've_dimensions', 'form_feature', '', NULL, NULL, NULL, NULL, 'SELECT', null, 4, null::json;


	-- USE reduced geometry to intersect with expl mapzone in order to enhance the selectedId expl

	SELECT "value" INTO v_expl FROM config_param_user WHERE "parameter"='edit_exploitation_vdefault' AND "cur_user"="current_user"();
	
	IF v_expl IS NULL THEN
		v_expl = (SELECT expl_id FROM exploitation WHERE ST_DWithin(v_input_geometry, exploitation.the_geom,0.001)  AND active=true LIMIT 1);
		IF v_expl IS NULL THEN
			SELECT expl_id INTO v_expl FROM selector_expl WHERE cur_user = current_user LIMIT 1;
		END IF;
	END IF;

	-- get user's values
	SELECT "value" INTO v_state FROM config_param_user WHERE "parameter"='edit_state_vdefault' AND "cur_user"="current_user"();

	IF v_state IS NULL THEN
		v_state = (SELECT state_id FROM selector_state WHERE cur_user = current_user ORDER BY 1 ASC LIMIT 1);
	END IF;

	-- Set widget_name without tabname for widgets
	FOREACH field IN ARRAY v_fields_array
	LOOP
		v_fields_array[(field->>'orderby')::INT] := gw_fct_json_object_set_key(v_fields_array[(field->>'orderby')::INT], 'widgetname', field->>'columnname');
			
		IF (field->>'columnname') = 'expl_id' THEN
			v_fields_array[(field->>'orderby')::INT] := gw_fct_json_object_set_key(field, 'selectedId', v_expl::text);
		END IF;
		
		IF (field->>'columnname') = 'state' THEN
			v_fields_array[(field->>'orderby')::INT] := gw_fct_json_object_set_key(field, 'selectedId', v_state::text);
		END IF;
		
	END LOOP; 

	v_fields := array_to_json(v_fields_array);
	
	v_id = (SELECT nextval('SCHEMA_NAME.dimensions_id_seq'::regclass));

	v_featureinfo = '{"tableName":"ve_dimensions", "idName":"id", "id":'||v_id||'}';

	-- Control NULL's
	v_status := COALESCE(v_status, '{}');    
	v_message := COALESCE(v_message, '{}');    
	v_version := COALESCE(v_version, '');
	v_forminfo := COALESCE(v_forminfo, '{}');
	v_featureinfo := COALESCE(v_featureinfo, '{}');
	v_linkpath := COALESCE(v_linkpath, '{}');
	v_parentfields := COALESCE(v_parentfields, '{}');
	v_fields := COALESCE(v_fields, '{}');

	-- Return
    RETURN gw_fct_json_create_return(('{"status":"'||v_status||'", "message":'||v_message||', "version":"' || v_version || '"' ||
	      ',"body":{"form":' || v_forminfo ||
		     ', "feature":'|| v_featureinfo ||
		      ',"data":{"linkPath":' || v_linkpath ||
			      ',"parentFields":' || v_parentfields ||
			      ',"fields":' || v_fields || 
			      '}'||
			'}'||
		'}')::json, 2824, null, null, null);

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN 
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM),  'version', v_version, 'SQLSTATE', SQLSTATE)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

