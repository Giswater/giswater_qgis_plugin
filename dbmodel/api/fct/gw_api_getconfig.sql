/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2570

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getconfig(p_data json)
  RETURNS json AS
$BODY$
DECLARE

/*EXAMPLE:
SELECT SCHEMA_NAME.gw_api_getconfig($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{"formName":"epaoptions"},
"feature":{},"data":{}}$$)

SELECT SCHEMA_NAME.gw_api_getconfig($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{"formName":"config"},
"feature":{},"data":{}}$$)
*/

--    Variables
    v_formtabs text;
    combo_json json;
    fieldsJson json;
    api_version json;
    rec_tab record;
    v_firsttab boolean;
    v_active boolean;
    fields json;
    fields_array json[];
    v_querytext_result text[];
    aux_json json;
    v_project_type text;
    tabUser json;
    combo_json_parent json;
    combo_json_child json;
    combo_rows json[];
    combo_rows_child json[];
    v_selected_id text;
    query_text text;
    aux_json_child json;
    v_device integer;
    v_formname text;
    v_tabadmin json;
    v_formgroupbox json[];
    v_formgroupbox_json json;

   
BEGIN

-- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

-- get input parameters
	v_formname := (p_data ->> 'form')::json->> 'formName';
        
--  Get project type
    SELECT wsoftware INTO v_project_type FROM version LIMIT 1;

-- Create tabs array
    v_formtabs := '[';

