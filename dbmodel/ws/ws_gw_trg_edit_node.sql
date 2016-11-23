/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_node() RETURNS trigger AS 
$BODY$
DECLARE 
    inp_table varchar;
    man_table varchar;
	new_man_table varchar;
	old_man_table varchar;
    v_sql varchar;
    old_nodetype varchar;
    new_nodetype varchar;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN
    
        -- Node ID
        IF (NEW.node_id IS NULL) THEN
            NEW.node_id:= (SELECT nextval('node_id_seq'));
        END IF;

        -- Node type
        IF (NEW.node_type IS NULL) THEN
            IF ((SELECT COUNT(*) FROM node_type) = 0) THEN
                RETURN audit_function(105,380);  
            END IF;
            NEW.node_type:= (SELECT id FROM node_type LIMIT 1);
        END IF;

         -- Epa type
        IF (NEW.epa_type IS NULL) THEN
			NEW.epa_type:= (SELECT epa_default FROM node_type WHERE node_type.id=NEW.node_type)::text;   
		END IF;

        -- Node Catalog ID
        IF (NEW.nodecat_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM cat_node) = 0) THEN
                RETURN audit_function(110,380);  
            END IF;      
        END IF;

        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(115,380);  
            END IF;
            NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(120,380);          
            END IF;            
        END IF;
        
        -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(125,380);  
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(130,380);  
            END IF;            
        END IF;
        
        -- FEATURE INSERT      
        INSERT INTO node VALUES (NEW.node_id, NEW.elevation, NEW."depth", NEW.node_type, NEW.nodecat_id, NEW.epa_type, NEW.sector_id, NEW."state", NEW.annotation, NEW."observ", NEW."comment",
                                NEW.dma_id, NEW.soilcat_id, NEW.category_type, NEW.fluid_type, NEW.location_type, NEW.workcat_id, NEW.buildercat_id, NEW.builtdate, 
                                NEW.ownercat_id, NEW.adress_01, NEW.adress_02, NEW.adress_03, NEW.descript, NEW.rotation, NEW.link, NEW.verified, NEW.the_geom,NEW.workcat_id_end,NEW.undelete,NEW.label_x,NEW.label_y,NEW.label_rotation);

        -- EPA INSERT
        IF (NEW.epa_type = 'JUNCTION') THEN inp_table:= 'inp_junction';
        ELSIF (NEW.epa_type = 'TANK') THEN inp_table:= 'inp_tank';
        ELSIF (NEW.epa_type = 'RESERVOIR') THEN inp_table:= 'inp_reservoir';
        ELSIF (NEW.epa_type = 'PUMP') THEN inp_table:= 'inp_pump';
        ELSIF (NEW.epa_type = 'VALVE') THEN inp_table:= 'inp_valve';
        ELSIF (NEW.epa_type = 'SHORTPIPE') THEN inp_table:= 'inp_shortpipe';
        END IF;
        IF inp_table IS NOT NULL THEN        
            v_sql:= 'INSERT INTO '||inp_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
            EXECUTE v_sql;
        END IF;

        -- MANAGEMENT INSERT
        man_table:= (SELECT node_type.man_table FROM node_type WHERE node_type.id = NEW.node_type);

        IF man_table IS NOT NULL THEN
            v_sql:= 'INSERT INTO '||man_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
            EXECUTE v_sql;
        END IF;

        PERFORM audit_function(1,380); 
        RETURN NEW;


    ELSIF TG_OP = 'UPDATE' THEN


    -- UPDATE EPA values
        IF (NEW.epa_type <> OLD.epa_type) THEN    
         
            IF (OLD.epa_type = 'JUNCTION') THEN
                inp_table:= 'inp_junction';            
            ELSIF (OLD.epa_type = 'TANK') THEN
                inp_table:= 'inp_tank';                
            ELSIF (OLD.epa_type = 'RESERVOIR') THEN
                inp_table:= 'inp_reservoir';    
            ELSIF (OLD.epa_type = 'SHORTPIPE') THEN
                inp_table:= 'inp_shortpipe';    
            ELSIF (OLD.epa_type = 'VALVE') THEN
                inp_table:= 'inp_valve';    
            ELSIF (OLD.epa_type = 'PUMP') THEN
                inp_table:= 'inp_pump';  
            END IF;
            IF inp_table IS NOT NULL THEN
                v_sql:= 'DELETE FROM '||inp_table||' WHERE node_id = '||quote_literal(OLD.node_id);
                EXECUTE v_sql;
            END IF;

            IF (NEW.epa_type = 'JUNCTION') THEN
                inp_table:= 'inp_junction';   
            ELSIF (NEW.epa_type = 'TANK') THEN
                inp_table:= 'inp_tank';     
            ELSIF (NEW.epa_type = 'RESERVOIR') THEN
                inp_table:= 'inp_reservoir';  
            ELSIF (NEW.epa_type = 'SHORTPIPE') THEN
                inp_table:= 'inp_shortpipe';    
            ELSIF (NEW.epa_type = 'VALVE') THEN
                inp_table:= 'inp_valve';    
            ELSIF (NEW.epa_type = 'PUMP') THEN
                inp_table:= 'inp_pump';  
            END IF;
            IF inp_table IS NOT NULL THEN
                v_sql:= 'INSERT INTO '||inp_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
                EXECUTE v_sql;
            END IF;
        END IF;

    -- UPDATE management values
		IF (NEW.node_type <> OLD.node_type) THEN 
			new_man_table:= (SELECT node_type.man_table FROM node_type WHERE node_type.id = NEW.node_type);
			old_man_table:= (SELECT node_type.man_table FROM node_type WHERE node_type.id = OLD.node_type);
			IF new_man_table IS NOT NULL THEN
				v_sql:= 'DELETE FROM '||old_man_table||' WHERE node_id= '||quote_literal(OLD.node_id);
				EXECUTE v_sql;
				v_sql:= 'INSERT INTO '||new_man_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
				EXECUTE v_sql;
				NEW.nodecat_id:= (SELECT id FROM cat_node WHERE nodetype_id=NEW.node_type LIMIT 1);
			END IF;
		END IF;

	-- Node catalog restriction
        IF (OLD.nodecat_id IS NOT NULL) AND (NEW.nodecat_id <> OLD.nodecat_id) AND (NEW.node_type=OLD.node_type) THEN  
            old_nodetype:= (SELECT node_type.type FROM node_type JOIN cat_node ON (((node_type.id) = (cat_node.nodetype_id))) WHERE cat_node.id=OLD.nodecat_id);
            new_nodetype:= (SELECT node_type.type FROM node_type JOIN cat_node ON (((node_type.id) = (cat_node.nodetype_id))) WHERE cat_node.id=NEW.nodecat_id);
            IF (quote_literal(old_nodetype) <> quote_literal(new_nodetype)) THEN
                RETURN audit_function(135,380);  
            END IF;
        END IF;


	-- UPDATE values
        UPDATE node 
        SET node_id=NEW.node_id, elevation=NEW.elevation, "depth"=NEW."depth", node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW."state", 
            annotation=NEW.annotation, "observ"=NEW."observ", "comment"=NEW."comment", dma_id=NEW.dma_id, soilcat_id=NEW.soilcat_id, category_type=NEW.category_type, 
            fluid_type=NEW.fluid_type, location_type=NEW.location_type, workcat_id=NEW.workcat_id, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate,
            ownercat_id=NEW.ownercat_id, adress_01=NEW.adress_01, adress_02=NEW.adress_02, adress_03=NEW.adress_03, descript=NEW.descript,
            rotation=NEW.rotation, link=NEW.link, verified=NEW.verified, the_geom=NEW.the_geom,workcat_id_end=NEW.workcat_id_end, undelete=NEW.undelete, label_x=NEW.label_x,label_y=NEW.label_y, label_rotation=NEW.label_rotation 
        WHERE node_id = OLD.node_id;
            
        PERFORM audit_function(2,380); 
        RETURN NEW;
    

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM node WHERE node_id = OLD.node_id;
        PERFORM audit_function(3,380); 
        RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

DROP TRIGGER IF EXISTS gw_trg_edit_node ON "SCHEMA_NAME".v_edit_node;
CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_node
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node();

      