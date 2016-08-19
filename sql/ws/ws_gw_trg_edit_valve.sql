/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_valve() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    v_sql varchar;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN

         RAISE EXCEPTION '[%]:En esta capa no puedes insertar valvulas', TG_NAME;
        RETURN NEW;


    ELSIF TG_OP = 'UPDATE' THEN


        -- UPDATE position 
        IF  (NEW.the_geom IS DISTINCT FROM OLD.the_geom) OR 
			(NEW.node_id IS DISTINCT FROM OLD.node_id) OR 
			(NEW.nodetype_id IS DISTINCT FROM OLD.nodetype_id) OR
			(NEW.type IS DISTINCT FROM OLD.type) THEN   
         RAISE EXCEPTION '[%]:Los campos de caracaterísticas no son editables. Prueba solo con open, accesibility & broken', TG_NAME;          
		END IF;

        UPDATE man_valve 
        SET opened=NEW.opened, acessibility=NEW.acessibility, "broken"=NEW."broken"
        WHERE node_id = OLD.node_id;
                
        RETURN NEW;;
    

    ELSIF TG_OP = 'DELETE' THEN

        RAISE EXCEPTION '[%]:En esta capa no puedes borrar valvulas', TG_NAME;
        RETURN NEW;
   
    END IF;

END;
$$;



CREATE TRIGGER gw_trg_edit_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_valve
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_valve();