-- basic_tab
-------------------------
    SELECT * INTO rec_tab FROM config_api_form_tabs WHERE formname='config' AND tabname='tabUser';
    IF rec_tab.tabname IS NOT NULL THEN

	-- if ismandatory is true. First time for user value is forced
	-- Get all parameters from audit_cat param_user
	EXECUTE 'SELECT (array_agg(row_to_json(a))) FROM (
		SELECT label, audit_cat_param_user.id as name, value, datatype, widgettype, layout_id, layout_order, TRUE AS iseditable,
		row_number()over(ORDER BY layout_id, layout_order) AS orderby, isparent, sys_role_id,project_type, ismandatory, 
		(CASE WHEN value is not null THEN ''True'' ELSE ''False'' END) AS checked,
		(CASE WHEN (widgetcontrols->>''minValue'') IS NOT NULL THEN widgetcontrols->>''minValue'' ELSE NULL END) AS minvalue,
		(CASE WHEN (widgetcontrols->>''maxValue'') IS NOT NULL THEN widgetcontrols->>''maxValue'' ELSE NULL END) AS maxvalue
		FROM audit_cat_param_user LEFT JOIN (SELECT * FROM config_param_user WHERE cur_user=current_user) a ON a.parameter=audit_cat_param_user.id 
		WHERE sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))	
		AND formname ='||quote_literal(lower(v_formname))||'
		AND (project_type =''utils'' or project_type='||quote_literal(lower(v_project_type))||')
		AND isenabled IS TRUE
		ORDER by orderby)a'
			INTO fields_array ;

			raise notice 'fields_array %', fields_array;

	--  Combo rows
	EXECUTE 'SELECT (array_agg(row_to_json(a))) FROM (
		 SELECT label, audit_cat_param_user.id as name, datatype, widgettype, 
		 layout_id, layout_order, row_number()over(ORDER BY layout_id, layout_order) AS orderby, value, dv_querytext,dv_parent_id, isparent, sys_role_id
		 FROM audit_cat_param_user LEFT JOIN (SELECT * FROM config_param_user WHERE cur_user=current_user) a ON a.parameter=audit_cat_param_user.id 
		 WHERE sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))
  		 AND formname ='||quote_literal(lower(v_formname))||'
		 AND (project_type =''utils'' or project_type='||quote_literal(lower(v_project_type))||')
		 AND isenabled IS TRUE
		 AND dv_parent_id IS NULL ORDER BY orderby) a WHERE widgettype = ''combo'''
			INTO combo_rows;
			combo_rows := COALESCE(combo_rows, '{}');

	FOREACH aux_json IN ARRAY combo_rows
	LOOP	
		-- Get combo id's
		EXECUTE 'SELECT array_to_json(array_agg(id)) FROM ('||(aux_json->>'dv_querytext')||' ORDER BY idval)a'
			INTO combo_json;

		-- Update array
		fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'comboIds', COALESCE(combo_json, '[]'));
		fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'selectedId', aux_json->>'value');

		-- Get combo values
		EXECUTE 'SELECT array_to_json(array_agg(idval)) FROM ('||(aux_json->>'dv_querytext')||' ORDER BY idval)a'
			INTO combo_json; 
			combo_json := COALESCE(combo_json, '[]');

		-- Update array
		fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'comboNames', COALESCE(combo_json, '[]'));
		
		IF (aux_json->>'dv_isparent') IS NOT NULL THEN

			--  Combo rows child
			EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT id, column_id, sys_api_cat_widgettype_id AS widgettype, sys_api_cat_datatype_id AS datatype,
				dv_querytext, dv_isparent, dv_parent_id, orderby , dv_querytext_filterc
				FROM config_api_layer_field WHERE table_id = $1 AND dv_parent_id='||quote_literal(aux_json->>'column_id')||' ORDER BY orderby) a WHERE widgettype = 2'
				INTO combo_rows_child
				USING p_table_id;
				combo_rows_child := COALESCE(combo_rows_child, '{}');
			
			FOREACH aux_json_child IN ARRAY combo_rows_child
			LOOP

				SELECT (json_array_elements(array_to_json(fields_array[(aux_json->> 'orderby')::INT:(aux_json->> 'orderby')::INT])))->>'selectedId' INTO v_selected_id;

				-- Get combo id's
				IF (aux_json_child->>'dv_querytext_filterc') IS NOT NULL AND v_selected_id IS NOT NULL THEN		
					query_text= 'SELECT array_to_json(array_agg(id)) FROM ('||(aux_json_child->>'dv_querytext')||(aux_json_child->>'dv_querytext_filterc')||' '||quote_literal(v_selected_id)||' ORDER BY idval) a';
					execute query_text INTO combo_json_child;
				ELSE 	
					EXECUTE 'SELECT array_to_json(array_agg(id)) FROM ('||(aux_json_child->>'dv_querytext')||' ORDER BY idval)a' INTO combo_json_child;
				END IF;
					
				-- Update array
				fields_array[(aux_json_child->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json_child->>'orderby')::INT], 'comboIds', COALESCE(combo_json_child, '[]'));
				fields_array[(aux_json_child->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json_child->>'orderby')::INT], 'selectedId', combo_json_child->>'value');      
				
				-- Get combo values
				IF (aux_json_child->>'dv_querytext_filterc') IS NOT NULL AND (aux_json->> 'selectedId') IS NOT NULL THEN
					query_text= 'SELECT array_to_json(array_agg(idval)) FROM ('||(aux_json_child->>'dv_querytext')||(aux_json_child->>'dv_querytext_filterc')||' '||quote_literal(v_selected_id)||' ORDER BY idval) a';
					execute query_text INTO combo_json_child;
				ELSE 	
					EXECUTE 'SELECT array_to_json(array_agg(idval)) FROM ('||(aux_json_child->>'dv_querytext')||' ORDER BY idval)a'
						INTO combo_json_child;
				END IF;

				combo_json_child := COALESCE(combo_json_child, '[]');
			
				-- Update array
				fields_array[(aux_json_child->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json_child->>'orderby')::INT], 'comboNames', combo_json_child);
			END LOOP;
		END IF;
	END LOOP;
	  
--     Convert to json
       fields := array_to_json(fields_array);
       fields := COALESCE(fields, '[]');    
      
        -- Add tab name to json
        tabUser := ('{"fields":' || fields || '}')::json;
        tabUser := gw_fct_json_object_set_key(tabUser, 'tabName', 'tabUser'::TEXT);
        tabUser := gw_fct_json_object_set_key(tabUser, 'tabLabel', rec_tab.tablabel);
        tabUser := gw_fct_json_object_set_key(tabUser, 'active', v_active::TEXT);

        -- Create tabs array
        v_formtabs := v_formtabs || tabUser::text;

        v_firsttab := TRUE;
        v_active :=FALSE;

    END IF;


-- Admin tab
--------------
    SELECT * INTO rec_tab FROM config_api_form_tabs WHERE formname='config' AND tabname='tabAdmin' ;

    -- only form config forme (epaoptions not need admin tab)
    IF v_formname='config' THEN 
    
	IF rec_tab.tabname IS NOT NULL AND 'role_admin' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) THEN 

		-- Get fields for admin enabled
		EXECUTE 'SELECT (array_agg(row_to_json(a))) FROM (SELECT label, parameter AS column_id, parameter AS name, concat(''admin_'',parameter), value, 
			widgettype, datatype, layout_id, layout_order, orderby, tooltip, TRUE AS iseditable
			FROM config_param_system WHERE isenabled=TRUE ORDER BY orderby) a'
			INTO fields_array;

	ELSE 
		-- Get fields for admin disabled (only to show)
		EXECUTE 'SELECT (array_agg(row_to_json(a))) FROM (SELECT label, parameter AS column_id, parameter AS name, concat(''admin_'',parameter), value, 
			widgettype, datatype, layout_id, layout_order, orderby, tooltip, FALSE AS iseditable
			FROM config_param_system WHERE isenabled=TRUE ORDER BY orderby) a'
			INTO fields_array;
	END IF;

	-- Convert to json
	fields := array_to_json(fields_array);
        fields := COALESCE(fields, '[]');    

        -- Add tab name to json
        v_tabadmin := ('{"fields":' || fields || '}')::json;
        v_tabadmin := gw_fct_json_object_set_key(v_tabadmin, 'tabName', 'tabAdmin'::TEXT);
        v_tabadmin := gw_fct_json_object_set_key(v_tabadmin, 'tabLabel', rec_tab.tablabel);

        v_formtabs := v_formtabs ||','|| v_tabadmin::text;
        
    END IF;
   
--  Finish the construction of v_formtabs
    v_formtabs := v_formtabs ||']';

--  Construction of groupbox - formlayouts
    EXECUTE 'SELECT (array_agg(row_to_json(a))) FROM (SELECT layout_id AS "layout", label FROM config_api_form_groupbox WHERE formname=$1 AND layout_id IN 
			(SELECT layout_id FROM audit_cat_param_user WHERE sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))	
			UNION SELECT layout_id FROM config_param_system WHERE ''role_admin'' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member'')))
		ORDER BY layout_id) a'
		INTO v_formgroupbox
		USING v_formname;

	v_formgroupbox_json := array_to_json(v_formgroupbox);

--    Check null
    v_formtabs := COALESCE(v_formtabs, '[]'); 
    v_formgroupbox_json := COALESCE(v_formgroupbox_json, '[]'); 

--    Return
    RETURN ('{"status":"Accepted", "apiVersion":'||api_version||
             ',"body":{"message":{"priority":1, "text":"This is a test message"}'||
			',"form":{"formName":"", "formLabel":"", "formText":""'|| 
				',"formTabs":'||v_formtabs||
				',"formGroupBox":'||v_formgroupbox_json||
				',"formActions":[]}'||
			',"feature":{}'||
			',"data":{}}'||
	    '}')::json;
       
--    Exception handling
--    EXCEPTION WHEN OTHERS THEN 
        --RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

