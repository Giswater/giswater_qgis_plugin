/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


   

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_node()
  RETURNS trigger AS
$BODY$
DECLARE 
    inp_table varchar;
    man_table varchar;
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
        
        -- elev
        IF (NEW.elev IS NOT NULL) THEN   	
			RAISE EXCEPTION 'Please, review your data: elev is not an updatable field.';
		END IF;
        
         -- Node type & EPA type
        IF (NEW.node_type IS NULL) THEN
                RAISE EXCEPTION 'Please, define node_type.';
        ELSE   
		NEW.epa_type:= (SELECT epa_default FROM node_type WHERE node_type.id=NEW.node_type)::text;        
        END IF;

        -- Arc catalog ID
        IF (NEW.arccat_id IS NULL) THEN
                RAISE EXCEPTION 'Please, define node_catalog.';
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

        INSERT INTO node VALUES (NEW.node_id, NEW.top_elev, NEW.ymax, NEW.sander, NEW.node_type, NEW.nodecat_id, NEW.epa_type, NEW.sector_id, NEW."state", NEW.annotation, NEW."observ", NEW."comment",
                                NEW.dma_id, NEW.soilcat_id, NEW.category_type, NEW.fluid_type, NEW.location_type, NEW.workcat_id, NEW.buildercat_id, NEW.builtdate, 
                                NEW.ownercat_id, NEW.adress_01, NEW.adress_02, NEW.adress_03, NEW.descript, NEW.est_top_elev, NEW.est_ymax, NEW.rotation, NEW.link, NEW.verified, NEW.the_geom);

        -- EPA INSERT
        IF (NEW.epa_type = 'JUNCTION') THEN inp_table:= 'inp_junction';
        ELSIF (NEW.epa_type = 'DIVIDER') THEN inp_table:= 'inp_divider';
        ELSIF (NEW.epa_type = 'OUTFALL') THEN inp_table:= 'inp_outfall';
        ELSIF (NEW.epa_type = 'STORAGE') THEN inp_table:= 'inp_storage';
        END IF;
        v_sql:= 'INSERT INTO '||inp_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
        EXECUTE v_sql;

        -- MANAGEMENT INSERT
        man_table:= (SELECT node_type.man_table FROM node_type WHERE node_type.id=NEW.node_type);
        v_sql:= 'INSERT INTO '||man_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
        EXECUTE v_sql;
            
        RETURN NEW;


    ELSIF TG_OP = 'UPDATE' THEN


	IF (NEW.elev <> OLD.elev) THEN
	RAISE EXCEPTION 'Please, review your data: elev is not an updatable field.';
	END IF;

        NEW.elev=NEW.top_elev-NEW.ymax;
 

        IF (NEW.epa_type <> OLD.epa_type) THEN    
         
            IF (OLD.epa_type = 'JUNCTION') THEN
                inp_table:= 'inp_junction';            
            ELSIF (OLD.epa_type = 'DIVIDER') THEN
                inp_table:= 'inp_divider';                
            ELSIF (OLD.epa_type = 'OUTFALL') THEN
                inp_table:= 'inp_outfall';    
            ELSIF (OLD.epa_type = 'STORAGE') THEN
                inp_table:= 'inp_storage';    
			END IF;
            v_sql:= 'DELETE FROM '||inp_table||' WHERE node_id = '||quote_literal(OLD.node_id);
            EXECUTE v_sql;

            IF (NEW.epa_type = 'JUNCTION') THEN
                inp_table:= 'inp_junction';   
            ELSIF (NEW.epa_type = 'DIVIDER') THEN
                inp_table:= 'inp_divider';     
            ELSIF (NEW.epa_type = 'OUTFALL') THEN
                inp_table:= 'inp_outfall';  
            ELSIF (NEW.epa_type = 'STORAGE') THEN
                inp_table:= 'inp_storage';
            END IF;
            v_sql:= 'INSERT INTO '||inp_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
            EXECUTE v_sql;

        END IF;
/*
        IF (NEW.nodecat_id <> OLD.nodecat_id) THEN  
            old_nodetype:= (SELECT node_type.type FROM node_type JOIN cat_node ON (((node_type.id)::text = (cat_node.nodetype_id)::text)) WHERE cat_node.id=OLD.nodecat_id)::text;
            new_nodetype:= (SELECT node_type.type FROM node_type JOIN cat_node ON (((node_type.id)::text = (cat_node.nodetype_id)::text)) WHERE cat_node.id=NEW.nodecat_id)::text;
			
            IF (quote_literal(old_nodetype)::text <> quote_literal(new_nodetype)::text) THEN
                RAISE EXCEPTION 'Change node catalog is forbidden. The new node catalog is not included on the same type (node_type.type) of the old node catalog';
            END IF;
        END IF;
*/
        UPDATE node 
        SET node_id=NEW.node_id, top_elev=NEW.top_elev, ymax=NEW.ymax, sander=NEW.sander, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW."state", 
            annotation=NEW.annotation, "observ"=NEW."observ", "comment"=NEW."comment", dma_id=NEW.dma_id, soilcat_id=NEW.soilcat_id, category_type=NEW.category_type, 
            fluid_type=NEW.fluid_type, location_type=NEW.location_type, workcat_id=NEW.workcat_id, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate,
            ownercat_id=NEW.ownercat_id, adress_01=NEW.adress_01, adress_02=NEW.adress_02, adress_03=NEW.adress_03, descript=NEW.descript,
            est_top_elev=NEW.est_top_elev, est_ymax=NEW.est_ymax, rotation=NEW.rotation, link=NEW.link, verified=NEW.verified, the_geom=NEW.the_geom 
        WHERE node_id = OLD.node_id;
                
        RETURN NEW;
    

    ELSIF TG_OP = 'DELETE' THEN

        DELETE FROM node WHERE node_id = OLD.node_id;
        RETURN NULL;
   
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_node
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node();
      