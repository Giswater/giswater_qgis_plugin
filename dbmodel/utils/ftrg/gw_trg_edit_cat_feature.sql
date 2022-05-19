/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3146

CREATE OR REPLACE FUNCTION "ws_sample".gw_trg_edit_cat_feature()
  RETURNS trigger AS
$BODY$
DECLARE 

v_table text;
v_project_type text;
v_version text;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	v_table:= TG_ARGV[0];

		SELECT lower(project_type), giswater  INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	IF TG_OP = 'INSERT' THEN

		-- control nulls
		IF NEW.code_autofill IS NULL THEN NEW.code_autofill=true; END IF;
		IF NEW.active IS NULL THEN NEW.active=true; END IF;
	
		INSERT INTO cat_feature(id, system_id, shortcut_key, descript, link_path, code_autofill, active)
		VALUES (NEW.id, NEW.system_id, NEW.shortcut_key, NEW.descript, NEW.link_path, NEW.code_autofill, NEW.active);

		IF v_table='arc' THEN

			UPDATE cat_feature_arc SET epa_default=NEW.epa_default WHERE id=NEW.id;

		ELSIF v_table='connec' THEN

			IF v_project_type='ws' THEN
				UPDATE cat_feature_connec SET epa_default=NEW.epa_default WHERE id=NEW.id;
			ELSIF v_project_type='ud' THEN
				UPDATE cat_feature_connec SET double_geom=NEW.double_geom::json WHERE id=NEW.id;
			END IF;

		ELSIF v_table='node' THEN

			-- control nulls
			IF NEW.choose_hemisphere IS NULL THEN NEW.choose_hemisphere=true; END IF;
			IF NEW.isprofilesurface IS NULL THEN NEW.isprofilesurface=true; END IF;
			IF NEW.isarcdivide IS NULL THEN NEW.isarcdivide=true; END IF;
			IF NEW.double_geom IS NULL THEN NEW.double_geom='{"activated":false,"value":1}'; END IF;
			IF NEW.num_arcs IS NULL THEN NEW.num_arcs=9; END IF;

			IF v_project_type='ws' THEN

				-- control nulls
				IF NEW.graf_delimiter IS NULL THEN NEW.graf_delimiter='NONE'; END IF;
			
				UPDATE cat_feature_node SET epa_default=NEW.epa_default, isarcdivide=NEW.isarcdivide, isprofilesurface=NEW.isprofilesurface, choose_hemisphere=NEW.choose_hemisphere, 
				double_geom=NEW.double_geom::json, num_arcs=NEW.num_arcs, graf_delimiter=NEW.graf_delimiter  WHERE id=NEW.id;

			ELSIF v_project_type='ud' THEN
			
				-- control nulls
				IF NEW.exitupperintro IS NULL THEN NEW.exitupperintro='0'; END IF;
			
				UPDATE cat_feature_node SET epa_default=NEW.epa_default, isarcdivide=NEW.isarcdivide, isprofilesurface=NEW.isprofilesurface, choose_hemisphere=NEW.choose_hemisphere, 
				double_geom=NEW.double_geom::json, num_arcs=NEW.num_arcs, isexitupperintro=NEW.isexitupperintro  WHERE id=NEW.id;
			END IF;

		ELSIF v_table='gully' THEN

			IF NEW.double_geom IS NULL THEN NEW.double_geom='{"activated":false,"value":1}'; END IF;

			UPDATE cat_feature_gully SET epa_default=NEW.epa_default, double_geom=NEW.double_geom::json WHERE id=NEW.id;
		END IF;

		RETURN NEW;
		
	ELSIF TG_OP = 'UPDATE' THEN
		
		UPDATE cat_feature SET id=NEW.id, system_id=NEW.system_id, shortcut_key=NEW.shortcut_key, descript=NEW.descript, link_path=NEW.link_path, 
		code_autofill=NEW.code_autofill, active=NEW.active WHERE id=OLD.id;

		IF v_table='arc' THEN
			
			UPDATE cat_feature_arc SET epa_default=NEW.epa_default WHERE id=NEW.id;

		ELSIF v_table='connec' THEN
  	
			IF v_project_type='ws' THEN
				UPDATE cat_feature_connec SET epa_default=NEW.epa_default WHERE id=NEW.id;
			ELSIF v_project_type='ud' THEN
				UPDATE cat_feature_connec SET double_geom=NEW.double_geom::json WHERE id=NEW.id;
			END IF;

		ELSIF v_table='node' THEN

			IF v_project_type='ws' THEN
				UPDATE cat_feature_node SET epa_default=NEW.epa_default, isarcdivide=NEW.isarcdivide, isprofilesurface=NEW.isprofilesurface, choose_hemisphere=NEW.choose_hemisphere, 
				double_geom=NEW.double_geom::json, num_arcs=NEW.num_arcs, graf_delimiter=NEW.graf_delimiter  WHERE id=NEW.id;

			ELSIF v_project_type='ud' THEN
				UPDATE cat_feature_node SET epa_default=NEW.epa_default, isarcdivide=NEW.isarcdivide, isprofilesurface=NEW.isprofilesurface, choose_hemisphere=NEW.choose_hemisphere, 
				double_geom=NEW.double_geom::json, num_arcs=NEW.num_arcs, isexitupperintro=NEW.isexitupperintro  WHERE id=NEW.id;
			END IF;

		ELSIF v_table='gully' THEN
  	
			UPDATE cat_feature_connec SET epa_default=NEW.epa_default, double_geom=NEW.double_geom::json WHERE id=NEW.id;

			END IF;

		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN 
		
		IF v_table='arc' THEN

			DELETE FROM cat_feature_arc WHERE id = OLD.id;

		ELSIF v_table='connec' THEN

			DELETE FROM cat_feature_connec WHERE id = OLD.id;

		ELSIF v_table='node' THEN

			DELETE FROM cat_feature_node WHERE id = OLD.id;
		END IF;

		DELETE FROM cat_feature WHERE id = OLD.id;

		RETURN NULL;
	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;