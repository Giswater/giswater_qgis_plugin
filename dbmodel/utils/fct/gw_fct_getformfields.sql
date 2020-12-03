/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2562

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_get_formfields(character varying, character varying, character varying, 
character varying, character varying, character varying, character varying, character varying, character varying, integer);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_get_formfields(character varying, character varying, character varying, 
character varying, character varying, character varying, character varying, character varying, character varying, integer, json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getformfields(
    p_formname character varying,
    p_formtype character varying,
    p_tabname character varying,
    p_tablename character varying,
    p_idname character varying,
    p_id character varying,
    p_columntype character varying,
    p_tgop character varying,
    p_filterfield character varying,
    p_device integer,
    p_values_array json)
  RETURNS text[] AS
$BODY$


/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_getformfields( 've_arc_pipe','form_feature','data','ve_arc_pipe','arc_id',	'2088','character varying(16)',	'UPDATE',	1,	'4',	'{}' )
SELECT SCHEMA_NAME.gw_fct_getformfields('visit_arc_insp', 'form_visit', 'data', NULL,	 NULL, 		NULL, 	NULL, 			'INSERT', 	null, 	3,	null)
SELECT "SCHEMA_NAME".gw_fct_getformfields('go2epa', 'form_generic', 'data', null, null, null, null, null, null,null, '{}')
SELECT "SCHEMA_NAME".gw_fct_getformfields('ve_arc_conduit', 'form_feature', 'data', 've_arc_conduit', 'arc_id', '2001', NULL, 'SELECT', null, 4, NULL)
SELECT "SCHEMA_NAME".gw_fct_getformfields('ve_arc_pipe', 'form_feature', NULL, NULL, NULL, NULL, NULL, 'INSERT', null, 4, '{}')
SELECT "SCHEMA_NAME".gw_fct_getformfields( 'print', 'form_generic', 'data', null, null, null, null, 'SELECT', null, 3);

PERFORM gw_fct_debug(concat('{"data":{"msg":"----> INPUT FOR gw_fct_getformfields: ", "variables":"',v_debug,'"}}')::json);
PERFORM gw_fct_debug(concat('{"data":{"msg":"<---- OUTPUT FOR gw_fct_getformfields: ", "variables":"',v_debug,'"}}')::json);
UPDATE config_param_user SET value =  'true' WHERE parameter = 'utils_debug_mode' and cur_user = current_user;
*/

DECLARE
fields json;
fields_array json[];
aux_json json;    
combo_json json;
schemas_array name[];
array_index integer DEFAULT 0;
field_value character varying;
v_version json;
v_selected_id text;
query_text text;
v_vdefault text;
v_id int8;
v_project_type varchar;
v_return json;
v_combo_id json;
v_orderby text;
v_image json;
v_array text[];
v_widgetvalue json;
v_input json;
v_editability text;
v_label text;     
v_clause text;
v_device text;
v_debug boolean;
v_debug_var text;
       
BEGIN
	
	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	
	-- Get schema name
	schemas_array := current_schemas(FALSE);

	-- get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
	INTO v_version;

	-- get project type
	SELECT project_type INTO v_project_type FROM sys_version LIMIT 1;
	SELECT value::boolean INTO v_debug FROM config_param_user WHERE parameter='utils_debug_mode';

	IF v_debug = TRUE THEN
		v_debug_var = (SELECT jsonb_build_object('formname',  p_formname,'formtype',   p_formtype, 'tabname', p_tabname,'tablename', p_tablename, 'idname', p_idname,
		'id',p_id, 'columntype', p_columntype, 'tgop', p_tgop, 'filterfield', p_filterfield, 'device', p_device, 'values_array', p_values_array	));

		PERFORM gw_fct_debug(concat('{"data":{"msg":"----> INPUT FOR gw_fct_getformfields: ", "variables":',v_debug_var,'}}')::json);
	END IF;

	-- setting tabname
	IF p_tabname IS NULL THEN
		p_tabname = 'tabname';
	END IF;
	
	--setting v_clause in function of info type
	IF p_tgop = 'LAYER' THEN -- used when geinfofromid is called on initproject to shape all widgets on table of attributes (id is null)
		v_clause = '';
	ELSE  -- used always for each feature when geinfofromid is called feature by feature
		v_clause = 'AND hidden IS NOT TRUE';
	END IF;

	-- setting device
	IF p_device IN (1,2,3) THEN
		v_device = ' b.camelstyle AS type, columnname AS name, datatype AS "dataType", a.camelstyle AS "widgetAction", a.camelstyle as "updateAction", a.camelstyle as "changeAction",
		     (CASE WHEN layoutname=''0'' THEN ''header'' WHEN layoutname=''9'' THEN ''footer'' ELSE ''body'' END) AS "position",
		     (CASE WHEN iseditable=true THEN false ELSE true END)  AS disabled,';     
	ELSE 
		v_device = '';
	END IF;

	-- get user variable to show label as column id or not
	IF (SELECT value::boolean FROM config_param_user WHERE parameter = 'utils_formlabel_show_columname' AND cur_user =  current_user) THEN
		v_label = 'columnname AS label';
	ELSE
		v_label = 'label';
	END IF;

	-- starting process - get fields	
	IF p_formname!='infoplan' THEN 
		
		EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (
			
			WITH typevalue AS (SELECT * FROM config_typevalue)
		
			SELECT '||v_label||', columnname, concat('||quote_literal(p_tabname)||',''_'',columnname) AS widgetname, widgettype,
			widgetfunction, '||v_device||' hidden, widgetdim, datatype , tooltip, placeholder, iseditable, row_number()over(ORDER BY layoutname, layoutorder) AS orderby,
			layoutname, layoutorder, dv_parent_id AS "parentId", isparent, ismandatory, linkedaction, dv_querytext AS "queryText", dv_querytext_filterc AS "queryTextFilter", isautoupdate,
			dv_orderby_id AS "orderById", dv_isnullvalue AS "isNullValue", stylesheet, widgetcontrols
			FROM config_form_fields 
			LEFT JOIN typevalue a ON a.id = widgetfunction AND a.typevalue = ''widgetfunction_typevalue''
			LEFT JOIN typevalue b ON b.id = widgettype AND b.typevalue = ''widgettype_typevalue''
			
			WHERE formname = $1 AND formtype= $2 '||v_clause||' ORDER BY orderby) a'
				INTO fields_array
				USING p_formname, p_formtype;

	ELSE
		EXECUTE 'SELECT array_agg(row_to_json(b)) FROM (
			SELECT (row_number()over(ORDER BY 1)) AS layoutorder, (row_number()over(ORDER BY 1)) AS orderby, * FROM
				(SELECT concat(unit, ''. '', descript) AS label, identif AS columnname, ''label'' AS widgettype,
				concat ('||quote_literal(p_tabname)||',''_'',identif) AS widgetname, ''string'' AS datatype, 
				NULL AS tooltip, NULL AS placeholder, FALSE AS iseditable, orderby as layoutorder, ''lyt_plan_1'' AS layoutname,  NULL AS dv_parent_id,
				NULL AS isparent, NULL as ismandatory, NULL AS button_function, NULL AS dv_querytext, 
				NULL AS dv_querytext_filterc, NULL AS linkedaction, NULL AS isautoupdate, concat (measurement,'' '',unit,'' x '', cost , 
				'' €/'',unit,'' = '', total_cost::numeric(12,2), '' €'') as value, null as stylesheet,
				null as widgetcontrols, null as hidden
				FROM ' ||p_tablename|| ' WHERE ' ||p_idname|| ' = $2
			UNION
				SELECT label, columnname, widgettype,
				concat ('||quote_literal(p_tabname)||',''_'',columnname) AS widgetname, datatype,
				tooltip, placeholder, iseditable, layoutorder+100 as layoutorder, ''lyt_plan_1'' as layoutname,  NULL AS dv_parent_id, NULL AS isparent, ismandatory,
				NULL AS widgetfunction, NULL AS dv_querytext, 
				NULL AS dv_querytext_filterc, NULL AS linkedaction, NULL AS isautoupdate, null as value, null as stylesheet, widgetcontrols::text, hidden
				FROM config_form_fields WHERE formname  = ''infoplan'' ORDER BY layoutname, layoutorder) a
			ORDER BY 1) b'
			INTO fields_array
			USING p_formname, p_id ;
	END IF;
	
	fields_array := COALESCE(fields_array, '{}');  

	-- for image widgets
	FOR aux_json IN SELECT * FROM json_array_elements(array_to_json(fields_array)) AS a WHERE a->>'widgettype' = 'image' 
	LOOP
      		fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'imageVal', COALESCE((aux_json->>'queryText'), ''));
      		fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_delete_keys(fields_array[(aux_json->>'orderby')::INT], 
      		'queryText', 'orderById', 'isNullValue', 'parentId', 'queryTextFilter');
	END LOOP;


	-- combo no childs	
	FOR aux_json IN SELECT * FROM json_array_elements(array_to_json(fields_array)) AS a WHERE a->>'widgettype' = 'combo' AND  a->>'parentId' IS NULL
	LOOP
		-- Define the order by column
		IF (aux_json->>'orderById')::boolean IS TRUE THEN
			v_orderby='id';
		ELSE 
			v_orderby='idval';
		END IF;
			
		-- Get combo id's
		IF  (aux_json->>'queryText') IS NOT NULL THEN
			EXECUTE 'SELECT (array_agg(id)) FROM ('|| (aux_json->>'queryText') ||' ORDER BY '||v_orderby||')a' INTO v_array;
		END IF;
		
		-- Enable null values
		IF (aux_json->>'isNullValue')::boolean IS TRUE THEN
			v_array = array_prepend('',v_array);
		END IF;
		combo_json = array_to_json(v_array);
		v_combo_id = combo_json;
		fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'comboIds', COALESCE(combo_json, '[]'));		

		-- Get combo values
		IF  (aux_json->>'queryText') IS NOT NULL THEN
			EXECUTE 'SELECT (array_agg(idval)) FROM ('||(aux_json->>'queryText')||' ORDER BY '||v_orderby||')a' INTO v_array;
		END IF;
		
		-- Enable null values
		IF (aux_json->>'isNullValue')::boolean IS TRUE THEN
			v_array = array_prepend('',v_array);
		END IF;
		combo_json = array_to_json(v_array);
		fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'comboNames', COALESCE(combo_json, '[]'));

		--removing the not used keys
		fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_delete_keys(fields_array[(aux_json->>'orderby')::INT],
		'queryText', 'orderById', 'isNullValue', 'parentId', 'queryTextFilter');

	END LOOP;

	-- combo childs
	FOR aux_json IN SELECT * FROM json_array_elements(array_to_json(fields_array)) AS a WHERE a->>'widgettype' = 'combo' AND  a->>'parentId' IS NOT NULL
	LOOP
		-- Get selected value from parent
		IF p_tgop ='INSERT' THEN
			IF (aux_json->>'parentId') = 'expl_id' THEN -- specific case for exploitation as parent mapzone
				v_selected_id = (SELECT value FROM config_param_user WHERE parameter = 'edit_exploitation_vdefault' AND cur_user = current_user);

			ELSIF (aux_json->>'parentId') = 'muni_id' THEN -- specific case for exploitation as parent mapzone
				v_selected_id = (SELECT value FROM config_param_user WHERE parameter = 'edit_municipality_vdefault' AND cur_user = current_user);

			ELSE 
				EXECUTE 'SELECT value::text FROM sys_param_user JOIN config_param_user ON sys_param_user.id=parameter 
					WHERE cur_user=current_user AND feature_field_id='||quote_literal(quote_ident(aux_json->>'parentId'))
					INTO v_selected_id;
			END IF;	

		ELSIF (p_tgop ='UPDATE' OR p_tgop = 'SELECT') THEN
			v_selected_id := p_values_array->>(aux_json->>'parentId');	
			
		END IF;	
	
		-- Define the order by column
		IF (aux_json->>'orderById')::boolean IS TRUE THEN
			v_orderby='id';
		ELSE 
			v_orderby='idval';
		END IF;	

		-- Get combo id's
		IF (aux_json->>'queryTextFilter') IS NOT NULL AND v_selected_id IS NOT NULL THEN
			
			EXECUTE 'SELECT (array_agg(id)) FROM ('|| (aux_json->>'queryText') ||(aux_json->>'queryTextFilter')||'::text = '||quote_literal(v_selected_id)
			||' ORDER BY '||v_orderby||') a'
			INTO v_array;
		ELSE 	
			EXECUTE 'SELECT (array_agg(id)) FROM ('||(aux_json->>'queryText')||' ORDER BY '||v_orderby||')a' INTO v_array;
			
		END IF;

		-- set false the editability
		v_editability = replace (((aux_json->>'widgetcontrols')::json->>'enableWhenParent'), '[', '{');
		v_editability = replace (v_editability, ']', '}');

		IF v_selected_id::text != ANY (v_editability::text[]) THEN
			fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'iseditable', false);
		END IF;
		
		-- Enable null values
		IF (aux_json->>'dv_isnullvalue')::boolean IS TRUE THEN 
			v_array = array_prepend('',v_array);
		END IF;
		combo_json = array_to_json(v_array);
		
		fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'comboIds', COALESCE(combo_json, '[]'));
		
		-- Get combo values
		IF (aux_json->>'queryTextFilter') IS NOT NULL AND v_selected_id IS NOT NULL THEN
			EXECUTE 'SELECT (array_agg(idval)) FROM ('|| (aux_json->>'queryText') ||(aux_json->>'queryTextFilter')||'::text = '||quote_literal(v_selected_id)
			||' ORDER BY '||v_orderby||') a'
			INTO v_array;
		ELSE 	
			EXECUTE 'SELECT (array_agg(idval)) FROM ('||(aux_json->>'queryText')||' ORDER BY '||v_orderby||')a'
				INTO v_array;
		END IF;
	
		-- Enable null values
		IF (aux_json->>'dv_isnullvalue')::boolean IS TRUE THEN 
			v_array = array_prepend('',v_array);
		END IF;
		combo_json = array_to_json(v_array);

		combo_json := COALESCE(combo_json, '[]');
		fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'comboNames', combo_json);		
		
		--removing the not used keys
		fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_delete_keys(fields_array[(aux_json->>'orderby')::INT],
		'queryText', 'orderById', 'isNullValue', 'parentId', 'queryTextFilter');
	END LOOP;


	-- for the rest of widgets removing the not used keys
	FOR aux_json IN SELECT * FROM json_array_elements(array_to_json(fields_array)) AS a WHERE a->>'widgettype' NOT IN ('image', 'combo', 'typeahead')
	LOOP
		fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_delete_keys(fields_array[(aux_json->>'orderby')::INT], 
		'queryText', 'orderById', 'isNullValue', 'parentId', 'queryTextFilter');
	END LOOP;
	
	-- Convert to json
	fields := array_to_json(fields_array);
	
	PERFORM gw_fct_debug(concat('{"data":{"msg":"<---- OUTPUT FOR gw_fct_getformfields: ", "variables":""}}')::json);
	 
	-- Return
	RETURN fields_array;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;