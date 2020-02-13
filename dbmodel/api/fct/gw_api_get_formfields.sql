/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2562

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_get_formfields(
    p_formname character varying,
    p_formtype character varying,
    p_tabname character varying,
    p_tablename character varying,
    p_idname character varying,
    p_id character varying,
    p_columntype character varying,
    p_tgop character varying,
    p_filterfield character varying,
    p_device integer)
  RETURNS text[] AS
$BODY$

/*EXAMPLE
SELECT "SCHEMA_NAME".gw_api_get_formfields('visit_arc_insp', 'visit', 'data', NULL, NULL, NULL, NULL, 'INSERT', null, 3)
only 32
SELECT "SCHEMA_NAME".gw_api_get_formfields('go2epa', 'form', 'data', null, null, null, null, null, null,null)
SELECT "SCHEMA_NAME".gw_api_get_formfields('ve_arc_pipe', 'feature', 'data', NULL, NULL, NULL, NULL, 'INSERT', null, 3)
SELECT "SCHEMA_NAME".gw_api_get_formfields('ve_arc_pipe', 'list', NULL, NULL, NULL, NULL, NULL, 'INSERT', null, 3)
SELECT "SCHEMA_NAME".gw_api_get_formfields( 'printGeneric', 'utils', 'data', null, null, null, null, 'SELECT', null, 3);

*/


DECLARE
--    Variables
    fields json;
    fields_array json[];
    aux_json json;    
    aux_json_child json;    
    combo_json json;
    combo_json_child json;
    schemas_array name[];
    array_index integer DEFAULT 0;
    field_value character varying;
    field_value_parent text;
    api_version json;
    v_selected_id text;
    query_text text;
    v_vdefault text;
    v_query_text text;
    v_id int8;
    v_project_type varchar;
    v_return json;
    v_combo_id json;
    v_orderby_child text;
    v_orderby text;
    v_dv_querytext_child text;
    v_dv_querytext text;
    v_dv_querytext_filterc text;
    v_image json;
    v_bmapsclient boolean;
    v_array text[];
    v_array_child text[];
    v_min float;
    v_max float;
    v_widgetcontrols json;
    v_noderecord1 record;
    v_noderecord2 record;
    v_input json;
       
BEGIN

--   Set search path to local schema
     SET search_path = "SCHEMA_NAME", public;

--   Get schema name
     schemas_array := current_schemas(FALSE);

--   get api version
     EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
	INTO api_version;

--   get project type
     SELECT wsoftware INTO v_project_type FROM version LIMIT 1;
     SELECT value INTO v_bmapsclient FROM config_param_system WHERE parameter = 'api_bmaps_client';

--   setting tabname
     IF p_tabname IS NULL THEN
	p_tabname = 'tabname';
     END IF;

