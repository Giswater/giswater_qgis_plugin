/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/




-----------------------------
-- TRIGGERS EDITING VIEWS FOR NODE
-----------------------------

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_inp_node() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    node_table varchar;
    man_table varchar;
    epa_type varchar;
    v_sql varchar;
    old_nodetype varchar;
    new_nodetype varchar;    

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    node_table:= TG_ARGV[0];
    epa_type:= TG_ARGV[1];
    
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN
/*
--	To disable the insert option
    RAISE EXCEPTION 'Insert features is forbidden. To insert new features use the GIS FEATURES layers agrupation of TOC';
	  RETURN NULL;
*/

        -- Node ID
        IF (NEW.node_id IS NULL) THEN
            NEW.node_id := (SELECT nextval('node_id_seq'));
        END IF;
        -- Node Catalog ID
        IF (NEW.nodecat_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM cat_node) = 0) THEN
                RAISE EXCEPTION 'There are no nodes catalog defined in the model, define at least one.';
            END IF;
            --NEW.nodecat_id := (SELECT id FROM cat_node LIMIT 1);
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
         INSERT INTO node VALUES (NEW.node_id, NEW.elevation, NEW."depth", NEW.nodecat_id, epa_type::text, NEW.sector_id, NEW."state", NEW.annotation, NEW."observ", NEW."comment", NEW.dma_id, 
								null, null, null, null, null ,null, null, 
                                null, null, null, null, null,
                                NEW.rotation, NEW.link, NEW.verified, NEW.the_geom);

        -- EPA INSERT
        IF node_table = 'inp_junction' THEN        
            INSERT INTO inp_junction VALUES (NEW.node_id, NEW.demand, NEW.pattern_id);
        ELSIF node_table = 'inp_reservoir' THEN
            INSERT INTO inp_reservoir VALUES (NEW.node_id, NEW.head, NEW.pattern_id);
        ELSIF node_table = 'inp_tank' THEN            
            INSERT INTO inp_tank VALUES (NEW.node_id, NEW.initlevel, NEW.minlevel, NEW.maxlevel, NEW.diameter, NEW.minvol, NEW.curve_id);
        ELSIF node_table = 'inp_pump' THEN          
            INSERT INTO inp_pump VALUES (NEW.node_id, NEW.power, NEW.curve_id, NEW.speed, NEW.pattern, NEW.status);
        ELSIF node_table = 'inp_valve' THEN     
            INSERT INTO inp_valve VALUES (NEW.node_id, NEW.valv_type, NEW.pressure, NEW.flow, NEW.coef_loss, NEW.curve_id, NEW.minorloss, NEW.status);
        ELSIF node_table = 'inp_shortpipe' THEN     
            INSERT INTO inp_shortpipe VALUES (NEW.node_id, NEW.minorloss, NEW.to_arc, NEW.status);
        END IF;

        -- MANAGEMENT INSERT
        man_table:= (SELECT node_type.man_table FROM node_type JOIN cat_node ON (((node_type.id)::text = (cat_node.nodetype_id)::text)) WHERE cat_node.id=NEW.nodecat_id);
        IF man_table IS NOT NULL THEN        
            v_sql:= 'INSERT INTO '||man_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
            --RAISE NOTICE 'sql: %', v_sql;
            EXECUTE v_sql;
		END IF;
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

        IF (NEW.nodecat_id <> OLD.nodecat_id) THEN  
            old_nodetype:= (SELECT node_type.type FROM node_type JOIN cat_node ON (((node_type.id)::text = (cat_node.nodetype_id)::text)) WHERE cat_node.id=OLD.nodecat_id)::text;
            new_nodetype:= (SELECT node_type.type FROM node_type JOIN cat_node ON (((node_type.id)::text = (cat_node.nodetype_id)::text)) WHERE cat_node.id=NEW.nodecat_id)::text;
            IF (quote_literal(old_nodetype)::text <> quote_literal(new_nodetype)::text) THEN
                RAISE EXCEPTION 'Change node catalog is forbidden. The new node catalog is not included on the same type (node_type.type) of the old node catalog';
            END IF;
        END IF;

        IF node_table = 'inp_junction' THEN
            UPDATE inp_junction SET node_id=NEW.node_id, demand=NEW.demand, pattern_id=NEW.pattern_id WHERE node_id=OLD.node_id;
        ELSIF node_table = 'inp_reservoir' THEN
            UPDATE inp_reservoir SET node_id=NEW.node_id, head=NEW.head, pattern_id=NEW.pattern_id WHERE node_id=OLD.node_id;  
        ELSIF node_table = 'inp_tank' THEN
            UPDATE inp_tank SET node_id=NEW.node_id, initlevel=NEW.initlevel, minlevel=NEW.minlevel, maxlevel=NEW.maxlevel, diameter=NEW.diameter, minvol=NEW.minvol, curve_id=NEW.curve_id WHERE node_id=OLD.node_id;
        ELSIF node_table = 'inp_pump' THEN          
            UPDATE inp_pump SET node_id=NEW.node_id, power=NEW.power, curve_id=NEW.curve_id, speed=NEW.speed, pattern=NEW.pattern, status=NEW.status WHERE node_id=OLD.node_id;
        ELSIF node_table = 'inp_valve' THEN     
            UPDATE inp_valve SET node_id=NEW.node_id, valv_type=NEW.valv_type, pressure=NEW.pressure, flow=NEW.flow, coef_loss=NEW.coef_loss, curve_id=NEW.curve_id, minorloss=NEW.minorloss, status=NEW.status WHERE node_id=OLD.node_id;
        ELSIF node_table = 'inp_shortpipe' THEN     
            UPDATE inp_shortpipe SET node_id=NEW.node_id, minorloss=NEW.minorloss, to_arc=NEW.to_arc, status=NEW.status WHERE node_id=OLD.node_id;  
        END IF;
        		
		UPDATE node 
        SET node_id=NEW.node_id, elevation=NEW.elevation, "depth"=NEW."depth", nodecat_id=NEW.nodecat_id, sector_id=NEW.sector_id, "state"=NEW."state", 
            annotation=NEW.annotation, "observ"=NEW."observ", "comment"=NEW."comment", dma_id=NEW.dma_id, rotation=NEW.rotation, link=NEW.link, verified=NEW.verified, the_geom=NEW.the_geom 
        WHERE node_id=OLD.node_id;
		RETURN NEW;
		
    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM node WHERE node_id = OLD.node_id;
        EXECUTE 'DELETE FROM '||node_table||' WHERE node_id = '||quote_literal(OLD.node_id);
        RETURN NULL;
    
    END IF;
       
END;
$$;


CREATE TRIGGER gw_trg_edit_inp_node_shortpipe INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_shortpipe 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_shortpipe', 'SHORTPIPE');

CREATE TRIGGER gw_trg_edit_inp_node_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_valve 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_valve', 'VALVE');

CREATE TRIGGER gw_trg_edit_inp_node_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_pump 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_pump', 'PUMP');

CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_junction 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_junction', 'JUNCTION');
 
CREATE TRIGGER gw_trg_edit_inp_node_reservoir INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_reservoir 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_reservoir', 'RESERVOIR');

CREATE TRIGGER gw_trg_edit_inp_node_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_tank 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_tank', 'TANK');

  
  