/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2716
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_admin_manage_child_views(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_child_views(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE

-- create views and add config_form_fields columns only if is empty
SELECT SCHEMA_NAME.gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{},
"feature":{"catFeature":"T"},"data":{"filterFields":{}, "pageInfo":{}, "action":"SINGLE-CREATE" }}$$);

-- create views and add config_form_fields columns only if is empty
SELECT SCHEMA_NAME.gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
 "data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-CREATE" }}$$);

--only replace views, not delete nothing but add a new one column on config_form_fields (newColumn) copying values from ONE UNIQUE parent
SELECT SCHEMA_NAME.gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"featureType":"NODE"},
 "data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-UPDATE", "newColumn":"workcat_id_plan" }}$$);

--only replace views, not delete nothing but add a new one column on config_form_fields (newColumn) copying values from ONE UNIQUE MAN-TABLE
SELECT SCHEMA_NAME.gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"systemId":"CONDUIT"},
 "data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-UPDATE", "newColumn":"inlet_offset" }}$$);

--only replace views, not delete nothing but add a new one column on config_form_fields (newColumn) copying values from parent
SELECT SCHEMA_NAME.gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{},
"feature":{"catFeature":"PIPE"}, "data":{"filterFields":{}, "pageInfo":{}, "action":"SINGLE-UPDATE", "newColumn":"workcat_id_plan" }}$$);

--delete views
SELECT SCHEMA_NAME.gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
 "data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-DELETE" }}$$);


select *  from SCHEMA_NAME.config_form_fields where formname = 've_arc' and columnname = 'workcat_id_plan'
*/

DECLARE

v_schemaname text = 'SCHEMA_NAME';
v_cat_feature text;
v_viewname text;
v_definition text;
v_feature_type text;
v_feature_class text;
v_feature_childtable_name text;
v_man_fields text;
v_feature_childtable_fields text;
v_parent_layer text;

rec record;
rec_orderby record;

v_multi_create boolean;
v_project_type text;
v_querytext text;
v_orderby integer;
v_data_view json;
v_view_type text;
v_action text;
v_childview text;
v_return_status text = 'Failed';
v_return_msg text = 'Process finished with some errors';
v_error_context text;
v_newcolumn text;
v_query json;
v_sys_feature_class text;


