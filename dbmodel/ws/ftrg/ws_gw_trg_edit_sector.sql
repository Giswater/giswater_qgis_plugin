/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 1124

-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_sector();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_sector()
  RETURNS trigger AS
$BODY$
DECLARE 
v_querytext text;
v_row record;
v_sector_id integer[];

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	IF TG_OP = 'INSERT' THEN

		IF NEW.sector_id IS NULL THEN
			NEW.sector_id=(SELECT nextval('SCHEMA_NAME.sector_sector_id_seq'::regclass));
		END IF;

		INSERT INTO sector (sector_id, name, descript, macrosector_id, the_geom, undelete, grafconfig, stylesheet, active, parent_id)
		VALUES (NEW.sector_id, NEW.name, NEW.descript, NEW.macrosector_id, NEW.the_geom, NEW.undelete, 
		NEW.grafconfig::json, NEW.stylesheet::json, NEW.active, NEW.parent_id);
				
	ELSIF TG_OP = 'UPDATE' THEN

		UPDATE sector 
		SET sector_id=NEW.sector_id, name=NEW.name, descript=NEW.descript, macrosector_id=NEW.macrosector_id, the_geom=NEW.the_geom, 
		undelete=NEW.undelete, grafconfig=NEW.grafconfig::json, stylesheet = NEW.stylesheet::json, active = NEW.active, parent_id = NEW.parent_id
		WHERE sector_id=OLD.sector_id;
				
	ELSIF TG_OP = 'DELETE' THEN  

		DELETE FROM sector WHERE sector_id = OLD.sector_id;

	END IF;

	-- manage admin_exploitation_x_user
	IF (SELECT value::boolean FROM config_param_system WHERE parameter = 'admin_exploitation_x_user') THEN

		IF TG_OP = 'INSERT' THEN
		
			v_querytext = 'SELECT * FROM cat_manager WHERE id IN (SELECT id FROM (SELECT id, unnest(sector_id) sector_id FROM cat_manager)a WHERE sector_id = '||NEW.parent_id||')';
			FOR v_row IN EXECUTE v_querytext
			LOOP
				v_sector_id = array_append (v_row.sector_id, NEW.sector_id);
				UPDATE cat_manager SET sector_id = v_sector_id WHERE id = v_row.id;
			END LOOP;	
			INSERT INTO selector_sector VALUES (NEW.sector_id, current_user);
			
			RETURN NEW;

		ELSIF TG_OP = 'UPDATE' THEN

			IF (NEW.parent_id <> OLD.parent_id) OR (NEW.parent_id IS NULL AND OLD.parent_id IS NOT NULL) OR (OLD.parent_id IS NULL AND NEW.parent_id IS NOT NULL) THEN

				v_querytext = 'SELECT * FROM cat_manager WHERE id IN (SELECT id FROM (SELECT id, unnest(sector_id) sector_id FROM cat_manager)a WHERE sector_id = '||OLD.sector_id||')';
				FOR v_row IN EXECUTE v_querytext
				LOOP
					v_sector_id = array_remove (v_row.sector_id, OLD.sector_id);
					UPDATE cat_manager SET sector_id = v_sector_id WHERE id = v_row.id;
				END LOOP;
			
				v_querytext = 'SELECT * FROM cat_manager WHERE id IN (SELECT id FROM (SELECT id, unnest(sector_id) sector_id FROM cat_manager)a WHERE sector_id = '||NEW.parent_id||')';
				FOR v_row IN EXECUTE v_querytext
				LOOP
					v_sector_id = array_append (v_row.sector_id, NEW.sector_id);
					UPDATE cat_manager SET sector_id = v_sector_id WHERE id = v_row.id;
				END LOOP;	
			END IF;
			
			RETURN NEW;
		ELSE
			v_querytext = 'SELECT * FROM cat_manager WHERE id IN (SELECT id FROM (SELECT id, unnest(sector_id) sector_id FROM cat_manager)a WHERE sector_id = '||OLD.sector_id||')';
			FOR v_row IN EXECUTE v_querytext
			LOOP
				v_sector_id = array_remove (v_row.sector_id, OLD.sector_id);
				UPDATE cat_manager SET sector_id = v_sector_id WHERE id = v_row.id;
			END LOOP;
			RETURN NULL;	
		END IF;
	ELSE 
		IF TG_OP ='INSERT'THEN
			INSERT INTO selector_sector VALUES (NEW.sector_id, current_user);
			RETURN NEW;
			
		ELSIF TG_OP ='UPDATE' THEN
			RETURN NEW;
		ELSE
			RETURN NULL;
		END IF;	
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;