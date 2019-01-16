/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1114


-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_element();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_element()
  RETURNS trigger AS
$BODY$
DECLARE 
	element_seq int8;
	expl_id_int integer;
	code_autofill_bool boolean;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

-- INSERT

	IF TG_OP = 'INSERT' THEN

		-- Cat element
		IF (NEW.elementcat_id IS NULL) THEN
			NEW.elementcat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='elementcat_vdefault' AND "cur_user"="current_user"() LIMIT 1);
		END IF;
	
	
		-- Verified
		IF (NEW.verified IS NULL) THEN
			NEW.verified := (SELECT "value" FROM config_param_user WHERE "parameter"='verified_vdefault' AND "cur_user"="current_user"() LIMIT 1);
		END IF;
	
		-- State
		IF (NEW.state IS NULL) THEN
			NEW.state := (SELECT "value" FROM config_param_user WHERE "parameter"='state_vdefault' AND "cur_user"="current_user"());
		END IF;
	
		-- Exploitation
		IF (NEW.expl_id IS NULL) THEN
			NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='exploitation_vdefault' AND "cur_user"="current_user"());
			IF (NEW.expl_id IS NULL) THEN
				NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				IF (NEW.expl_id IS NULL) THEN
					PERFORM audit_function(2012,1114, NEW.element_id);
				END IF;		
			END IF;
		END IF;		

		-- Enddate
		IF (NEW.state > 0) THEN
			NEW.enddate := NULL;
		END IF;

		--Inventory	
		NEW.inventory := (SELECT "value" FROM config_param_system WHERE "parameter"='edit_inventory_sysvdefault');

		--Publish
		NEW.publish := (SELECT "value" FROM config_param_system WHERE "parameter"='edit_publish_sysvdefault');	

		-- Element id 
		IF (NEW.element_id IS NULL) THEN
			NEW.element_id:= (SELECT nextval('urn_id_seq'));
		END IF;
		
		SELECT code_autofill INTO code_autofill_bool FROM element_type join cat_element on element_type.id=cat_element.elementtype_id where cat_element.id=NEW.elementcat_id;

		--Copy id to code field
		IF (NEW.code IS NULL AND code_autofill_bool IS TRUE) THEN 
			NEW.code=NEW.element_id;
		END IF;

		-- LINK
	    IF (SELECT "value" FROM config_param_system WHERE "parameter"='edit_automatic_insert_link')::boolean=TRUE THEN
	       NEW.link=NEW.element_id;
	    END IF;
		

		-- FEATURE INSERT      

		INSERT INTO element (element_id, code, elementcat_id, serial_number, "state", state_type, observ, "comment", function_type, category_type, location_type, 
		workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, rotation, link, verified, the_geom, label_x, label_y, label_rotation, publish, 
		inventory, undelete, expl_id, num_elements)
		VALUES (NEW.element_id, NEW.code, NEW.elementcat_id, NEW.serial_number, NEW."state", NEW.state_type, NEW.observ, NEW."comment", 
		NEW.function_type, NEW.category_type, NEW.location_type, NEW.workcat_id, NEW.workcat_id_end, NEW.buildercat_id, NEW.builtdate, NEW.enddate, 
		NEW.ownercat_id, NEW.rotation, NEW.link, NEW.verified, NEW.the_geom, NEW.label_x, NEW.label_y, NEW.label_rotation, NEW.publish, 
		NEW.inventory, NEW.undelete, NEW.expl_id, NEW.num_elements);
			
		RETURN NEW;
						

	-- UPDATE
	ELSIF TG_OP = 'UPDATE' THEN

		UPDATE element
		SET element_id=NEW.element_id, code=NEW.code,  elementcat_id=NEW.elementcat_id, serial_number=NEW.serial_number, "state"=NEW."state", state_type=NEW.state_type, observ=NEW.observ, "comment"=NEW."comment", 
		function_type=NEW.function_type, category_type=NEW.category_type,  location_type=NEW.location_type, workcat_id=NEW.workcat_id, workcat_id_end=NEW.workcat_id_end, 
		buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate, enddate=NEW.enddate, ownercat_id=NEW.ownercat_id, rotation=NEW.rotation, link=NEW.link, verified=NEW.verified, 
		the_geom=NEW.the_geom, label_x=NEW.label_x, label_y=NEW.label_y, label_rotation=NEW.label_rotation, publish=NEW.publish, inventory=NEW.inventory, undelete=NEW.undelete,expl_id=NEW.expl_id, num_elements=NEW.num_elements
		WHERE element_id=OLD.element_id;

        RETURN NEW;
    

	-- DELETE
	ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM element WHERE element_id=OLD.element_id;

        RETURN NULL;
   
	END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

