/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_nodarc_update() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    numArcs Integer;

BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    IF (NEW.epa_type='VALVE'::text) OR (NEW.epa_type='PUMP'::text) OR (NEW.epa_type='SHORT_PIPE'::text) THEN
        SELECT COUNT (*) INTO numArcs FROM arc WHERE arc.node_1=Old.node_id OR arc.node_2=OLD.node_id;
        IF (numArcs = 2) THEN
            -- node is a nodarc2 with two arcs and will proceed to update
            RETURN NEW; 
        ELSE
            -- node is a nodarc2 but don't have two arcs and shouldn't be updated
            RAISE EXCEPCION '[%]; The node have not two arcs. Please check it', TG_NAME;            
            RETURN NULL;
        END IF;
    END IF;
    
    -- node is a normal node and it could be updated
    RETURN NEW;
    
END; 
$$;


-- CREATE TRIGGER gw_trg_nodarc_update BEFORE INSERT ON "SCHEMA_NAME"."node" FOR EACH ROW WHEN (((NEW.epa_type IS DISTINCT OLD.epa_type))) EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_nodarc_update"();

