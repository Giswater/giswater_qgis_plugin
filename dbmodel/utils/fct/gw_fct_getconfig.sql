/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2570

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_getconfig(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getconfig(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
SELECT "SCHEMA_NAME".gw_fct_getconfig($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{"formName":"epaoptions"},
"feature":{},"data":{}}$$)

SELECT "SCHEMA_NAME".gw_fct_getconfig($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{"formName":"config"},
"feature":{},"data":{}}$$)
*/

DECLARE

v_formtabs text;
combo_json json;
fieldsJson json;
v_version json;
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
v_selected_id text;
query_text text;
aux_json_child json;
v_device integer;
v_formname text;
v_tabadmin json;
v_querytext json;
v_epaversion text;
v_orderby text;
v_editability text;
v_image json;
v_dv_querytext text;
v_array text[];
v_array_child text[];
v_combo_id json;
v_vdefault text;
field_value_parent text;
v_orderby_child text;
v_dv_querytext_child text;
p_tgop text = 'INSERT';
v_layers_name text;
v_layers_table text;

BEGIN

	-- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

	--  get api version	
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
        INTO v_version;

	-- get input parameters
	v_formname := (p_data ->> 'form')::json->> 'formName';
        
	--  Get project type
    SELECT project_type INTO v_project_type FROM sys_version LIMIT 1;

	--  Set epaversion
    IF v_project_type='WS' then
	v_epaversion='2.0.12';
    ELSE
	v_epaversion='5.0.022';
    END IF;
    
	-- Get layers and table names
    v_layers_name = ((p_data ->> 'data')::json->> 'list_layers_name')::text;
    v_layers_table = ((p_data ->> 'data')::json->> 'list_tables_name')::text;

	-- Delete and insert layers and table names into temp_table
    DELETE FROM temp_table where fid=163 and cur_user=current_user;
    INSERT INTO temp_table(fid, text_column, cur_user) VALUES (163, '{"list_layers_name":"'||v_layers_name||'", "list_tables_name":"'||v_layers_table||'"}', current_user);
    
	-- Create tabs array
    v_formtabs := '[';

	-- basic_tab
	-------------------------
    SELECT * INTO rec_tab FROM config_form_tabs WHERE formname='config' AND tabname='tab_user';
    IF rec_tab.tabname IS NOT NULL THEN

		-- Get all parameters from audit_cat param_user
		EXECUTE 'SELECT (array_agg(row_to_json(a))) FROM (
			SELECT label, sys_param_user.id as widgetname, value , datatype, widgettype, layoutorder, layoutname,
			(CASE WHEN iseditable IS NULL OR iseditable IS TRUE THEN True ELSE False END) AS iseditable,
			row_number()over(ORDER BY layoutname, layoutorder) AS orderby, isparent, sys_role, project_type, widgetcontrols,
			(CASE WHEN value IS NOT NULL AND value != ''false'' THEN True ELSE False END) AS checked, placeholder, descript AS tooltip, 
			dv_parent_id, dv_querytext, dv_querytext_filterc, dv_orderby_id, dv_isnullvalue	
			FROM sys_param_user LEFT JOIN (SELECT * FROM config_param_user WHERE cur_user=current_user) a ON a.parameter=sys_param_user.id 
			WHERE sys_role IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))
			AND formname ='||quote_literal(lower(v_formname))||'
			AND (epaversion::json->>''from''= '||quote_literal(v_epaversion)||' or formname !=''epaoptions'')
			AND (project_type =''utils'' or project_type='||quote_literal(lower(v_project_type))||')
			AND isenabled IS TRUE
			ORDER by orderby)a'
				INTO fields_array ;

		fields_array := COALESCE(fields_array, '{}');  

		FOREACH aux_json IN ARRAY fields_array
		LOOP
			
			-- Refactor widget
			IF (aux_json->>'widgettype')='image' THEN
					EXECUTE (aux_json->>'dv_querytext') INTO v_image; 
				fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'imageVal', COALESCE(v_image, '[]'));
			END IF;

			-- setting the not updateable fields
			IF p_tgop ='UPDATE' THEN
				IF (aux_json->>'isnotupdate')::boolean IS TRUE THEN
					fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'isEditable','False');
				END IF;		
			END IF;
			
			-- for image widgets
			IF (aux_json->>'widgettype')='image' THEN
					EXECUTE (aux_json->>'dv_querytext') INTO v_image; 
				fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'imageVal', COALESCE(v_image, '[]'));
			END IF;

			-- looking for parents and for combo not parent
			IF (aux_json->>'isparent')::boolean IS TRUE OR ((aux_json->>'widgettype') = 'combo' AND (aux_json->>'dv_parent_id') IS NULL) THEN

				-- Define the order by column
				IF (aux_json->>'dv_orderby_id')::boolean IS TRUE THEN
					v_orderby='id';
				ELSE 
					v_orderby='idval';
				END IF;

				v_dv_querytext=(aux_json->>'dv_querytext');

				IF (aux_json->>'widgettype') = 'combo' THEN
		
					-- Get combo id's
					EXECUTE 'SELECT (array_agg(id)) FROM ('||v_dv_querytext||' ORDER BY '||v_orderby||')a'
						INTO v_array;
					
					-- Enable null values
					IF (aux_json->>'dv_isnullvalue')::boolean IS TRUE THEN
						v_array = array_prepend('',v_array);
					END IF;
					combo_json = array_to_json(v_array);
					v_combo_id = combo_json;
					fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'comboIds', COALESCE(combo_json, '[]'));		

					-- Get combo values
					EXECUTE 'SELECT (array_agg(idval)) FROM ('||v_dv_querytext||' ORDER BY '||v_orderby||')a'
						INTO v_array;

					-- Enable null values
					IF (aux_json->>'dv_isnullvalue')::boolean IS TRUE THEN
						v_array = array_prepend('',v_array);
					END IF;
					combo_json = array_to_json(v_array);
					fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'comboNames', COALESCE(combo_json, '[]'));

					-- Get selected value
					fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'selectedId', aux_json->>'value');      

				END IF;

				-- looking for childs 
				IF (aux_json->>'isparent')::boolean IS TRUE THEN
				
					FOREACH aux_json_child IN ARRAY fields_array
					LOOP	
						IF (aux_json_child->>'dv_parent_id') = (aux_json->>'widgetname') THEN

							IF (aux_json_child->>'widgettype') = 'combo' THEN
		
								SELECT (json_array_elements(array_to_json(fields_array[(aux_json->> 'orderby')::INT:(aux_json->> 'orderby')::INT])))->>'selectedId' INTO v_selected_id;	

								-- Define the order by column
								IF (aux_json_child->>'dv_orderby_id')::boolean IS TRUE THEN
									v_orderby_child='id';
								ELSE 
									v_orderby_child='idval';
								END IF;	

								-- set false the editability
								v_editability = replace (((aux_json_child->>'widgetcontrols')::json->>'enableWhenParent'), '[', '{');
								v_editability = replace (v_editability, ']', '}');

								IF v_selected_id::text != ANY (v_editability::text[]) THEN
									fields_array[(aux_json_child->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json_child->>'orderby')::INT], 'iseditable', false);
								END IF;
									
								-- Enable null values
								v_dv_querytext_child=(aux_json_child->>'dv_querytext');
							
								-- Get combo id's
								IF (aux_json_child->>'dv_querytext_filterc') IS NOT NULL AND v_selected_id IS NOT NULL THEN		
									query_text= 'SELECT (array_agg(id)) FROM ('|| v_dv_querytext_child || (aux_json_child->>'dv_querytext_filterc')||' '||quote_literal(v_selected_id)||' ORDER BY '||v_orderby_child||') a';
									execute query_text INTO v_array_child;									
								ELSE 	
									EXECUTE 'SELECT (array_agg(id)) FROM ('||(aux_json_child->>'dv_querytext')||' ORDER BY '||v_orderby_child||')a' INTO v_array_child;
									
								END IF;
								
								-- Enable null values
								IF (aux_json_child->>'dv_isnullvalue')::boolean IS TRUE THEN 
									v_array_child = array_prepend('',v_array_child);
								END IF;
								combo_json_child = array_to_json(v_array_child);

								fields_array[(aux_json_child->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json_child->>'orderby')::INT], 'comboIds', COALESCE(combo_json_child, '[]'));
								
								-- Get combo values
								IF (aux_json_child->>'dv_querytext_filterc') IS NOT NULL AND v_selected_id IS NOT NULL THEN
									query_text= 'SELECT (array_agg(idval)) FROM ('|| v_dv_querytext_child ||(aux_json_child->>'dv_querytext_filterc')||' '||quote_literal(v_selected_id)||' ORDER BY '||v_orderby_child||') a';
									execute query_text INTO v_array_child;
								ELSE 	
									EXECUTE 'SELECT (array_agg(idval)) FROM ('||(aux_json_child->>'dv_querytext')||' ORDER BY '||v_orderby_child||')a' INTO v_array_child;
								END IF;
								
								-- Enable null values
								IF (aux_json_child->>'dv_isnullvalue')::boolean IS TRUE THEN 
									v_array_child = array_prepend('',v_array_child);
								END IF;
								
								combo_json_child = array_to_json(v_array_child);
								combo_json_child := COALESCE(combo_json_child, '[]');

								fields_array[(aux_json_child->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json_child->>'orderby')::INT], 'comboNames', combo_json_child);	

								-- Get selected value
								fields_array[(aux_json_child->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json_child->>'orderby')::INT], 'selectedId', (aux_json_child->>'value')::text); 					
			
								--removing the not used fields
								fields_array[(aux_json_child->>'orderby')::INT] := gw_fct_json_object_delete_keys(fields_array[(aux_json_child->>'orderby')::INT],
								'dv_querytext', 'dv_orderby_id', 'dv_isnullvalue', 'dv_parent_id', 'dv_querytext_filterc', 'typeahead');
							
							END IF;
							raise notice 'parent % v_selected_id % aux_json_child %', (aux_json->>'widgetname'), v_selected_id, aux_json_child;
						END IF;
					END LOOP;
				END IF;			    
			END IF;	
				
			--removing the not used fields
			fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_delete_keys(fields_array[(aux_json->>'orderby')::INT],
			'dv_querytext', 'dv_orderby_id', 'dv_isnullvalue', 'dv_parent_id', 'dv_querytext_filterc', 'sys_role', 'project_type');
		
		END LOOP;
		 
		--  Convert to json
		fields := array_to_json(fields_array);
		fields := COALESCE(fields, '[]');    
		  
		-- Add tab name to json
		tabUser := ('{"fields":' || fields || '}')::json;
		tabUser := gw_fct_json_object_set_key(tabUser, 'tabName', 'tabUser'::TEXT);
		tabUser := gw_fct_json_object_set_key(tabUser, 'tabLabel', rec_tab.label);
		tabUser := gw_fct_json_object_set_key(tabUser, 'tooltip', rec_tab.label);
		tabUser := gw_fct_json_object_set_key(tabUser, 'active', v_active::TEXT);

		-- Create tabs array
		v_formtabs := v_formtabs || tabUser::text;

		v_firsttab := TRUE;
		v_active :=FALSE;

    END IF;

	-- Admin tab
	--------------
    SELECT * INTO rec_tab FROM config_form_tabs WHERE formname='config' AND tabname='tab_admin' ;

    -- only form config form (epaoptions not need admin tab)
    IF v_formname='config' THEN 
    
		IF rec_tab.tabname IS NOT NULL AND 'role_admin' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) THEN 

			-- Get fields for admin enabled
			EXECUTE 'SELECT (array_agg(row_to_json(a))) FROM (SELECT label, parameter AS widgetname, parameter as widgetname, concat(''admin_'',parameter), value, 
				widgettype, datatype, layoutname, layoutorder, row_number() over (order by layoutname, layoutorder) as orderby, descript as tooltip,
				(CASE WHEN iseditable IS NULL OR iseditable IS TRUE THEN True ELSE False END) AS iseditable,
				placeholder
				FROM config_param_system WHERE isenabled=TRUE AND layoutname IS NOT NULL AND layoutorder IS NOT NULL AND (project_type =''utils'' or project_type='||quote_literal(lower(v_project_type))||') ORDER BY orderby) a'
				INTO fields_array;

		ELSE 
			-- Get fields for admin disabled (only to show)
			EXECUTE 'SELECT (array_agg(row_to_json(a))) FROM (SELECT label, parameter AS widgetname, parameter as widgetname, concat(''admin_'',parameter), value, 
				widgettype, datatype, layoutname, layoutorder, row_number() over (order by layoutname, layoutorder) as orderby, descript as tooltip, FALSE AS iseditable,
				placeholder
				FROM config_param_system WHERE isenabled=TRUE AND (project_type =''utils'' or project_type='||quote_literal(lower(v_project_type))||') ORDER BY orderby) a'
				INTO fields_array;
		END IF;

		-- Convert to json
		fields := array_to_json(fields_array);
		fields := COALESCE(fields, '[]');    
	
        -- Add tab name to json
        v_tabadmin := ('{"fields":' || fields || '}')::json;
        v_tabadmin := gw_fct_json_object_set_key(v_tabadmin, 'tabName', 'tabAdmin'::TEXT);
        v_tabadmin := gw_fct_json_object_set_key(v_tabadmin, 'tabLabel', rec_tab.label);
        v_tabadmin := gw_fct_json_object_set_key(v_tabadmin, 'tooltip', rec_tab.tooltip);

        v_formtabs := v_formtabs ||','|| v_tabadmin::text;
        
    END IF;

	--  Finish the construction of v_formtabs
    v_formtabs := v_formtabs ||']';


	-- Check null
    v_version := COALESCE(v_version, '[]');
    v_formtabs := COALESCE(v_formtabs, '[]'); 

	-- Return
    RETURN ('{"status":"Accepted", "version":'||v_version||
             ',"body":{"message":{"level":1, "text":"This is a test message"}'||
			',"form":{"formName":"", "formLabel":"", "formText":""'|| 
				',"formTabs":'||v_formtabs||
				',"formActions":[]}'||
			',"feature":{}'||
			',"data":{}}'||
	    '}')::json;
       
	-- Exception handling
--EXCEPTION WHEN OTHERS THEN 
    --RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "version":'|| v_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

