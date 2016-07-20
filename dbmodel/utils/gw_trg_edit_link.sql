/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

   
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_link() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    v_sql varchar;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN

        -- link ID
        IF (NEW.link_id IS NULL) THEN
            NEW.link_id:= (SELECT nextval('link_seq'));
        END IF;
               
        INSERT INTO link VALUES (NEW.link_id, NEW.the_geom, NEW.connec_id, NEW.vnode_id, NEW.custom_length);
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE link 
        SET link_id=NEW.link_id, the_geom=NEW.the_geom, connec_id=NEW.connec_id, vnode_id=NEW.vnode_id, custom_length=NEW.custom_length
        WHERE link_id = OLD.link_id;
                
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM link WHERE link_id = OLD.link_id;
        RETURN NULL;
   
    END IF;

END;
$$;



CREATE TRIGGER gw_trg_edit_link INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_link
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_link();

      