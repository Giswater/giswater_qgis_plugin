/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2716

--drop function SCHEMA_NAME.gw_fct_admin_manage_child_views(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_child_views(p_data json)
  RETURNS void AS
$BODY$


/*EXAMPLE

SELECT SCHEMA_NAME.gw_fct_admin_manage_child_views($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"catFeature":"T"},
 "data":{"filterFields":{}, "pageInfo":{}, "multi_create":"False" }}$$);

SELECT SCHEMA_NAME.gw_fct_admin_manage_child_views($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{},
 "data":{"filterFields":{}, "pageInfo":{}, "multi_create":"True" }}$$);

SELECT SCHEMA_NAME.gw_fct_admin_manage_child_views($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{},
 "data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-DELETE" }}$$);
*/


DECLARE 
	v_schemaname text;
	v_cat_feature text;
	v_viewname text;
	v_definition text;
	v_feature_type text;
	v_feature_system_id text;
	v_man_fields text;
	rec record;
	v_multi_create boolean;
	v_created_addfields record;
	v_project_type text;
	v_querytext text;
	v_orderby integer;
	rec_orderby record;
	v_data_view json;
	v_view_type text;
	v_action text;
	v_childview text;
	
BEGIN

	
	-- search path
	SET search_path = "SCHEMA_NAME", public;

 
	-- get input parameters
	v_schemaname = 'SCHEMA_NAME';

	SELECT wsoftware INTO v_project_type FROM version LIMIT 1;

	v_cat_feature = ((p_data ->>'feature')::json->>'catFeature')::text;
	v_multi_create = ((p_data ->>'data')::json->>'multi_create')::text;
	v_action = ((p_data ->>'data')::json->>'action')::text;


	IF v_cat_feature IS NULL THEN

		v_cat_feature = (SELECT id FROM cat_feature LIMIT 1);

	END IF;

raise notice 'v_action %',v_action;

	IF v_action = 'MULTI-DELETE' THEN

		FOR v_childview IN SELECT child_layer FROM cat_feature
		LOOP
			EXECUTE 'DROP VIEW IF EXISTS '||v_childview||' CASCADE';

		END LOOP;
	END IF;



--if the view should be created for all the features loop over the cat_features
IF v_multi_create IS TRUE THEN
	raise notice 'MULTI';
	IF v_project_type ='WS' THEN
		v_querytext = 'SELECT cat_feature.* FROM cat_feature JOIN (SELECT id,active FROM node_type 
						UNION SELECT id,active FROM arc_type UNION SELECT id,active FROM connec_type) a USING (id) WHERE a.active IS TRUE ORDER BY id';
	
	ELSIF v_project_type ='UD' THEN
		v_querytext = 'SELECT cat_feature.* FROM cat_feature JOIN (SELECT id,active FROM node_type 
															UNION SELECT id,active FROM arc_type 
															UNION SELECT id,active FROM connec_type 
															UNION SELECT id,active FROM gully_type) a USING (id) WHERE a.active IS TRUE ORDER BY id';
	END IF;

	
	FOR rec IN EXECUTE v_querytext LOOP
		RAISE NOTICE 'rec.id,%',rec.id;
		--set view definition to null
		v_definition = null;
		
		--get the system type and system_id of the feature and view name
		v_feature_type = lower(rec.feature_type);
		v_feature_system_id  = lower(rec.system_id);
		v_cat_feature = rec.id;
		
		--create a child view name if doesnt exist
		IF (SELECT child_layer FROM cat_feature WHERE id=rec.id) IS NULL THEN
			UPDATE cat_feature SET child_layer=concat('ve_',lower(feature_type),'_',lower(id)) WHERE id=rec.id;
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
		
		RAISE NOTICE 'v_definition,%',v_definition;

		IF v_definition IS NULL THEN

			--select columns from man_* table without repeating the identifier
			EXECUTE 'SELECT DISTINCT string_agg(concat(''man_'||v_feature_system_id||'.'',column_name)::text,'', '')
			FROM information_schema.columns where table_name=''man_'||v_feature_system_id||''' and table_schema='''||v_schemaname||''' 
			and column_name!='''||v_feature_type||'_id'''
			INTO v_man_fields;	

			raise notice '4/addfields=1,v_man_fields,%',v_man_fields;	
			--check and select the addfields if are already created
			IF (SELECT count(id) FROM man_addfields_parameter WHERE (cat_feature_id=rec.id OR cat_feature_id IS NULL) and active is true ) != 0 THEN
				
					IF (SELECT orderby FROM man_addfields_parameter WHERE cat_feature_id=rec.id limit 1) IS NULL THEN
						v_orderby = 1;
						FOR rec_orderby IN (SELECT * FROM man_addfields_parameter WHERE cat_feature_id=rec.id ORDER BY id) LOOP
							UPDATE man_addfields_parameter SET orderby =v_orderby where id=rec_orderby.id;
							v_orderby = v_orderby+1;
						END LOOP;
					END IF;

					IF (SELECT orderby FROM man_addfields_parameter WHERE cat_feature_id IS NULL limit 1) IS NULL THEN
						v_orderby = 10000;
						FOR rec_orderby IN (SELECT * FROM man_addfields_parameter WHERE cat_feature_id IS NULL ORDER BY id) LOOP
							UPDATE man_addfields_parameter SET orderby =v_orderby where id=rec_orderby.id;
							v_orderby = v_orderby+1;
						END LOOP;
					END IF;


					SELECT string_agg(concat('a.',param_name),',' order by orderby) as a_param,
					string_agg(concat('ct.',param_name),',' order by orderby) as ct_param,
					string_agg(concat('(''''',id,''''')'),',' order by orderby) as id_param,
					string_agg(concat(param_name,' ', datatype_id),', ' order by orderby) as datatype
					INTO v_created_addfields
					FROM man_addfields_parameter WHERE  (cat_feature_id=rec.id OR cat_feature_id IS NULL) AND active IS TRUE;		
				

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

				RAISE NOTICE 'MULTI - VIEW TYPE  ,%', v_view_type;
				
				v_man_fields := COALESCE(v_man_fields, 'null');

				v_data_view = '{"schema":"'||v_schemaname ||'","body":{"viewname":"'||v_viewname||'",
				"feature_type":"'||v_feature_type||'","feature_system_id":"'||v_feature_system_id||'","featurecat":"'||rec.id||'", "view_type":"'||v_view_type||'",
				"man_fields":"'||v_man_fields||'","a_param":"'||v_created_addfields.a_param||'","ct_param":"'||v_created_addfields.ct_param||'",
				"id_param":"'||v_created_addfields.id_param||'","datatype":"'||v_created_addfields.datatype||'"}}';
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

				RAISE NOTICE 'MULTI - VIEW TYPE  ,%', v_view_type;

				v_man_fields := COALESCE(v_man_fields, 'null');

				v_data_view = '{"schema":"'||v_schemaname ||'","body":{"viewname":"'||v_viewname||'",
				"feature_type":"'||v_feature_type||'","feature_system_id":"'||v_feature_system_id||'","featurecat":"'||rec.id||'", "view_type":"'||v_view_type||'",
				"man_fields":"'||v_man_fields||'","a_param":null,"ct_param":null,"id_param":null,"datatype":null}}';
					
				PERFORM gw_fct_admin_manage_child_views_view(v_data_view);			
					
			END IF;

			--create trigger on view 
			EXECUTE 'DROP TRIGGER IF EXISTS gw_trg_edit_'||v_feature_type||'_'||lower(replace(replace(replace(rec.id, ' ','_'),'-','_'),'.','_'))||' ON '||v_schemaname||'.'||v_viewname||';';

			EXECUTE 'CREATE TRIGGER gw_trg_edit_'||v_feature_type||'_'||lower(replace(replace(replace(rec.id, ' ','_'),'-','_'),'.','_'))||'
			INSTEAD OF INSERT OR UPDATE OR DELETE ON '||v_schemaname||'.'||v_viewname||'
			FOR EACH ROW EXECUTE PROCEDURE '||v_schemaname||'.gw_trg_edit_'||v_feature_type||'('''||rec.id||''');';
		ELSE
			CONTINUE;
		END IF;

		IF 	v_viewname NOT IN (SELECT formname FROM config_api_form_fields) THEN
			EXECUTE 'SELECT gw_fct_admin_manage_child_config($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, 
			"feature":{"catFeature":"'||v_cat_feature||'"}, 
			"data":{"filterFields":{}, "pageInfo":{}, "view_name":"'||v_viewname||'", "feature_type":"'||v_feature_type||'" }}$$);';
		END IF;
	
	END LOOP;
