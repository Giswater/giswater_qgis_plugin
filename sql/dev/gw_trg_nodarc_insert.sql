/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_nodarc_insert() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    epa_table Varchar; 
    arcrec Record;
    rec Record;

BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    epa_table:= (SELECT node_type.epa_table FROM node_type JOIN cat_node ON (((node_type.id)::text = (cat_node.nodetype_id)::text)) WHERE cat_node.id=NEW.nodecat_id);

    IF (epa_table='inp_valve') OR (epa_table='inp_shortpipe') OR (epa_table='inp_pump') OR (epa_table='inp_weir') OR (epa_table='inp_orifice') THEN
        -- Get node tolerance from config table
        SELECT node_buffering INTO rec FROM config;
        -- Get arc
        SELECT * INTO arcrec FROM arc WHERE ST_Dwithin(NEW.the_geom, arc.the_geom, rec.node_buffering) ORDER BY ST_Distance(NEW.the_geom, arc.the_geom) LIMIT 1;
        IF arcrec.arc_id IS NOT NULL THEN
            -- Update coordinates
            NEW.the_geom := ST_ClosestPoint (NEW.the_geom, arcrec.the_geom);
            -- st_split (arcrec.the_geom, New.the_geom);
        END IF;
    END IF;

    RETURN NEW; 
    
END; 
$$  


-- CREATE TRIGGER gw_trg_nodarc_insert BEFORE INSERT ON "SCHEMA_NAME"."node" FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_nodarc_insert"();

