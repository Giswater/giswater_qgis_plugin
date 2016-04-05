/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_connec_insert() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    arcrec Record;
    rec Record;

BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    -- Get node tolerance from config table
    SELECT connec_buffering INTO rec FROM config;
    -- Get arc
    SELECT * INTO arcrec FROM arc 
    WHERE ST_Dwithin(NEW.the_geom, arc.the_geom, rec.connec_buffering) 
    ORDER BY ST_Distance(NEW.the_geom, arc.the_geom) LIMIT 1;
    IF arcrec.arc_id IS NOT NULL THEN
        -- Create link
        EXECUTE 'INSERT INTO link VALUES ('','||quote_literal(NEW.connec_id)||','||quote_literal(ST_ShortestLine(NEW.the_geom,arcrec.the_geom)||')';
    END IF;

    RETURN NEW; 
END; 
$$


-- CREATE TRIGGER gw_trg_connec_insert BEFORE INSERT ON "SCHEMA_NAME"."connec" FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_connec_insert"();

