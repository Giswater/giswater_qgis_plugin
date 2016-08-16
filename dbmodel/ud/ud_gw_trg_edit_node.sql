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
                RETURN audit_function(200,810);  
		END IF;

        -- Node type
        IF (NEW.node_type IS NULL) THEN
            IF ((SELECT COUNT(*) FROM node_type) = 0) THEN
                RETURN audit_function(105,810);  
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
                RETURN audit_function(110,810);  
            END IF;      
        END IF;

        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(115,810);  
            END IF;
            NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(120,810);          
            END IF;            
        END IF;
        
        -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(125,810);  
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(130,810);  
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
            
        PERFORM audit_function (1,810);
        RETURN NEW;


    ELSIF TG_OP = 'UPDATE' THEN

        -- UPDATE dma/sector
        IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom)THEN   
            NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);          
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);         
        END IF;

	IF (NEW.elev <> OLD.elev) THEN
                RETURN audit_function(200,810);  
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


        UPDATE node 
        SET node_id=NEW.node_id, top_elev=NEW.top_elev, ymax=NEW.ymax, sander=NEW.sander, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW."state", 
            annotation=NEW.annotation, "observ"=NEW."observ", "comment"=NEW."comment", dma_id=NEW.dma_id, soilcat_id=NEW.soilcat_id, category_type=NEW.category_type, 
            fluid_type=NEW.fluid_type, location_type=NEW.location_type, workcat_id=NEW.workcat_id, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate,
            ownercat_id=NEW.ownercat_id, adress_01=NEW.adress_01, adress_02=NEW.adress_02, adress_03=NEW.adress_03, descript=NEW.descript,
            est_top_elev=NEW.est_top_elev, est_ymax=NEW.est_ymax, rotation=NEW.rotation, link=NEW.link, verified=NEW.verified, the_geom=NEW.the_geom 
        WHERE node_id = OLD.node_id;
                
		PERFORM audit_function (2,810);
        RETURN NEW;
    

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM node WHERE node_id = OLD.node_id;

		PERFORM audit_function (3,810);
        RETURN NULL;
   
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


CREATE TRIGGER gw_trg_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_node
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_node();
      