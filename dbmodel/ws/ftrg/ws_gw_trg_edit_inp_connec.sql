/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION NODE: 2730


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_inp_connec() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
       
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN
        PERFORM audit_function(1030,1310); 
        RETURN NEW;
		

    ELSIF TG_OP = 'UPDATE' THEN
		
		-- The geom
		IF (ST_equals (NEW.the_geom, OLD.the_geom) IS FALSE THEN
			UPDATE connec SET the_geom=NEW.the_geom WHERE connec_id = OLD.connec_id;
		END IF;

        UPDATE inp_connec 
		SET demand=NEW.demand, pattern_id=NEW.pattern_id 
		WHERE connec_id=OLD.connec_id;
     
        UPDATE connec 
        SET elevation=NEW.elevation, "depth"=NEW."depth", annotation=NEW.annotation
        WHERE connec_id=OLD.connec_id;

        RETURN NEW;
        
    ELSIF TG_OP = 'DELETE' THEN
        PERFORM audit_function(1032,1310); 
        RETURN NEW;
    
    END IF;
       
END;
$$;
  