/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2758


DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_trg_update_child_view()cascade;
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_cat_feature()
  RETURNS trigger AS
$BODY$


DECLARE 
	v_schemaname text;
	v_viewname text;
	v_definition text;
	v_id text;
	v_layout text;
	v_projecttype text;
	v_layoutorder integer;
	v_partialquerytext text;
	v_querytext text;
	v_table text;
	v_feature_field_id text;
	v_feature record;
	v_query text;
	v_arc_epa text;
	v_new_child_layer text;

BEGIN	

	-- search path
	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- get input parameters
	v_schemaname = 'SCHEMA_NAME';

	--  Get project type
	SELECT project_type INTO v_projecttype FROM sys_version LIMIT 1;

	IF (TG_OP = 'INSERT' OR  TG_OP = 'UPDATE') THEN
		--Controls on update or insert of cat_feature.id check if the new id or child layer has accents, dots or dashes. If so, give an error.
		v_id = array_to_string(ts_lexize('unaccent',NEW.id),',','*');

		IF v_id IS NOT NULL OR NEW.id ilike '%.%' OR NEW.id ilike '%-%' THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3038", "function":"2758","debug_msg":"'||NEW.id||'"}}$$);';
		END IF;

		v_id = array_to_string(ts_lexize('unaccent',NEW.child_layer),',','*');

		IF v_id IS NOT NULL OR NEW.child_layer ilike '%-%' OR NEW.child_layer ilike '%.%' THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3038", "function":"2758","debug_msg":"'||NEW.child_layer||'"}}$$);';
		END IF;	

		-- set v_id
		v_id = (lower(NEW.id));
	END IF;


	-- manage sys_param_user parameters
	IF (TG_OP = 'INSERT' OR  TG_OP = 'UPDATE') THEN

		-- set layoutname
		v_layout = concat('lyt_', lower(NEW.feature_type),'_vdef');

		-- set layoutorder
		SELECT max(layoutorder)+1 INTO v_layoutorder FROM sys_param_user WHERE formname='config' and layoutname=v_layout;

		IF v_layoutorder IS NULL THEN 
			v_layoutorder=1;
		END IF;

		IF v_projecttype = 'WS' THEN
			v_partialquerytext =  concat('JOIN cat_feature ON cat_feature.id = ',
			lower(NEW.feature_type),'type_id WHERE cat_feature.id = ',quote_literal(NEW.id));
			
		ELSIF  v_projecttype = 'UD' THEN
			v_partialquerytext =  concat('LEFT JOIN cat_feature ON cat_feature.id = cat_',lower(NEW.feature_type),'.',lower(NEW.feature_type),'_type ',
			' WHERE cat_feature.id = ',quote_literal(NEW.id));

			-- special case for gully
			IF lower(NEW.feature_type) = 'gully' THEN
				v_partialquerytext = concat('LEFT JOIN cat_feature ON cat_feature.id = cat_grate.gully_type WHERE cat_feature.id = ', quote_literal(NEW.id));
			END IF;
		END IF;

		v_table = concat ('cat_',lower(NEW.feature_type));

		IF v_table = 'cat_node' OR v_table = 'cat_arc' THEN
			v_feature_field_id = concat (lower(NEW.feature_type), 'cat_id');
			
		ELSIF v_table = 'cat_connec' THEN
			v_feature_field_id = concat (lower(NEW.feature_type), 'at_id');

		ELSIF v_table = 'cat_gully' then 
			v_table ='cat_grate'; 
			v_feature_field_id = 'gratecat_id';
			
		END IF;
	
		v_querytext = concat('SELECT ',v_table,'.id, ', v_table,'.id AS idval FROM ', v_table,' ', v_partialquerytext);

		-- insert parameter
		IF TG_OP = 'UPDATE' THEN
			DELETE FROM sys_param_user WHERE id = concat('feat_',lower(OLD.id),'_vdefault');        
		END IF;

		INSERT INTO sys_param_user(id, formname, descript, sys_role, label, isenabled, layoutname, layoutorder,
		dv_querytext, feature_field_id, project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, iseditable)
		VALUES (concat('feat_',v_id,'_vdefault'),'config',concat ('Value default catalog for ',v_id,' cat_feature'), 'role_edit', concat ('Default catalog for ', v_id), true, v_layout ,v_layoutorder,
		v_querytext, v_feature_field_id, lower(v_projecttype),false,false,'text', 'combo', true, true)
		ON CONFLICT (id) DO NOTHING;
	END IF;

	IF TG_OP = 'INSERT' THEN
	
		EXECUTE 'SELECT lower(id) as id, concat(''man_'',lower(id)) as man_table, epa_default, 
		CASE WHEN epa_default IS NOT NULL THEN concat(''inp_'',lower(epa_default)) END AS epa_table 
		FROM sys_feature_cat WHERE id='''||NEW.system_id||''';'
		INTO v_feature;

		IF lower(NEW.feature_type)='arc' THEN
			EXECUTE 'INSERT INTO cat_feature_arc (id, type, man_table, epa_default, epa_table)
			VALUES ('''||NEW.id||''','''||NEW.system_id||''', '''||v_feature.man_table||''',  '''||v_feature.epa_default||''', '''||v_feature.epa_table||''')';
		ELSIF lower(NEW.feature_type)='node' THEN
			EXECUTE 'INSERT INTO cat_feature_node (id, type, man_table,epa_default, epa_table, choose_hemisphere, isarcdivide, num_arcs)
			VALUES ('''||NEW.id||''','''||NEW.system_id||''', '''||v_feature.man_table||''', '''||v_feature.epa_default||''', '''||v_feature.epa_table||''', TRUE, TRUE, 2)';
		ELSIF lower(NEW.feature_type)='connec' THEN
			EXECUTE 'INSERT INTO cat_feature_connec (id, type, man_table)
			VALUES ('''||NEW.id||''','''||NEW.system_id||''', '''||v_feature.man_table||''');';
		ELSIF lower(NEW.feature_type)='gully' THEN
			EXECUTE 'INSERT INTO cat_feature_gully (id, type, man_table)
			VALUES ('''||NEW.id||''','''||NEW.system_id||''', '''||v_feature.man_table||''');';
		END IF;
		--create child view
		v_query='{"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"catFeature":"'||NEW.id||'"}, "data":{"filterFields":{}, "pageInfo":{}, "multi_create":"False" }}';
		PERFORM gw_fct_admin_manage_child_views(v_query::json);
			
		--insert definition into config_info_layer_x_type if its not present already
		IF NEW.child_layer NOT IN (SELECT tableinfo_id from config_info_layer_x_type)
		and NEW.child_layer IS NOT NULL THEN
			INSERT INTO config_info_layer_x_type (tableinfo_id,infotype_id,tableinfotype_id)
			VALUES (NEW.child_layer,1,NEW.child_layer);
		END IF;
	
		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN
		SELECT child_layer INTO v_viewname FROM cat_feature WHERE id = NEW.id;
		-- update child views
		--on update and change of cat_feature.id or child layer name
		IF NEW.id != OLD.id THEN	

			--if cat_feature has changed, rename the id in the definition of a child view
			IF NEW.id != OLD.id THEN

				IF v_viewname IS NOT NULL THEN

					IF  (SELECT EXISTS (SELECT FROM information_schema.tables WHERE  table_schema = 'SCHEMA_NAME'
					AND table_name = v_viewname)) = true THEN

						--get the old view definition
						EXECUTE 'SELECT pg_get_viewdef('''||v_schemaname||'.'||v_viewname||''', true);'
						INTO v_definition;

						--replace cat_feature.id in the view definition
						v_definition = replace(v_definition,quote_literal(OLD.id),quote_literal(NEW.id));

						--replace the existing view and drop the old trigger
						EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||NEW.child_layer||' AS '||v_definition||';';   
						EXECUTE 'DROP TRIGGER IF EXISTS gw_trg_edit_'||lower(NEW.feature_type)||'_'||lower(OLD.id)||' ON '||v_viewname||';';

						EXECUTE 'CREATE TRIGGER gw_trg_edit_'||lower(NEW.feature_type)||'_'||lower(NEW.id)||'
						INSTEAD OF INSERT OR UPDATE OR DELETE ON '||v_viewname||' FOR EACH ROW EXECUTE 
						PROCEDURE gw_trg_edit_'||lower(NEW.feature_type)||'('''||NEW.id||''');';

					ELSE
		
						v_query='{"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"catFeature":"'||NEW.id||'"}, 
						"data":{"filterFields":{}, "pageInfo":{}, "multi_create":"False" }}';
						PERFORM gw_fct_admin_manage_child_views(v_query::json);

						--insert definition into config_info_layer_x_type if its not present already
						IF NEW.child_layer NOT IN (SELECT tableinfo_id from config_info_layer_x_type)
						and NEW.child_layer IS NOT NULL THEN
							INSERT INTO config_info_layer_x_type (tableinfo_id,infotype_id,tableinfotype_id)
							VALUES (NEW.child_layer,1,NEW.child_layer);
						END IF;

						EXECUTE 'DROP TRIGGER IF EXISTS gw_trg_edit_'||lower(NEW.feature_type)||'_'||lower(OLD.id)||' ON '||v_viewname||';';

					END IF;

				END IF;

				
			END IF;
			


		--if child layer name has changed, rename it
		ELSIF NEW.child_layer != OLD.child_layer  AND NEW.child_layer IS NOT NULL THEN


			IF v_viewname IS NOT NULL THEN
				IF  (SELECT EXISTS (SELECT FROM information_schema.tables WHERE  table_schema = 'SCHEMA_NAME'
				AND table_name = v_viewname)) = true THEN
		
					--get the old view definition
					EXECUTE 'SELECT pg_get_viewdef('''||v_schemaname||'.'||OLD.child_layer||''', true);'
					INTO v_definition;	

					--replace the existing view
					EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||NEW.child_layer||' AS '||v_definition||';';   
					EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||OLD.child_layer||';';
					EXECUTE 'DROP TRIGGER IF EXISTS gw_trg_edit_'||lower(NEW.feature_type)||'_'||lower(OLD.id)||' ON '||v_viewname||';';

					EXECUTE 'CREATE TRIGGER gw_trg_edit_'||lower(NEW.feature_type)||'_'||lower(NEW.id)||'
					INSTEAD OF INSERT OR UPDATE OR DELETE ON '||lowe(NEW.child_layer)||' FOR EACH ROW EXECUTE 
					PROCEDURE gw_trg_edit_'||lower(NEW.feature_type)||'('''||NEW.id||''');';

				ELSE
	
					EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||OLD.child_layer||';';
					v_query='{"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"catFeature":"'||NEW.id||'"}, 
					"data":{"filterFields":{}, "pageInfo":{}, "multi_create":"False" }}';
					PERFORM gw_fct_admin_manage_child_views(v_query::json);

					--insert definition into config_info_layer_x_type if its not present already
					IF NEW.child_layer NOT IN (SELECT tableinfo_id from config_info_layer_x_type)
					and NEW.child_layer IS NOT NULL THEN
						INSERT INTO config_info_layer_x_type (tableinfo_id,infotype_id,tableinfotype_id)
						VALUES (NEW.child_layer,1,NEW.child_layer) ON CONFLICT (tableinfo_id) DO NOTHING;
					END IF;

				END IF;
			END IF;

			--delete configuration from config_form_fields
			DELETE FROM config_form_fields where formname=OLD.child_layer AND formtype = 'form_feature';

			--delete definition from config_info_layer_x_type
			DELETE FROM config_info_layer_x_type where tableinfo_id=OLD.child_layer OR tableinfotype_id=OLD.child_layer;

			EXECUTE 'SELECT gw_fct_admin_manage_child_config($${"client":{"device":4, "infoType":1, "lang":"ES"},
			"form":{}, 	"feature":{"catFeature":"'||NEW.id||'"},
			"data":{"filterFields":{}, "pageInfo":{}, "view_name":"'||NEW.child_layer||'", 
			"feature_type":"'||lower(NEW.feature_type)||'" }}$$);';


		ELSIF NEW.feature_type !=OLD.feature_type or NEW.system_id !=OLD.system_id THEN

			EXECUTE 'DROP VIEW IF EXISTS '||NEW.child_layer||';';
			
			--delete configuration from config_form_fields
			DELETE FROM config_form_fields where formname=NEW.child_layer AND formtype = 'form_feature';

			--delete definition from config_info_layer_x_type
			DELETE FROM config_info_layer_x_type where tableinfo_id=NEW.child_layer OR tableinfo_id=OLD.child_layer;
			
			EXECUTE 'SELECT lower(id) as id, concat(''man_'',lower(id)) as man_table, epa_default, 
			CASE WHEN epa_default IS NOT NULL THEN concat(''inp_'',lower(epa_default)) END AS epa_table 
			FROM sys_feature_cat WHERE id='''||NEW.system_id||''';'
			INTO v_feature;
			
			v_new_child_layer = replace(NEW.child_layer,lower(OLD.feature_type),lower(NEW.feature_type));
			
			EXECUTE 'UPDATE cat_feature SET parent_layer = concat(''v_edit_'','''||lower(NEW.feature_type)||'''),
			child_layer = '''||v_new_child_layer||''' WHERE id = '''||NEW.id||''';';
			
			EXECUTE 'DELETE FROM cat_feature_'||lower(OLD.feature_type)||' WHERE id = '''||NEW.id||''';';

			IF lower(NEW.feature_type)='arc' THEN
				EXECUTE 'INSERT INTO cat_feature_arc (id,type,man_table,epa_default,epa_table)
				VALUES ('''||NEW.id||''', '''||NEW.system_id||''','''||v_feature.man_table||''','''||v_feature.epa_default||''','''||v_feature.epa_table||''')';
			ELSIF lower(NEW.feature_type)='node' THEN
				EXECUTE 'INSERT INTO cat_feature_node (id, type, man_table,epa_default, epa_table, choose_hemisphere, isarcdivide, num_arcs)
				VALUES ('''||NEW.id||''','''||NEW.system_id||''', '''||v_feature.man_table||''', '''||v_feature.epa_default||''', '''||v_feature.epa_table||''', TRUE, TRUE, 2)';
			ELSIF lower(NEW.feature_type)='connec' THEN
				EXECUTE 'INSERT INTO cat_feature_connec (id, type, man_table)
				VALUES ('''||NEW.id||''','''||NEW.system_id||''', '''||v_feature.man_table||''');';
			ELSIF lower(NEW.feature_type)='gully' THEN
				EXECUTE 'INSERT INTO cat_feature_gully (id, type, man_table)
				VALUES ('''||NEW.id||''','''||NEW.system_id||''', '''||v_feature.man_table||''');';
			END IF;

			--delete configuration from config_form_fields
			DELETE FROM config_form_fields where formname=OLD.child_layer AND formtype = 'form_feature';

			--create child view
			v_query='{"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{"catFeature":"'||NEW.id||'"}, "data":{"filterFields":{}, "pageInfo":{}, "multi_create":"False" }}';
			PERFORM gw_fct_admin_manage_child_views(v_query::json);

	
		END IF;

		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		-- delete child views
		EXECUTE 'DROP VIEW IF EXISTS '||OLD.child_layer||';';
		
		--delete configuration from config_form_fields
		DELETE FROM config_form_fields where formname=OLD.child_layer AND formtype = 'form_feature';

		--delete definition from config_info_layer_x_type
		DELETE FROM config_info_layer_x_type where tableinfo_id=OLD.child_layer OR tableinfotype_id=OLD.child_layer;

		-- delete sys_param_user parameters
		DELETE FROM sys_param_user WHERE id = concat('feat_',lower(OLD.id),'_vdefault');

		RETURN NULL;

	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;