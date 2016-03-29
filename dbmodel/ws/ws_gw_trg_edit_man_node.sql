/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/




CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_man_node() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE
    epa_table varchar;
    man_table varchar;
	old_nodetype varchar;
    new_nodetype varchar;
    v_sql varchar;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    man_table:= TG_ARGV[0];
    --RAISE NOTICE 'man_table: %', man_table;    

    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN

        -- Node ID
        IF (NEW.node_id IS NULL) THEN
            NEW.node_id:= (SELECT nextval('node_id_seq'));
        END IF;
        
        -- Node Catalog ID
        IF (NEW.nodecat_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM cat_node) = 0) THEN
                RAISE EXCEPTION 'There are no nodes catalog defined in the model, define at least one.';
            END IF;
            NEW.nodecat_id:= (SELECT id FROM cat_node LIMIT 1);
        END IF;
        
        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RAISE EXCEPTION 'There are no sectors defined in the model, define at least one.';
            END IF;
            NEW.sector_id := (SELECT sector_id FROM sector WHERE (NEW.the_geom @ sector.the_geom) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                RAISE EXCEPTION 'Please take a look on your map and use the approach of the sectors!!!';
            END IF;
        END IF;

        -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RAISE EXCEPTION 'There are no dma defined in the model, define at least one.';
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE (NEW.the_geom @ dma.the_geom) LIMIT 1);
            IF (NEW.dma_id IS NULL) THEN
                RAISE EXCEPTION 'Please take a look on your map and use the approach of the dma!!!';
            END IF;
        END IF;

        -- FEATURE INSERT
        INSERT INTO node VALUES (NEW.node_id, NEW.elevation, NEW."depth", NEW.nodecat_id, 'JUNCTION'::text, NEW.sector_id, NEW."state", NEW.annotation, NEW."observ", NEW."comment", NEW.dma_id, 
								NEW.soilcat_id, NEW.category_type, NEW.fluid_type, NEW.location_type, NEW.workcat_id, NEW.buildercat_id, NEW.builtdate, NEW.ownercat_id, 	
                                null, null, null, null, null,
                                NEW.rotation, NEW.link, NEW.verified, NEW.the_geom);
        
        -- MANAGEMENT INSERT
        IF man_table = 'man_tank' THEN        
            INSERT INTO man_tank VALUES (NEW.node_id, NEW.vmax, NEW.area, NEW.add_info);
        ELSE
            v_sql:= 'INSERT INTO'||man_table||' VALUES ('||quote_literal(NEW.node_id)||', '||NEW.add_info||')';
            EXECUTE v_sql;
        END IF;

        -- EPA INSERT
        epa_table:= (SELECT epa_table FROM node_type JOIN cat_node ON (((node_type.id)::text = (cat_node.nodetype_id)::text)) WHERE cat_node.id=NEW.nodecat_id);
        v_sql:= 'INSERT INTO '||epa_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

        IF (NEW.nodecat_id <> OLD.nodecat_id) THEN  
            old_nodetype:= (SELECT node_type.type FROM node_type JOIN cat_node ON (((node_type.id)::text = (cat_node.nodetype_id)::text)) WHERE cat_node.id=OLD.nodecat_id)::text;
            new_nodetype:= (SELECT node_type.type FROM node_type JOIN cat_node ON (((node_type.id)::text = (cat_node.nodetype_id)::text)) WHERE cat_node.id=NEW.nodecat_id)::text;
            IF (quote_literal(old_nodetype)::text <> quote_literal(new_nodetype)::text) THEN
                RAISE EXCEPTION 'Change node catalog is forbidden. The new node catalog is not included on the same type (node_type.type) of the old node catalog';
            END IF;
        END IF;

        UPDATE node
        SET node_id=NEW.node_id, elevation=NEW.elevation, "depth"=NEW."depth", nodecat_id=NEW.nodecat_id, sector_id=NEW.sector_id, "state"=NEW."state", annotation=NEW.annotation, "observ"=NEW."observ", "comment"=NEW."comment", 
             dma_id=NEW.dma_id, soilcat_id=NEW.soilcat_id, category_type=NEW.category_type, fluid_type=NEW.fluid_type, location_type=NEW.location_type, workcat_id=NEW.workcat_id, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate, 
             rotation=NEW.rotation, link=NEW.link, verified=NEW.verified, the_geom=NEW.the_geom 
        WHERE node_id=OLD.node_id;
        
        IF man_table = 'man_tank' THEN        
            UPDATE man_tank SET node_id=NEW.node_id, vmax=NEW.vmax, area=NEW.area, add_info=NEW.add_info WHERE node_id=OLD.node_id;
        ELSE
            v_sql:= 'UPDATE '||man_table||' SET node_id='||quote_literal(NEW.node_id)||', add_info='||quote_literal(NEW.add_info)||' WHERE node_id='||quote_literal(OLD.node_id);
            EXECUTE v_sql;
        END IF;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM node WHERE node_id=OLD.node_id;
        EXECUTE 'DELETE FROM '||man_table||' WHERE node_id='||quote_literal(OLD.node_id);
        RETURN NULL;
    
    END IF;
    
END;
$$;



CREATE TRIGGER gw_trg_edit_man_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_junction
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_junction');
 
CREATE TRIGGER gw_trg_edit_man_node_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_tank 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_tank');

CREATE TRIGGER gw_trg_edit_man_node_hydrant INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_hydrant 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_hydrant');

CREATE TRIGGER gw_trg_edit_man_node_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_valve 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_valve');

CREATE TRIGGER gw_trg_edit_man_node_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_pump 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_pump');

CREATE TRIGGER gw_trg_edit_man_node_filter INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_filter 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_filter');

CREATE TRIGGER gw_trg_edit_man_node_meter INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_meter 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_meter');
  
  
  
   