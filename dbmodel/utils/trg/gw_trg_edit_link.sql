/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

   
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_link() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    v_sql varchar;
	expl_id_int integer;
	
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
	
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN

			--Exploitation ID
            IF ((SELECT COUNT(*) FROM exploitation) = 0) THEN
                --PERFORM audit_function(125,340);
				RETURN NULL;				
            END IF;
            expl_id_int := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
            IF (expl_id_int IS NULL) THEN
                --PERFORM audit_function(130,340);
				RETURN NULL; 
            END IF;
	
	
        -- link ID
		IF (NEW.link_id IS NULL) THEN
				PERFORM setval('urn_id_seq', gw_fct_urn(),true);
				NEW.link_id:= (SELECT nextval('urn_id_seq'));
			END IF;
               
        INSERT INTO link (link_id, connec_id, vnode_id, custom_length, the_geom, expl_id)
		VALUES (NEW.link_id, NEW.connec_id, NEW.vnode_id, NEW.custom_length, NEW.the_geom, expl_id_int);
		
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
		UPDATE link 
		SET link_id=NEW.link_id, connec_id=NEW.connec_id, vnode_id=NEW.vnode_id, custom_length=NEW.custom_length, the_geom=NEW.the_geom, expl_id=NEW.expl_id
		WHERE link_id=OLD.link_id;			
                
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM link WHERE link_id = OLD.link_id;
        RETURN NULL;
   
    END IF;

END;
$$;


DROP TRIGGER IF EXISTS gw_trg_edit_link ON "SCHEMA_NAME".v_edit_link;
CREATE TRIGGER gw_trg_edit_link INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_link
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_link();

      