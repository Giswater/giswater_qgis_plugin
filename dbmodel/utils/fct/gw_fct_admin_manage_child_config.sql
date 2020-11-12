/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2735

--drop function SCHEMA_NAME.gw_fct_admin_manage_child_views(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_child_config(p_data json)
  RETURNS void AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_admin_manage_child_config($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{}, 
"feature":{"catFeature":"SHUTOFF_VALVE"},
"data":{"filterFields":{}, "pageInfo":{}, "view_name":"ve_node_shutoffvalve", "feature_type":"node" }}$$);
*/

DECLARE

v_schemaname text;
v_insert_fields text;
v_view_name text;
v_feature_type text;
v_project_type text;
v_version text;
v_config_fields text;

rec record;

v_cat_feature text;
v_feature_system_id text;
v_man_fields text;
v_man_addfields text;
v_orderby integer;
v_datatype text;
v_widgettype text;

BEGIN

	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version order by 1 desc limit 1;
	
	-- dissable temporary trigger to manage control_config
	UPDATE config_param_user SET value=FALSE WHERE cur_user = current_user AND parameter  = 'config_control';
		
	-- get input parameters
	v_cat_feature = ((p_data ->>'feature')::json->>'catFeature')::text;
	v_view_name = ((p_data ->>'data')::json->>'view_name')::text;
	v_feature_type = lower(((p_data ->>'data')::json->>'feature_type')::text);

	v_feature_system_id  = (SELECT lower(system_id) FROM cat_feature where id=v_cat_feature);

	IF v_view_name NOT IN (SELECT tableinfo_id FROM config_info_layer_x_type) THEN
		INSERT INTO sys_table(id, descript, sys_role, sys_criticity, qgis_role_id, qgis_criticity)
	    VALUES (v_view_name, concat('Custom editable view for ',v_cat_feature), 'role_edit', 0, null,0)
	    ON CONFLICT (id) DO NOTHING;

	    PERFORM gw_fct_admin_role_permissions();
	
	END IF;

	IF v_view_name NOT IN (SELECT tableinfo_id FROM config_info_layer_x_type) THEN
		INSERT INTO config_info_layer_x_type(tableinfo_id, infotype_id, tableinfotype_id) VALUES (v_view_name,1,v_view_name)
		ON CONFLICT (tableinfo_id, infotype_id) DO NOTHING;
	END IF;

	--select list of fields different than id from config_form_fields
	EXECUTE 'SELECT DISTINCT string_agg(column_name::text,'' ,'') FROM (SELECT column_name
	FROM information_schema.columns WHERE table_name=''config_form_fields'' and table_schema='''||v_schemaname||'''
	AND column_name!=''id'' ORDER BY ordinal_position)a;'
	INTO v_config_fields;
	
	--select list of fields different than id and formname from config_form_fields
	EXECUTE 'SELECT DISTINCT string_agg(concat(column_name)::text,'' ,'') FROM (SELECT column_name
	FROM information_schema.columns WHERE table_name=''config_form_fields'' and table_schema='''||v_schemaname||'''
	AND column_name!=''id'' AND column_name!=''formname'' ORDER BY ordinal_position)a;'
	INTO v_insert_fields;

	--insert configuration copied from the parent view config
	FOR rec IN (SELECT * FROM config_form_fields WHERE formname=concat('ve_',v_feature_type))
	LOOP

		EXECUTE 'INSERT INTO config_form_fields('||v_config_fields||')
		SELECT '''||v_view_name||''','||v_insert_fields||' FROM config_form_fields WHERE columnname='''||rec.columnname||'''
		AND formname=concat(''ve_'','''||v_feature_type||''')
		ON CONFLICT (formname, formtype, columnname) DO NOTHING';

	END LOOP;

	--update configuration of man_type fields setting featurecat related to the view
	EXECUTE 'UPDATE config_form_fields SET dv_querytext = concat(dv_querytext, ''OR featurecat_id = '''||quote_literal(v_cat_feature)||''''')
	WHERE formname = '''||v_view_name||'''
	and (columnname =''location_type'' OR columnname =''fluid_type'' OR columnname =''function_type'' OR columnname =''category_type'')
	AND dv_querytext NOT ILIKE ''%OR%'';';

	--select columns from man_* table without repeating the identifier
	v_man_fields = 'SELECT DISTINCT column_name::text, data_type::text, numeric_precision, numeric_scale
	FROM information_schema.columns where table_name=''man_'||v_feature_system_id||''' and table_schema='''||v_schemaname||''' 
	and column_name!='''||v_feature_type||'_id'' group by column_name, data_type,numeric_precision, numeric_scale';
				

	--insert configuration from the man_* tables of the feature type
	FOR rec IN  EXECUTE v_man_fields LOOP

		--capture max layout_id for the view
		EXECUTE 'SELECT max(layoutorder::integer) + 1 FROM config_form_fields WHERE formname = '''||v_view_name||''' AND  layoutname=''lyt_data_1'';'
		INTO v_orderby;

		--transform data and widget types
		IF rec.data_type = 'character varying' OR  rec.data_type = 'text' THEN
			v_datatype='string';
			v_widgettype='text';
		ELSIF rec.data_type = 'numeric' THEN
			v_datatype='double';
			v_widgettype='text';
		ELSIF rec.data_type = 'integer' OR rec.data_type = 'smallint' THEN
			v_datatype='integer';
			v_widgettype='text';
		ELSIF rec.data_type = 'boolean' THEN
			v_datatype='boolean';
			v_widgettype='check';
		ELSIF rec.data_type = 'date' THEN
			v_datatype='date';
			v_widgettype='datetime';
		ELSE 
			v_datatype='string';
			v_widgettype='text';
		END IF;

		--insert into config_form_fields
		INSERT INTO config_form_fields (formname,formtype,columnname,datatype,widgettype, layoutname, layoutorder,
			label, ismandatory, isparent, iseditable, isautoupdate) 
		VALUES (v_view_name,'form_feature', rec.column_name, v_datatype, v_widgettype, 'lyt_data_1',v_orderby, 
			rec.column_name, false, false,true,false) ON CONFLICT (formname, formtype, columnname) DO NOTHING;

	END LOOP;

	--select all already created addfields
	v_man_addfields = 'SELECT * FROM sys_addfields WHERE active = TRUE AND (cat_feature_id IS NULL OR cat_feature_id='''||v_cat_feature||''');';

	--insert configuration for the addfields of the feature type
	FOR rec IN EXECUTE v_man_addfields LOOP
		--capture max layout_id for the view
		EXECUTE 'SELECT max(layoutorder::integer) + 1 FROM config_form_fields WHERE formname = '''||v_view_name||''' AND  layoutname=''lyt_data_1'';'
		INTO v_orderby;
		
		--transform data and widget types
		IF rec.datatype_id = 'numeric' THEN 
			v_datatype='double';
		ELSE
			v_datatype=rec.datatype_id;
		END IF;

		IF  rec.datatype_id = 'boolean' THEN
			v_widgettype='check';
		ELSIF rec.datatype_id = 'date' THEN
			v_widgettype='datetime';
		ELSE 
			v_widgettype='text';
		END IF;
		
		--insert into config_form_fields
		INSERT INTO config_form_fields (formname,formtype,columnname,datatype,widgettype, layoutname,layoutorder,
			label, ismandatory,isparent,iseditable,isautoupdate) 
		VALUES (v_view_name,'form_feature',rec.param_name, v_datatype,v_widgettype, 'lyt_data_1',v_orderby,
			rec.param_name, rec.is_mandatory, false,rec.iseditable,false) ON CONFLICT (formname, formtype, columnname) DO NOTHING;
				
	END LOOP;

	-- enable trigger to manage control_config
	UPDATE config_param_user SET value=TRUE WHERE cur_user = current_user AND parameter  = 'config_control';
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
