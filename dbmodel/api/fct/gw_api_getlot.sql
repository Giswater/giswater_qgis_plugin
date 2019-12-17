/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2640

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getlot(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:

-- calling form
SELECT SCHEMA_NAME.gw_api_getlot($${"client":{"device":3,"infoType":100,"lang":"es"}, "feature":{"tableName":"om_visit_lot", "idName":"id", "id":"1"}}$$)
*/

DECLARE
	v_apiversion text;
	v_schemaname text;
	v_id text;
	v_idname text;
	v_columntype text;
	v_device integer;
	v_tablename text;
	v_fields json [];
	v_fields_json json;
	v_forminfo json;
	v_formheader text;
	v_formactions text;
	v_formtabs text;
	v_tabaux json;
	v_active boolean;
	aux_json json;
	v_tab record;
	v_projecttype varchar;
	v_activedatatab boolean;
	v_client json;
	v_layermanager json;
	v_message json;
	v_values json;
	array_index integer DEFAULT 0;
	v_fieldvalue text;
	v_geometry json;
	v_value text;
	v_team text;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname := '';

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
		INTO v_apiversion;

	-- fix diferent ways to say null on client
	p_data = REPLACE (p_data::text, '"NULL"', 'null');
	p_data = REPLACE (p_data::text, '"null"', 'null');
	p_data = REPLACE (p_data::text, '"SCHEMA_NAME"', 'null');

	-- get project type
	SELECT wsoftware INTO v_projecttype FROM version LIMIT 1;


	--  get parameters from input
	v_client = (p_data ->>'client')::json;
	v_device = ((p_data ->>'client')::json->>'device')::integer;
	v_id = ((p_data ->>'feature')::json->>'id')::text;
	v_idname = ((p_data ->>'feature')::json->>'idName')::text;
	v_tablename = (p_data ->>'feature')::json->>'tableName'::text;
	v_message = ((p_data ->>'data')::json->>'message');
	--v_active:= TRUE;

	v_columntype = 'integer';
	
	--  Create tabs array	
	v_formtabs := '[';
       
		-- Data tab
		-----------
		SELECT gw_api_get_formfields( 'lot', 'lot', 'data', null, null, null, null, 'INSERT', null, v_device) INTO v_fields;
		raise notice '-> %', v_idname;
		-- getting values from feature
		IF v_id IS NOT NULL THEN
			EXECUTE FORMAT ('SELECT (row_to_json(a)) FROM (SELECT * FROM %s WHERE %s = CAST($1 AS %s))a', v_tablename, v_idname, v_columntype)
				INTO v_values
				USING v_id;
				
			

			-- setting values
			FOREACH aux_json IN ARRAY v_fields 
			LOOP          
				array_index := array_index + 1;
				v_fieldvalue := (v_values->>(aux_json->>'column_id'));
				IF (aux_json->>'column_id') = 'lot_id' THEN
					v_fieldvalue = (v_values->>('idval'));
				ELSIF (aux_json->>'column_id') IN ('team_id', 'visitclass_id', 'descript') THEN
					v_fields[array_index] := gw_fct_json_object_set_key(v_fields[array_index], 'disabled', TRUE);
				END IF;
				
				IF (aux_json->>'widgettype')='combo' THEN 
					v_fields[array_index] := gw_fct_json_object_set_key(v_fields[array_index], 'selectedId', COALESCE(v_fieldvalue, ''));
				ELSE 
					v_fields[array_index] := gw_fct_json_object_set_key(v_fields[array_index], 'value', COALESCE(v_fieldvalue, ''));
				END IF;
			END LOOP;	

			-- getting geometry
			EXECUTE 'SELECT row_to_json(a) FROM (SELECT St_AsText(St_simplify(the_geom,0)) FROM om_visit_lot WHERE id='||v_id||')a'
				INTO v_geometry;

			-- building header
			v_formheader :=concat('ORDRE TREBALL - ',v_id);		

		ELSE
			-- getting new id from sequence of lots
			v_id= (SELECT nextval('SCHEMA_NAME.om_visit_lot_id_seq'::regclass));

			-- building header
			v_formheader :=concat('NOVA ORDRE TREBALL - ', v_id);							

			-- setting values
			FOREACH aux_json IN ARRAY v_fields 
			LOOP          
				array_index := array_index + 1;
				IF (aux_json->>'column_id') = 'id' THEN
					v_fields[array_index] := gw_fct_json_object_set_key(v_fields[array_index], 'value', COALESCE(v_id, ''));
				ELSIF (aux_json->>'column_id') = 'team_id' THEN
					-- Get current user team id
					EXECUTE 'SELECT team_id FROM om_visit_lot_x_user WHERE user_id = current_user ORDER BY starttime DESC' INTO v_fieldvalue;
					v_fields[array_index] := gw_fct_json_object_set_key(v_fields[array_index], 'selectedId', COALESCE(v_fieldvalue, ''));
				END IF;
			END LOOP;
										
		END IF;	
	
		v_fields_json = array_to_json (v_fields);
		v_fields_json := COALESCE(v_fields_json, '{}');	
				
		-- building
		SELECT * INTO v_tab FROM config_api_form_tabs WHERE formname='lot' AND tabname='tabData' and device = v_device LIMIT 1;
		IF v_tab IS NULL THEN 
			SELECT * INTO v_tab FROM config_api_form_tabs WHERE formname='lot' AND tabname='tabData' LIMIT 1;			
		END IF;
		v_tabaux := json_build_object('tabName',v_tab.tabname,'tabLabel',v_tab.tablabel, 'tabText',v_tab.tabtext, 
		'tabFunction', v_tab.tabfunction::json, 'tabActions', v_tab.tabactions::json, 'active',v_activedatatab);

		v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'fields', v_fields_json);
		v_formtabs := v_formtabs || v_tabaux::text;

	--closing tabs array
	v_formtabs := (v_formtabs ||']');


	-- actions and layermanager
	EXECUTE 'SELECT actions, layermanager FROM config_api_form WHERE formname = ''lot'' AND (projecttype ='||quote_literal(LOWER(v_projecttype))||' OR projecttype = ''utils'')'
		INTO v_formactions, v_layermanager;

	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formActions', v_formactions);
           


	-- Create new form
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formId', 'F11'::text);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formName', v_formheader);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formTabs', v_formtabs::json);
	

	--  Control NULL's
	v_apiversion := COALESCE(v_apiversion, '{}');
	v_message := COALESCE(v_message, '{}');
	v_forminfo := COALESCE(v_forminfo, '{}');
	v_tablename := COALESCE(v_tablename, '{}');
	v_layermanager := COALESCE(v_layermanager, '{}');
	v_geometry := COALESCE(v_geometry, '{}');

	raise notice' 1 % 2 % 3 % 4 % 5 % 6 % ', v_message, v_apiversion, v_tablename, v_id, v_layermanager, v_geometry;
  
	-- Return
	RETURN ('{"status":"Accepted", "message":'||v_message||', "apiVersion":'||v_apiversion||
             ',"body":{"feature":{"featureType":"lot", "tableName":"'||v_tablename||'", "idName":"id", "id":"'||v_id||'"}'||
		    ', "form":'||v_forminfo||
		    ', "data":{"layerManager":'||v_layermanager||
		               ',"geometry":'|| v_geometry ||'}}'||
		               '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