ELSE
	raise notice 'SIMPLE';
	--get the system type and system_id of the feature and view name
	v_feature_type = (SELECT lower(feature_type) FROM cat_feature where id=v_cat_feature);
	v_feature_system_id  = (SELECT lower(system_id) FROM cat_feature where id=v_cat_feature);

	--create a child view name if doesnt exist
	IF (SELECT child_layer FROM cat_feature WHERE id=v_cat_feature) IS NULL THEN
		UPDATE cat_feature SET child_layer=concat('ve_',lower(feature_type),'_',lower(id)) WHERE id=v_cat_feature;
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
	
	IF v_definition IS NULL THEN
	
		--select columns from man_* table without repeating the identifier
		EXECUTE 'SELECT DISTINCT string_agg(concat(''man_'||v_feature_system_id||'.'',column_name)::text,'', '')
		FROM information_schema.columns where table_name=''man_'||v_feature_system_id||''' and table_schema='''||v_schemaname||''' 
		and column_name!='''||v_feature_type||'_id'''
		INTO v_man_fields;	

		RAISE NOTICE 'v_man_fields,%',v_man_fields;
		--check and select the addfields if are already created
		IF (SELECT count(id) FROM man_addfields_parameter WHERE (cat_feature_id=v_cat_feature OR cat_feature_id IS NULL) and active is true ) != 0 THEN
		raise notice '4/addfields=1,v_man_fields,%',v_man_fields;		
			
				IF (SELECT orderby FROM man_addfields_parameter WHERE cat_feature_id=v_cat_feature LIMIT 1) IS NULL THEN
					v_orderby = 1;
					FOR rec_orderby IN (SELECT * FROM man_addfields_parameter WHERE cat_feature_id=v_cat_feature ORDER BY id) LOOP
						UPDATE man_addfields_parameter SET orderby =v_orderby where id=rec_orderby.id;
						v_orderby = v_orderby+1;
					END LOOP;
				END IF;

				IF (SELECT orderby FROM man_addfields_parameter WHERE cat_feature_id IS NULL limit 1) IS NULL THEN
					v_orderby = 10000;
					FOR rec_orderby IN (SELECT * FROM man_addfields_parameter WHERE cat_feature_id IS NULL ORDER BY id) LOOP
						UPDATE man_addfields_parameter SET orderby =v_orderby where id=rec_orderby.id;
						v_orderby = v_orderby+1;
					END LOOP;
					raise notice 'v_orderby,%',v_orderby;
				END IF;

				SELECT string_agg(concat('a.',param_name),','order by orderby) as a_param,
				string_agg(concat('ct.',param_name),',' order by orderby) as ct_param,
				string_agg(concat('(''''',id,''''')'),',' order by orderby) as id_param,
				string_agg(concat(param_name,' ', datatype_id),', ' order by orderby) as datatype
				INTO v_created_addfields
				FROM man_addfields_parameter WHERE  (cat_feature_id=v_cat_feature OR cat_feature_id IS NULL) AND active IS TRUE;	

			
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

			v_data_view = '{"schema":"'||v_schemaname ||'","body":{"viewname":"'||v_viewname||'",
			"feature_type":"'||v_feature_type||'","feature_system_id":"'||v_feature_system_id||'","featurecat":"'||v_cat_feature||'","view_type":"'||v_view_type||'",
			"man_fields":"'||v_man_fields||'","a_param":"'||v_created_addfields.a_param||'","ct_param":"'||v_created_addfields.ct_param||'",
			"id_param":"'||v_created_addfields.id_param||'","datatype":"'||v_created_addfields.datatype||'"}}';

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

		v_data_view = '{"schema":"'||v_schemaname ||'","body":{"viewname":"'||v_viewname||'",
		"feature_type":"'||v_feature_type||'","feature_system_id":"'||v_feature_system_id||'","featurecat":"'||v_cat_feature||'","view_type":"'||v_view_type||'",
		"man_fields":"'||v_man_fields||'","a_param":"null","ct_param":"null","id_param":"null","datatype":"null"}}';

		PERFORM gw_fct_admin_manage_child_views_view(v_data_view);

		END IF;


	IF 	v_viewname NOT IN (SELECT formname FROM config_api_form_fields) THEN
		EXECUTE 'SELECT gw_fct_admin_manage_child_config($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, 
		"feature":{"catFeature":"'||v_cat_feature||'"}, 
		"data":{"filterFields":{}, "pageInfo":{}, "view_name":"'||v_viewname||'", "feature_type":"'||v_feature_type||'" }}$$);';
	END IF;
	--create trigger on view 
	EXECUTE 'DROP TRIGGER IF EXISTS gw_trg_edit_'||v_feature_type||'_'||lower(replace(replace(replace(v_cat_feature, ' ','_'),'-','_'),'.','_'))||' ON '||v_schemaname||'.'||v_viewname||';';

	EXECUTE 'CREATE TRIGGER gw_trg_edit_'||v_feature_type||'_'||lower(replace(replace(replace(v_cat_feature, ' ','_'),'-','_'),'.','_'))||'
	INSTEAD OF INSERT OR UPDATE OR DELETE ON '||v_schemaname||'.'||v_viewname||'
	FOR EACH ROW EXECUTE PROCEDURE '||v_schemaname||'.gw_trg_edit_'||v_feature_type||'('''||v_cat_feature||''');';
	
	END IF;
END IF;




	--    Control NULL's
	--v_message := COALESCE(v_message, '');
	
	-- Return
	--RETURN ('{"message":{"priority":"'||v_priority||'", "text":"'||v_message||'"}}');	
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