--   Get fields	
	IF p_formname!='infoplan' THEN 
		EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT label, column_id, concat('||quote_literal(p_tabname)||',''_'',column_id) AS widgetname, widgettype,

			widgettype as type, column_id as name, datatype AS "dataType",widgetfunction as "widgetAction", widgetfunction as "updateAction",widgetfunction as "changeAction", widgetfunction,
			(CASE WHEN layout_id=0 THEN ''header'' WHEN layout_id=9 THEN ''footer'' ELSE ''body'' END) AS "position",
			(CASE WHEN iseditable=true THEN false ELSE true END)  AS disabled, hidden,

			widgetdim, datatype , tooltip, placeholder, iseditable, row_number()over(ORDER BY layout_id, layout_order) AS orderby, layout_id, 
			layout_name as layoutname, layout_order, dv_parent_id, isparent, ismandatory, action_function, dv_querytext, dv_querytext_filterc, 
			isautoupdate, isnotupdate, dv_orderby_id, dv_isnullvalue, reload_field, stylesheet, typeahead, widgetcontrols, reload_field FROM config_api_form_fields WHERE formname = $1 AND formtype= $2 
			AND isenabled IS TRUE ORDER BY orderby) a'
				INTO fields_array
				USING p_formname, p_formtype;

	ELSE
		EXECUTE 'SELECT array_agg(row_to_json(b)) FROM (
			SELECT (row_number()over(ORDER BY 1)) AS layout_order, (row_number()over(ORDER BY 1)) AS orderby,* FROM 
			(SELECT ''individual'' as widtget_context, concat(unit, ''. '', descript) AS label, identif AS column_id, ''label'' AS widgettype, concat ('||quote_literal(p_tabname)||',''_'',identif) AS widgetname, ''string'' AS datatype, 
			NULL AS tooltip, NULL AS placeholder, FALSE AS iseditable, orderby as ordby, 1 AS layout_id,  NULL AS dv_parent_id, NULL AS isparent, NULL as ismandatory, NULL AS button_function, NULL AS dv_querytext, 
			NULL AS dv_querytext_filterc, NULL AS action_function, NULL AS isautoupdate, concat (measurement,'' '',unit,'' x '', cost , '' €/'',unit,'' = '', total_cost::numeric(12,2), '' €'') as value, null as stylesheet,
			null as widgetcontrols, null as hidden
			FROM ' ||p_tablename|| ' WHERE ' ||p_idname|| ' = $2
			UNION
			SELECT ''resumen'' as widtget_context, label AS form_label, column_id, widgettype, concat ('||quote_literal(p_tabname)||',''_'',column_id) AS widgetname, datatype, 
			tooltip, placeholder, iseditable, layout_order AS ordby, layout_id,  NULL AS dv_parent_id, NULL AS isparent, ismandatory,  NULL AS widgetfunction, NULL AS dv_querytext, 
			NULL AS dv_querytext_filterc, NULL AS action_function, NULL AS isautoupdate, null as value, null as stylesheet, widgetcontrols::text, hidden
			FROM config_api_form_fields WHERE formname  = ''infoplan'' AND isenabled IS TRUE ORDER BY 1,ordby) a
			ORDER BY 1) b'
				INTO fields_array
				USING p_formname, p_id ;
	END IF;
	
	fields_array := COALESCE(fields_array, '{}');  

	FOREACH aux_json IN ARRAY fields_array
	LOOP
	
		-- setting the typeahead widgets
		IF (aux_json->>'typeahead') IS NOT NULL THEN
				fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'fieldToSearch', COALESCE(((aux_json->>'typeahead')::json->>'fieldToSearch'), ''));
				fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'threshold', ((aux_json->>'typeahead')::json->>'threshold'));
				fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'noresultsMsg', ((aux_json->>'typeahead')::json->>'noresultsMsg'));
				fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'loadingMsg', ((aux_json->>'typeahead')::json->>'loadingMsg'));
				fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'queryText', COALESCE((aux_json->>'dv_querytext'), ''));
				fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'queryTextFilter', COALESCE((aux_json->>'dv_querytext_filterc'), ''));
				fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'parentId', COALESCE((aux_json->>'dv_parent_id'), ''));
				fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'isNullValue', (aux_json->>'dv_isnullvalue'));
				fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'orderById', (aux_json->>'dv_orderby_id'));
		END IF;


		-- Refactor widget
		IF (aux_json->>'widgettype')='image' THEN
		      	EXECUTE (aux_json->>'dv_querytext') INTO v_image; 
			fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'imageVal', COALESCE(v_image, '[]'));
		END IF;
			
		-- for image widgets
		IF (aux_json->>'widgettype')='image' THEN
		      	EXECUTE (aux_json->>'dv_querytext') INTO v_image; 
			fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'imageVal', COALESCE(v_image, '[]'));
		END IF;

		--setting widgetcontrols when null (user has not configurated form fields table)
		IF (aux_json->>'widgetcontrols') IS NULL THEN
			v_input = '{"client":{"device":3,"infoType":100,"lang":"es"}, "feature":{"tableName":"'||p_tablename||'", "id":"'||p_id||'"}, "data":{"tgOp":"'||p_tgop||'","json":'||aux_json||'}}';		
			SELECT gw_api_get_widgetcontrols (v_input) INTO v_widgetcontrols;
			fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'widgetcontrols', COALESCE(v_widgetcontrols, '{}'));
		END IF;

		IF p_tgop ='UPDATE' THEN

			-- setting the not updateable fields
			IF (aux_json->>'isnotupdate')::boolean IS TRUE THEN
				fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'isEditable','False');
			END IF;		
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
			v_dv_querytext_filterc=(aux_json->>'dv_querytext_filterc');

			IF (aux_json->>'widgettype') = 'combo' THEN
				
				-- Get combo id's
				-- If widget is combo, parent or not child, execute if exist "dv_querytext_filterc" anyway.
				IF v_dv_querytext_filterc IS NOT NULL AND p_id != '' THEN
					EXECUTE 'SELECT (array_agg(id)) FROM ('|| v_dv_querytext || v_dv_querytext_filterc ||' '||quote_literal(p_tablename)||') ORDER BY '||v_orderby||')a'
					INTO v_array;
				ELSE
					EXECUTE 'SELECT (array_agg(id)) FROM ('|| v_dv_querytext ||' ORDER BY '||v_orderby||')a'
					INTO v_array;
				END IF;
				
				-- Enable null values
				IF (aux_json->>'dv_isnullvalue')::boolean IS TRUE THEN
					v_array = array_prepend('',v_array);
				END IF;
				combo_json = array_to_json(v_array);
				v_combo_id = combo_json;
				fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'comboIds', COALESCE(combo_json, '[]'));		

				-- Get combo values
				-- If widget is combo, parent or not child, execute if exist "dv_querytext_filterc" anyway.
				IF v_dv_querytext_filterc IS NOT NULL AND p_id != '' THEN
					EXECUTE 'SELECT (array_agg(idval)) FROM ('|| v_dv_querytext || v_dv_querytext_filterc ||' '||quote_literal(p_tablename)||') ORDER BY '||v_orderby||')a'
					INTO v_array;
				ELSE
					EXECUTE 'SELECT (array_agg(idval)) FROM ('||v_dv_querytext||' ORDER BY '||v_orderby||')a'
					INTO v_array;
				END IF;

				-- Enable null values
				IF (aux_json->>'dv_isnullvalue')::boolean IS TRUE THEN
					v_array = array_prepend('',v_array);
				END IF;
				combo_json = array_to_json(v_array);
				fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'comboNames', COALESCE(combo_json, '[]'));

				-- Get selected value
				IF (p_tgop ='UPDATE' OR p_tgop = 'SELECT') AND aux_json->>'column_id' IS NOT NULL AND p_tablename IS NOT NULL 
									   AND p_idname IS NOT NULL AND p_id IS NOT NULL AND p_columntype IS NOT NULL THEN
					EXECUTE 'SELECT ' || quote_ident(aux_json->>'column_id') || ' FROM ' || quote_ident(p_tablename) || ' WHERE ' || quote_ident(p_idname) ||
					 ' = CAST(' || quote_literal(p_id) || ' AS ' || COALESCE(p_columntype, 'character varying') || ')' 
						INTO field_value_parent; 
				ELSIF p_tgop ='INSERT' OR p_tgop = 'SELECT' THEN
					v_vdefault:=quote_ident(aux_json->>'column_id');
					EXECUTE 'SELECT value::text FROM audit_cat_param_user JOIN config_param_user ON audit_cat_param_user.id=parameter WHERE cur_user=current_user AND feature_field_id='||quote_literal(v_vdefault)
						INTO field_value_parent;
				
				END IF;

				IF v_vdefault IS NULL THEN
					IF p_filterfield is not null THEN
						fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'selectedId', p_filterfield);
					ELSE	
						fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'selectedId', v_combo_id->0);
					END IF;
				ELSE
					fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'selectedId', v_vdefault);
				END IF;

			END IF;

			IF field_value_parent IS NULL THEN
				IF p_filterfield is not null THEN
					fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'selectedId', p_filterfield);
				ELSE
					fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'selectedId', v_combo_id->0);
				END IF;
			ELSE
				fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'selectedId', field_value_parent);
			END IF;

			-- looking for childs 
			IF (aux_json->>'isparent')::boolean IS TRUE THEN
			
				FOREACH aux_json_child IN ARRAY fields_array
				LOOP	
					IF (aux_json_child->>'dv_parent_id') = (aux_json->>'column_id') THEN

					   IF (aux_json_child->>'widgettype') = 'combo' THEN

						SELECT (json_array_elements(array_to_json(fields_array[(aux_json->> 'orderby')::INT:(aux_json->> 'orderby')::INT])))->>'selectedId' INTO v_selected_id;	

						-- Define the order by column
						IF (aux_json_child->>'dv_orderby_id')::boolean IS TRUE THEN
							v_orderby_child='id';
						ELSE 
							v_orderby_child='idval';
						END IF;	
								
						-- Enable null values
						v_dv_querytext_child=(aux_json_child->>'dv_querytext');
						
						-- Get combo id's
						
						IF (aux_json_child->>'dv_querytext_filterc') IS NOT NULL AND v_selected_id IS NOT NULL AND p_id != '' AND (field_value_parent IS NOT NULL /*AND p_filterfield IS NOT NULL*/) THEN	
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
						IF (aux_json_child->>'dv_querytext_filterc') IS NOT NULL AND v_selected_id IS NOT NULL AND p_id != '' AND (field_value_parent IS NOT NULL /*AND p_filterfield IS NOT NULL*/) THEN
							query_text= 'SELECT (array_agg(idval)) FROM ('|| v_dv_querytext_child ||(aux_json_child->>'dv_querytext_filterc')||' '||quote_literal(v_selected_id)||' ORDER BY '||v_orderby_child||') a';
							execute query_text INTO v_array_child;
						ELSE 	
							EXECUTE 'SELECT (array_agg(idval)) FROM ('||(aux_json_child->>'dv_querytext')||' ORDER BY '||v_orderby_child||')a'
								INTO v_array_child;
						END IF;
						
						-- Enable null values
						IF (aux_json_child->>'dv_isnullvalue')::boolean IS TRUE THEN 
							v_array_child = array_prepend('',v_array_child);
						END IF;
						combo_json_child = array_to_json(v_array_child);


						combo_json_child := COALESCE(combo_json_child, '[]');
						fields_array[(aux_json_child->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json_child->>'orderby')::INT], 'comboNames', combo_json_child);								
						-- Get selected value
						IF (p_tgop ='UPDATE' OR p_tgop = 'SELECT') AND aux_json->>'column_id' IS NOT NULL AND p_tablename IS NOT NULL 
									   AND p_idname IS NOT NULL AND p_id IS NOT NULL AND p_columntype IS NOT NULL THEN
							EXECUTE 'SELECT ' || quote_ident(aux_json_child->>'column_id') || ' FROM ' || quote_ident(p_tablename) || ' WHERE ' || quote_ident(p_idname) || ' = CAST(' ||
							 quote_literal(p_id) || ' AS ' || p_columntype || ')' 
							INTO v_vdefault; 
						ELSIF p_tgop ='INSERT' OR p_tgop = 'SELECT' THEN
							IF quote_ident(aux_json_child->>'column_id') = 'state_type' AND field_value_parent  = '0' THEN
								EXECUTE 'SELECT value::text FROM audit_cat_param_user JOIN config_param_user ON audit_cat_param_user.id=parameter WHERE cur_user=current_user AND parameter = ''statetype_end_vdefault'''
								INTO v_vdefault;													
							
							ELSIF quote_ident(aux_json_child->>'column_id') = 'state_type' AND field_value_parent  = '1' THEN
								EXECUTE 'SELECT value::text FROM audit_cat_param_user JOIN config_param_user ON audit_cat_param_user.id=parameter WHERE cur_user=current_user AND parameter = ''statetype_vdefault'''
								INTO v_vdefault;
							
							ELSIF quote_ident(aux_json_child->>'column_id') = 'state_type' AND field_value_parent  = '2' THEN
								EXECUTE 'SELECT value::text FROM audit_cat_param_user JOIN config_param_user ON audit_cat_param_user.id=parameter WHERE cur_user=current_user AND parameter = ''statetype_plan_vdefault'''
								INTO v_vdefault;

							ELSE
								v_vdefault:=quote_ident(aux_json_child->>'column_id');
								EXECUTE 'SELECT value::text FROM audit_cat_param_user JOIN config_param_user ON audit_cat_param_user.id=parameter WHERE cur_user=current_user AND feature_field_id='||
								quote_literal(v_vdefault)
								INTO v_vdefault;													
							END IF;

						END IF;

						IF v_vdefault IS NULL THEN
							fields_array[(aux_json_child->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json_child->>'orderby')::INT], 'selectedId', v_combo_id->0);
						ELSE
							fields_array[(aux_json_child->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json_child->>'orderby')::INT], 'selectedId', v_vdefault);
						END IF;

						--removing the not used fields
						fields_array[(aux_json_child->>'orderby')::INT] := gw_fct_json_object_delete_keys(fields_array[(aux_json_child->>'orderby')::INT],
						'dv_querytext', 'dv_orderby_id', 'dv_isnullvalue', 'dv_parent_id', 'dv_querytext_filterc', 'typeahead');

						RAISE NOTICE ' SD %', v_vdefault;

						RAISE NOTICE ' SD %', fields_array[(aux_json_child->>'orderby')::INT];
						
					  END IF;
				END IF;
			END LOOP;
		    END IF;			    
		END IF;	
		
	--removing the not used fields
	fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_delete_keys(fields_array[(aux_json->>'orderby')::INT],
	'dv_querytext', 'dv_orderby_id', 'dv_isnullvalue', 'dv_parent_id', 'dv_querytext_filterc', 'typeahead');
	
	END LOOP;

--    Convert to json
    fields := array_to_json(fields_array);


--    Control NULL's
      api_version := COALESCE(api_version, '[]');
      fields := COALESCE(fields, '[]');    
    
--   WARNING: In spite this function allows to the API, due it's a intermediate function, never will be called on directy and due this don't returns JSON and dont' have the control json format
	
--    Return
      RETURN (fields_array);

--    Exception handling
 --   EXCEPTION WHEN OTHERS THEN 
   --     RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

