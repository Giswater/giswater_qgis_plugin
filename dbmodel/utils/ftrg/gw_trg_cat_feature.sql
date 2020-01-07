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
	v_sql text;
	v_layout integer;
	v_projecttype text;
	v_layout_order integer;
	v_partialquerytext text;
	v_querytext text;
	v_table text;

BEGIN	

	
	-- search path
	SET search_path = "SCHEMA_NAME", public;

	-- get input parameters
	v_schemaname = 'SCHEMA_NAME';

	--  Get project type
	SELECT wsoftware INTO v_projecttype FROM version LIMIT 1;

	--Controls on update or insert of cat_feature.id check if the new id or child layer has accents, dots or dashes. If so, give an error.
	v_id = array_to_string(ts_lexize('unaccent',NEW.id),',','*');
	
	IF v_id IS NOT NULL OR NEW.id ilike '%.%' OR NEW.id ilike '%-%' THEN
		PERFORM audit_function(3038,2758,NEW.id);
	END IF;

	v_id = array_to_string(ts_lexize('unaccent',NEW.child_layer),',','*');
	
	IF v_id IS NOT NULL OR NEW.child_layer ilike '%-%' OR NEW.child_layer ilike '%.%' THEN
	 	PERFORM audit_function(3038,2758,NEW.child_layer);
	END IF;	

	-- set v_id
	v_id = (lower(NEW.id));


	-- manage audit_cat_param_user parameters
	IF (TG_OP = 'INSERT' OR  TG_OP = 'UPDATE') AND v_projecttype='WS' THEN

		-- get layout_id
		IF NEW.feature_type='NODE' THEN
			v_layout = 9;
		ELSIF  NEW.feature_type='ARC' THEN
			v_layout = 10;
		ELSIF NEW.feature_type='CONNEC' THEN
			v_layout = 12;
		END IF;

		-- get layout_order
		SELECT max(layout_order)+1 INTO v_layout_order FROM audit_cat_param_user WHERE formname='config' and layout_id=v_layout;
	
		v_partialquerytext =  concat('JOIN ',lower(NEW.feature_type),'_type ON ',lower(NEW.feature_type),'_type.id = ',
		lower(NEW.feature_type),'type_id WHERE ',lower(NEW.feature_type),'_type.id = ',quote_literal(NEW.id));
				
		v_table = concat ('cat_',lower(NEW.feature_type));

		IF v_table = 'cat_gully' then v_table ='cat_grate'; end if;
		
		v_querytext = concat('SELECT ',v_table,'.id, ', v_table,'.id AS idval FROM ', v_table,' ', v_partialquerytext);

		-- insert parameter
		INSERT INTO audit_cat_param_user(id, formname, description, sys_role_id, label, isenabled, layout_id, layout_order, 
		dv_querytext, project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, isdeprecated)
		VALUES (concat(v_id,'_vdefault'),'config',concat ('Value default for ',v_id,' cat_feature'), 'role_edit', concat ('Default value for ', v_id), true, v_layout ,v_layout_order,
		v_querytext, lower(v_projecttype),false,false,'text', 'combo',true,false)
		ON CONFLICT (id) DO NOTHING;

		IF TG_OP = 'UPDATE' THEN
			DELETE FROM audit_cat_param_user WHERE id = concat(lower(OLD.id),'_vdefault');
		END IF;
	END IF;

	IF TG_OP = 'INSERT' THEN

		RETURN new;

	ELSIF TG_OP = 'UPDATE' THEN

		-- update child views
		--on update and change of cat_feature.id or child layer name		
		IF NEW.child_layer != OLD.child_layer or NEW.id != OLD.id THEN
		
			SELECT child_layer INTO v_viewname FROM cat_feature WHERE id = NEW.id;

			--if cat_feature has changed, rename the id in the definition of a child view
			IF NEW.id != OLD.id THEN
				
				IF v_viewname IS NOT NULL THEN
					--get the old view definition
					EXECUTE 'SELECT pg_get_viewdef('''||v_schemaname||'.'||v_viewname||''', true);'
					INTO v_definition;		

					--replace cat_feture.id in the view definition
					v_definition = replace(v_definition,quote_literal(OLD.id),quote_literal(NEW.id));

					--replace the existing view and drop the old trigger
					EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||NEW.child_layer||' AS '||v_definition||';';   
					EXECUTE 'DROP TRIGGER IF EXISTS gw_trg_edit_'||lower(NEW.feature_type)||'_'||lower(OLD.id)||' ON '||v_viewname||';';		

				END IF;
			END IF;

			--if child layer name has changed, rename it
			IF NEW.child_layer != OLD.child_layer THEN

				--SELECT child_layer INTO v_viewname FROM cat_feature WHERE id = NEW.id;

				IF v_viewname IS NOT NULL THEN
					--get the old view definition
					EXECUTE 'SELECT pg_get_viewdef('''||v_schemaname||'.'||OLD.child_layer||''', true);'
					INTO v_definition;	

					--replace the existing view
					EXECUTE 'CREATE OR REPLACE VIEW '||v_schemaname||'.'||NEW.child_layer||' AS '||v_definition||';';   
					EXECUTE 'DROP VIEW '||v_schemaname||'.'||OLD.child_layer||';';
				END IF;
			END IF;
		
			--create the trigger
			IF v_viewname IS NOT NULL THEN
				EXECUTE 'CREATE TRIGGER gw_trg_edit_'||lower(NEW.feature_type)||'_'||lower(NEW.id)||'
				INSTEAD OF INSERT OR UPDATE OR DELETE ON '||v_viewname||' FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('''||NEW.id||''');';
			END IF;
		END IF;
		
		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		-- delete child views

		-- delete audit_cat_param_user parameters
		IF v_projecttype='WS' THEN
			DELETE FROM audit_cat_param_user WHERE id = concat(lower(OLD.id),'_vdefault');
		END IF;

		RETURN NULL;

	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;