BEGIN

	-- search path
	SET search_path = "SCHEMA_NAME", public;

	-- get project type
 	IF (SELECT tablename FROM pg_tables WHERE schemaname = v_schemaname AND tablename = 'inp_storage') IS NOT NULL THEN
		v_project_type = 'UD';
 	ELSE
		v_project_type = 'WS';
 	END IF;

	v_cat_feature = ((p_data ->>'feature')::json->>'catFeature')::text;
	v_action = ((p_data ->>'data')::json->>'action')::text;
	v_newcolumn = ((p_data ->>'data')::json->>'newColumn')::text;
	v_feature_type = ((p_data ->>'feature')::json->>'featureType')::text;
	v_sys_feature_class = ((p_data ->>'feature')::json->>'systemId')::text;

	IF v_cat_feature IS NULL THEN
		v_cat_feature = (SELECT id FROM cat_feature LIMIT 1);
	END IF;

	IF v_action = 'MULTI-DELETE' THEN

		FOR v_childview IN SELECT child_layer FROM cat_feature WHERE child_layer IS NOT NULL
		LOOP
			EXECUTE 'DROP VIEW IF EXISTS '||v_childview||'';
			PERFORM gw_fct_debug(concat('{"data":{"msg":"Deleted layer: ", "variables":"',v_childview,'"}}')::json);

		END LOOP;

		v_return_status = 'Accepted';
		v_return_msg = 'Multi-delete view successfully';


	ELSIF v_action = 'MULTI-UPDATE' THEN

		IF v_sys_feature_class IS NOT NULL THEN
			v_querytext = 'SELECT child_layer, id, parent_layer FROM cat_feature WHERE child_layer IS NOT NULL AND feature_class = '||quote_literal(v_sys_feature_class);

		ELSIF v_feature_type IS NOT NULL THEN
			v_querytext = 'SELECT child_layer, id, parent_layer FROM cat_feature WHERE child_layer IS NOT NULL AND feature_type = '||quote_literal(v_feature_type);

		ELSIF v_feature_type IS NULL THEN
			v_querytext = 'SELECT child_layer, id, parent_layer FROM cat_feature WHERE child_layer IS NOT NULL';

		END IF;

		raise notice 'v_querytext %', v_querytext;

		FOR v_childview, v_cat_feature, v_parent_layer IN EXECUTE v_querytext
		LOOP

			raise notice ' v_childview, % v_cat_feature, % v_parent_layer %',  v_childview, v_cat_feature, v_parent_layer;

			-- delete existing view
			EXECUTE 'DROP VIEW IF EXISTS '||v_childview||' CASCADE';
			PERFORM gw_fct_debug(concat('{"data":{"msg":"Deleted layer: ", "variables":"',v_childview,'"}}')::json);

			-- create new view with all columns from parent/man/addfields
			v_query = concat('{"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"catFeature":"',v_cat_feature,
			'"},"data":{"filterFields":{}, "pageInfo":{}, "action":"SINGLE-CREATE"}}');

			PERFORM gw_fct_admin_manage_child_views(v_query);

			-- insert into config_form_fields new column values coyping from parent
			INSERT INTO config_form_fields (formname, formtype,tabname,  columnname, layoutname, layoutorder,
			datatype, widgettype, widgetcontrols, label, tooltip, placeholder,
			ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext,
			dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc,
			stylesheet, widgetfunction, linkedobject, hidden)
			SELECT v_childview, formtype,tabname, columnname, layoutname, layoutorder,
			datatype, widgettype, widgetcontrols, label, tooltip, placeholder,
			ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext,
			dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc,
			stylesheet, widgetfunction,linkedobject, hidden
			FROM config_form_fields WHERE formname = v_parent_layer AND columnname = v_newcolumn
			ON CONFLICT (formname, columnname, formtype, tabname) DO NOTHING;

		END LOOP;


		v_return_status = 'Accepted';
		v_return_msg = 'Multi-update view successfully';

	ELSIF v_action = 'SINGLE-UPDATE' THEN

		SELECT child_layer, parent_layer INTO v_childview, v_parent_layer FROM cat_feature WHERE id = v_cat_feature;

		raise notice 'v_childview, % v_parent_layer %', v_childview, v_parent_layer ;


		-- delete existing view
		EXECUTE 'DROP VIEW IF EXISTS '||v_childview||' CASCADE';
		PERFORM gw_fct_debug(concat('{"data":{"msg":"Deleted layer: ", "variables":"',v_childview,'"}}')::json);

		-- create new view with all columns from parent/man/addfields
		v_query = concat('{"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"catFeature":"',v_cat_feature,
		'"},"data":{"filterFields":{}, "pageInfo":{}, "action":"SINGLE-CREATE"}}');

		PERFORM gw_fct_admin_manage_child_views(v_query);

		-- insert into config_form_fields new column values coyping from parent
		INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder,
       datatype, widgettype, widgetcontrols, label, tooltip, placeholder,
       ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext,
       dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc,
       stylesheet, widgetfunction, linkedobject, hidden)
		SELECT v_childview, formtype,tabname, columnname, layoutname, layoutorder,
       datatype, widgettype, widgetcontrols, label, tooltip, placeholder,
       ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext,
       dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc,
       stylesheet, widgetfunction, linkedobject, hidden
		FROM config_form_fields WHERE formname = v_parent_layer AND columnname = v_newcolumn
		ON CONFLICT (formname, columnname, formtype, tabname) DO NOTHING;

		v_return_status = 'Accepted';
		v_return_msg = 'Single-update view successfully';


	ELSIF v_action = 'MULTI-CREATE' THEN

		v_querytext = 'SELECT cat_feature.* FROM cat_feature ORDER BY id';

		FOR rec IN EXECUTE v_querytext LOOP

			--set view definition to null
			v_definition = null;

			--get the system type and feature_class of the feature and view name
			v_feature_type = lower(rec.feature_type);
			v_feature_class  = lower(rec.feature_class);
			v_parent_layer = lower(rec.parent_layer);
			v_cat_feature = rec.id;
			v_feature_childtable_name := 'man_' || v_feature_type || '_' || lower(v_cat_feature);


			--create a child view name if doesnt exist
			IF (SELECT child_layer FROM cat_feature WHERE id=rec.id) IS NULL THEN
				UPDATE cat_feature SET child_layer=concat(v_parent_layer,'_',lower(id)) WHERE id=rec.id;
			END IF;
			v_viewname = (SELECT child_layer FROM cat_feature WHERE id=rec.id);

			IF v_viewname ilike '%-%' OR v_viewname ilike '% %' OR v_viewname ilike '%.%' THEN
				v_viewname = replace(replace(replace(v_viewname,'-','_'),' ','_'),'.','_');
				UPDATE cat_feature SET child_layer=v_viewname WHERE id=rec.id;
			END IF;

			--check if the defined view exists and create it id it doesn't
			IF (SELECT EXISTS ( SELECT 1 FROM  information_schema.tables WHERE  table_schema = v_schemaname AND table_name = v_viewname)) IS TRUE THEN
					EXECUTE 'SELECT pg_get_viewdef('''||v_schemaname||'.'||v_viewname||''', true);'
					INTO v_definition;
			END IF;

			-- drop view before to recreate it if exists
			IF v_definition IS NOT NULL THEN
				EXECUTE 'DROP VIEW IF EXISTS '||v_viewname;
			END IF;

			--select columns from man_* table without repeating the identifier
			EXECUTE 'SELECT DISTINCT string_agg(concat(''man_'||v_feature_class||'.'',column_name)::text,'', '')
			FROM information_schema.columns where table_name=''man_'||v_feature_class||''' and table_schema='''||v_schemaname||''' 
			and column_name!='''||v_feature_type||'_id'''
			INTO v_man_fields;

			RAISE NOTICE '4/addfields=1,v_man_fields,%',v_man_fields;


			--select columns from v_feature_childtable_name.* table without repeating the identifiers
			EXECUTE 'SELECT DISTINCT string_agg(concat('''||v_feature_childtable_name||'.'',column_name)::text,'', '')
			FROM information_schema.columns where table_name='''||v_feature_childtable_name||''' and table_schema='''||v_schemaname||'''
			and column_name!=''id'' and column_name!='''||v_feature_type||'_id'''
			INTO v_feature_childtable_fields;

			RAISE NOTICE 'v_feature_childtable_fields,%',v_feature_childtable_fields;


			--check and select the addfields if are already created
			IF (SELECT count(id) FROM sys_addfields WHERE (cat_feature_id=rec.id OR cat_feature_id IS NULL) and active is true ) != 0 THEN

				IF (SELECT orderby FROM sys_addfields WHERE cat_feature_id=rec.id limit 1) IS NULL THEN
					v_orderby = 1;
					FOR rec_orderby IN (SELECT * FROM sys_addfields WHERE cat_feature_id=rec.id ORDER BY id) LOOP
						UPDATE sys_addfields SET orderby =v_orderby where id=rec_orderby.id;
						v_orderby = v_orderby+1;
					END LOOP;
				END IF;

				IF (SELECT orderby FROM sys_addfields WHERE cat_feature_id IS NULL limit 1) IS NULL THEN
					v_orderby = 10000;
					FOR rec_orderby IN (SELECT * FROM sys_addfields WHERE cat_feature_id IS NULL ORDER BY id) LOOP
						UPDATE sys_addfields SET orderby =v_orderby where id=rec_orderby.id;
						v_orderby = v_orderby+1;
					END LOOP;
				END IF;

				--create views with fields from parent table,man table and addfields
				IF (v_man_fields IS NULL AND v_project_type='WS') OR (v_man_fields IS NULL AND v_project_type='UD' AND
					( v_feature_type='arc' OR v_feature_type='node')) THEN
					--view for WS and UD features that only have feature_id in man table and have defined addfields
					v_view_type = 4;

				ELSIF (v_man_fields IS NULL AND v_project_type='UD' AND (v_feature_type='connec' OR v_feature_type='gully')) THEN
					--view for ud connec y gully which dont have man_type table and have defined addfields
					v_view_type = 5;

				ELSE
					--view for WS and UD features that have many fields in man table and have defined addfields
					v_view_type = 6;

				END IF;

				v_man_fields := COALESCE(v_man_fields, 'null');
				v_feature_childtable_fields := COALESCE(v_feature_childtable_fields, 'null');

				v_data_view = '{
				"schema":"'||v_schemaname ||'",
				"body":{"viewname":"'||v_viewname||'",
					"feature_type":"'||v_feature_type||'",
					"parent_layer":"'||v_parent_layer||'",
					"feature_class":"'||v_feature_class||'",
					"feature_cat":"'||v_cat_feature||'",
					"feature_childtable_name":"'||v_feature_childtable_name||'",
					"feature_childtable_fields":"'||v_feature_childtable_fields||'",
					"man_fields":"'||v_man_fields||'",
					"view_type":"'||v_view_type||'"
					}
				}';

				PERFORM gw_fct_admin_manage_child_views_view(v_data_view);

			ELSE
				--create views with fields from parent table and man table
				IF (v_man_fields IS NULL AND v_project_type='WS') OR (v_man_fields IS NULL AND v_project_type='UD' AND
					( v_feature_type='arc' OR v_feature_type='node')) THEN
					--view for WS and UD features that only have feature_id in man table
					v_view_type = 1;

				ELSIF (v_man_fields IS NULL AND v_project_type='UD' AND (v_feature_type='connec' OR v_feature_type='gully')) THEN
					--view for ud connec y gully which dont have man_type table
					v_view_type = 2;

				ELSE
					--view for WS and UD features that have many fields in man table
					v_view_type = 3;

				END IF;

				v_man_fields := COALESCE(v_man_fields, 'null');
				v_feature_childtable_fields := COALESCE(v_feature_childtable_fields, 'null');

				v_data_view = '{
				"schema":"'||v_schemaname ||'",
				"body":{"viewname":"'||v_viewname||'",
					"feature_type":"'||v_feature_type||'",
					"parent_layer":"'||v_parent_layer||'",
					"feature_class":"'||v_feature_class||'",
					"feature_cat":"'||v_cat_feature||'",
					"feature_childtable_name":"'||v_feature_childtable_name||'",
					"feature_childtable_fields":"'||v_feature_childtable_fields||'",
					"man_fields":"'||v_man_fields||'",
					"view_type":"'||v_view_type||'"
					}
				}';

				PERFORM gw_fct_admin_manage_child_views_view(v_data_view);

			END IF;

			--create trigger on view
			EXECUTE 'DROP TRIGGER IF EXISTS gw_trg_edit_'||v_feature_type||'_'||lower(replace(replace(replace(rec.id, ' ','_'),'-','_'),'.','_'))||' ON '||
			v_schemaname||'.'||v_viewname||';';

			EXECUTE 'CREATE TRIGGER gw_trg_edit_'||v_feature_type||'_'||lower(replace(replace(replace(rec.id, ' ','_'),'-','_'),'.','_'))||'
			INSTEAD OF INSERT OR UPDATE OR DELETE ON '||v_schemaname||'.'||v_viewname||'
			FOR EACH ROW EXECUTE PROCEDURE '||v_schemaname||'.gw_trg_edit_'||v_feature_type||'('''||rec.id||''');';

			EXECUTE 'SELECT gw_fct_admin_manage_child_config($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{},
			"feature":{"catFeature":"'||v_cat_feature||'"}, 
			"data":{"filterFields":{}, "pageInfo":{}, "view_name":"'||v_viewname||'", "feature_type":"'||v_feature_type||'" }}$$);';

		END LOOP;

		v_return_status = 'Accepted';
		v_return_msg = 'Multi-create view successfully';

	ELSIF v_action = 'SINGLE-CREATE' THEN

		--get the system type and feature_class of the feature and view name
		v_feature_type = (SELECT lower(feature_type) FROM cat_feature where id=v_cat_feature);
		v_feature_class  = (SELECT lower(feature_class) FROM cat_feature where id=v_cat_feature);
		v_parent_layer = (SELECT lower(parent_layer) FROM cat_feature where id=v_cat_feature);
		v_feature_childtable_name := 'man_' || v_feature_type || '_' || lower(v_cat_feature);

		--create a child view name if doesnt exist
		IF (SELECT child_layer FROM cat_feature WHERE id=v_cat_feature) IS NULL THEN
			UPDATE cat_feature SET child_layer=concat(v_parent_layer,'_',lower(id)) WHERE id=v_cat_feature;
		END IF;
		v_viewname = (SELECT child_layer FROM cat_feature WHERE id=v_cat_feature);

		IF v_viewname ilike '%-%' OR v_viewname ilike '% %' OR v_viewname ilike '%.%' THEN
				v_viewname = replace(replace(replace(v_viewname,'-','_'),' ','_'),'.','_');
			UPDATE cat_feature SET child_layer=v_viewname WHERE id=v_cat_feature;
		END IF;

		--check if the defined view exists
		IF (SELECT EXISTS ( SELECT 1 FROM   information_schema.tables WHERE  table_schema = v_schemaname AND table_name = v_viewname)) IS TRUE THEN
				EXECUTE'SELECT pg_get_viewdef('''||v_schemaname||'.'||v_viewname||''', true);'
				INTO v_definition;
		END IF;

		-- drop view before to recreate it if exists
		IF v_definition IS NOT NULL THEN
			EXECUTE 'DROP VIEW IF EXISTS '||v_viewname;
		END IF;

		--select columns from man_* table without repeating the identifier
		EXECUTE 'SELECT DISTINCT string_agg(concat(''man_'||v_feature_class||'.'',column_name)::text,'', '')
		FROM information_schema.columns where table_name=''man_'||v_feature_class||''' and table_schema='''||v_schemaname||''' 
		and column_name!='''||v_feature_type||'_id'''
		INTO v_man_fields;

		RAISE NOTICE 'v_man_fields,%',v_man_fields;


		--select columns from v_feature_childtable_name.* table without repeating the identifiers
		EXECUTE 'SELECT DISTINCT string_agg(concat('''||v_feature_childtable_name||'.'',column_name)::text,'', '')
		FROM information_schema.columns where table_name='''||v_feature_childtable_name||''' and table_schema='''||v_schemaname||'''
		and column_name!=''id'' and column_name!='''||v_feature_type||'_id'''
		INTO v_feature_childtable_fields;

		RAISE NOTICE 'v_feature_childtable_fields,%',v_feature_childtable_fields;

		--check and select the addfields if are already created
		IF (SELECT count(id) FROM sys_addfields WHERE (cat_feature_id=v_cat_feature OR cat_feature_id IS NULL) and active is true ) != 0 THEN
		raise notice '4/addfields=1,v_man_fields,%',v_man_fields;

			IF (SELECT orderby FROM sys_addfields WHERE cat_feature_id=v_cat_feature LIMIT 1) IS NULL THEN
				v_orderby = 1;
				FOR rec_orderby IN (SELECT * FROM sys_addfields WHERE cat_feature_id=v_cat_feature ORDER BY id) LOOP
					UPDATE sys_addfields SET orderby =v_orderby where id=rec_orderby.id;
					v_orderby = v_orderby+1;
				END LOOP;
			END IF;

			IF (SELECT orderby FROM sys_addfields WHERE cat_feature_id IS NULL limit 1) IS NULL THEN
				v_orderby = 10000;
				FOR rec_orderby IN (SELECT * FROM sys_addfields WHERE cat_feature_id IS NULL ORDER BY id) LOOP
					UPDATE sys_addfields SET orderby =v_orderby where id=rec_orderby.id;
					v_orderby = v_orderby+1;
				END LOOP;
				raise notice 'v_orderby,%',v_orderby;
			END IF;

			--create views with fields from parent table,man table and addfields
			IF (v_man_fields IS NULL AND v_project_type='WS') OR (v_man_fields IS NULL AND v_project_type='UD' AND
				( v_feature_type='arc' OR v_feature_type='node')) THEN
				--view for WS and UD features that only have feature_id in man table and have defined addfields
				v_view_type = 4;

			ELSIF (v_man_fields IS NULL AND v_project_type='UD' AND (v_feature_type='connec' OR v_feature_type='gully')) THEN
				--view for ud connec y gully which dont have man_type table and have defined addfields
				v_view_type = 5;

			ELSE
				--view for WS and UD features that have many fields in man table and have defined addfields
				v_view_type = 6;

			END IF;

			RAISE NOTICE 'SIMPLE - VIEW TYPE  ,%', v_view_type;

			v_man_fields := COALESCE(v_man_fields, 'null');
			v_feature_childtable_fields := COALESCE(v_feature_childtable_fields, 'null');

			v_data_view = '{
			"schema":"'||v_schemaname ||'",
			"body":{"viewname":"'||v_viewname||'",
				"feature_type":"'||v_feature_type||'",
				"parent_layer":"'||v_parent_layer||'",
				"feature_class":"'||v_feature_class||'",
				"feature_cat":"'||v_cat_feature||'",
				"feature_childtable_name":"'||v_feature_childtable_name||'",
				"feature_childtable_fields":"'||v_feature_childtable_fields||'",
				"man_fields":"'||v_man_fields||'",
				"view_type":"'||v_view_type||'"
				}
			}';

			PERFORM gw_fct_admin_manage_child_views_view(v_data_view);

		ELSE

			--create views with fields from parent table and man table
			IF (v_man_fields IS NULL AND v_project_type='WS') OR (v_man_fields IS NULL AND v_project_type='UD' AND
				( v_feature_type='arc' OR v_feature_type='node')) THEN
				--view for WS and UD features that only have feature_id in man table
				v_view_type = 1;

			ELSIF (v_man_fields IS NULL AND v_project_type='UD' AND (v_feature_type='connec' OR v_feature_type='gully')) THEN
				--view for ud connec y gully which dont have man_type table
				v_view_type = 2;

			ELSE
				--view for WS and UD features that have many fields in man table
				v_view_type = 3;

			END IF;

			RAISE NOTICE 'SIMPLE - VIEW TYPE  ,%', v_view_type;

			v_man_fields := COALESCE(v_man_fields, 'null');
			v_feature_childtable_fields := COALESCE(v_feature_childtable_fields, 'null');

			v_data_view = '{
			"schema":"'||v_schemaname ||'",
			"body":{"viewname":"'||v_viewname||'",
				"feature_type":"'||v_feature_type||'",
				"parent_layer":"'||v_parent_layer||'",
				"feature_class":"'||v_feature_class||'",
				"feature_cat":"'||v_cat_feature||'",
				"feature_childtable_name":"'||v_feature_childtable_name||'",
				"feature_childtable_fields":"'||v_feature_childtable_fields||'",
				"man_fields":"'||v_man_fields||'",
				"view_type":"'||v_view_type||'"
				}
			}';

			PERFORM gw_fct_admin_manage_child_views_view(v_data_view);

			v_return_status = 'Accepted';
			v_return_msg = 'Process finished successfully';
			END IF;

			EXECUTE 'SELECT gw_fct_admin_manage_child_config($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{},
			"feature":{"catFeature":"'||v_cat_feature||'"}, 
			"data":{"filterFields":{}, "pageInfo":{}, "view_name":"'||v_viewname||'", "feature_type":"'||v_feature_type||'" }}$$);';

			--create trigger on view
			EXECUTE 'DROP TRIGGER IF EXISTS gw_trg_edit_'||v_feature_type||'_'||lower(replace(replace(replace(v_cat_feature, ' ','_'),'-','_'),'.','_'))||' ON '||
			v_schemaname||'.'||v_viewname||';';

			EXECUTE 'CREATE TRIGGER gw_trg_edit_'||v_feature_type||'_'||lower(replace(replace(replace(v_cat_feature, ' ','_'),'-','_'),'.','_'))||'
			INSTEAD OF INSERT OR UPDATE OR DELETE ON '||v_schemaname||'.'||v_viewname||'
			FOR EACH ROW EXECUTE PROCEDURE '||v_schemaname||'.gw_trg_edit_'||v_feature_type||'('''||v_cat_feature||''');';


		v_return_status = 'Accepted';
		v_return_msg = 'Single-create view successfully';

	END IF;

	-- manage permissions
    IF v_action <> 'MULTI-DELETE' THEN
        PERFORM gw_fct_admin_role_permissions();
    END IF;

	--  Return
	RETURN ('{"status":"'||v_return_status||'", "message":{"level":0, "text":"'||v_return_msg||'"},"body":{"form":{}'||',"data":{}}'||'}')::json;


	--EXCEPTION WHEN OTHERS THEN
	--GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	--RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;



END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;