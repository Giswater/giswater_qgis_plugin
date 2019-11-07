/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2758


--drop function SCHEMA_NAME.gw_trg_update_child_view();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_update_child_view()
  RETURNS trigger AS
$BODY$


DECLARE 
	v_schemaname text;
	v_viewname text;
	v_definition text;
	v_unaccent_id text;
	v_sql text;
BEGIN	

	
	-- search path
	SET search_path = "SCHEMA_NAME", public;

	-- get input parameters
	v_schemaname = 'SCHEMA_NAME';

	--on update or insert of cat_feature.id check if the new id or child layer has accents, dots or dashes. If so, give an error.
	IF TG_OP = 'UPDATE' OR TG_OP = 'INSERT' THEN
	
		v_unaccent_id = array_to_string(ts_lexize('unaccent',NEW.id),',','*');
		
		IF v_unaccent_id IS NOT NULL OR NEW.id ilike '%.%' OR NEW.id ilike '%-%' THEN
			PERFORM audit_function(3038,2758,NEW.id);
		END IF;

		v_unaccent_id = array_to_string(ts_lexize('unaccent',NEW.child_layer),',','*');
		
		IF v_unaccent_id IS NOT NULL OR NEW.child_layer ilike '%-%' OR NEW.child_layer ilike '%.%' THEN
		 	PERFORM audit_function(3038,2758,NEW.child_layer);
		END IF;
	
	END IF;

	--on update and change of cat_feature.id or child layer name
	IF TG_OP = 'UPDATE' THEN
		IF NEW.child_layer != OLD.child_layer or NEW.id != OLD.id THEN

			--if cat_feature has changed, rename the id in the definition of a child view
			IF NEW.id != OLD.id THEN

				SELECT child_layer INTO v_viewname FROM cat_feature WHERE id = NEW.id;
				
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

				SELECT child_layer INTO v_viewname FROM cat_feature WHERE id = NEW.id;

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
			EXECUTE 'CREATE TRIGGER gw_trg_edit_'||lower(NEW.feature_type)||'_'||lower(NEW.id)||'
			INSTEAD OF INSERT OR UPDATE OR DELETE ON '||v_viewname||' FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_node('''||NEW.id||''');';
			

		END IF;
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


