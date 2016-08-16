/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_connec_update() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    querystring Varchar; 
    linkrec Record; 
    connecRecord Record; 


BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    -- Select links with start-end on the updated connec
    querystring := 'SELECT * FROM link WHERE link.connec_id = ' || quote_literal(NEW.connec_id); 

    FOR linkrec IN EXECUTE querystring
    LOOP

        -- Initial and final connec of the link
        SELECT * INTO connecRecord FROM connec WHERE connec.connec_id = linkrec.connec_id;
        

        -- Control de lineas de longitud 0
        IF (connecRecord.connec_id IS NOT NULL)  THEN
			EXECUTE 'UPDATE link SET the_geom = ST_SetPoint($1, 0, $2) WHERE link_id = ' || quote_literal(linkrec."link_id") USING linkrec.the_geom, NEW.the_geom; 
        END IF;

    END LOOP; 

    RETURN NEW;
    
END; 
$$;



CREATE TRIGGER gw_trg_connec_update AFTER UPDATE OF the_geom ON "SCHEMA_NAME"."connec" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_connec_update"();
