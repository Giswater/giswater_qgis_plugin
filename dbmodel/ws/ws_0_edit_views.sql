/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


----------------------------
--    GIS EDITING VIEWS
----------------------------

CREATE OR REPLACE VIEW "SCHEMA_NAME".v_edit_node AS
SELECT node.node_id, 
node.elevation, 
node.depth, 
node.nodecat_id,
cat_node.nodetype_id AS "cat_nodetype_id",
cat_node.matcat_id AS "cat_matcat_id",
cat_node.pnom AS "cat_pnom",
cat_node.dnom AS "cat_dnom",
node.epa_type,
node.sector_id, 
node."state", 
node.annotation, 
node.observ, 
node."comment",
node.dma_id,
node.soilcat_id,
node.category_type,
node.fluid_type,
node.location_type,
node.workcat_id,
node.buildercat_id,
node.builtdate,
node.ownercat_id,
node.adress_01,
node.adress_02,
node.adress_03,
node.descript,
cat_node.svg AS "cat_svg",
node.rotation,
node.link,
node.verified,
node.the_geom
FROM ("SCHEMA_NAME".node JOIN "SCHEMA_NAME".cat_node ON (((node.nodecat_id)::text = (cat_node.id)::text)));


CREATE VIEW "SCHEMA_NAME".v_edit_arc AS
SELECT arc.arc_id, 
arc.arccat_id, 
cat_arc.arctype_id AS "cat_arctype_id",
cat_arc.matcat_id AS "cat_matcat_id",
cat_arc.pnom AS "cat_pnom",
cat_arc.dnom AS "cat_dnom",
arc.epa_type,
arc.sector_id, 
arc."state", 
arc.annotation, 
arc.observ, 
arc."comment",
arc.custom_length,
arc.dma_id,
arc.soilcat_id,
arc.category_type,
arc.fluid_type,
arc.location_type,
arc.workcat_id,
arc.buildercat_id,
arc.builtdate,
arc.ownercat_id,
arc.adress_01,
arc.adress_02,
arc.adress_03,
arc.descript,
cat_arc.svg AS "cat_svg",
arc.rotation,
arc.link,
arc.verified,
arc.the_geom,
st_length2d(arc.the_geom)::numeric(12,2) AS gis_length
FROM ("SCHEMA_NAME".arc JOIN "SCHEMA_NAME".cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text)));



-- ----------------------------
-- Function trigger definition
-- ----------------------------
   
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".v_edit_node() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    inp_table varchar;
    man_table varchar;
    v_sql varchar;
    old_nodetype varchar;
    new_nodetype varchar;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
    --Control insertions ID
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
            NEW.epa_type:= (SELECT epa_default FROM node_type LIMIT 1);
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

        NEW.epa_type:= (SELECT epa_default FROM node_type JOIN cat_node ON (((node_type.id)::text = (cat_node.nodetype_id)::text)) WHERE cat_node.id = NEW.nodecat_id);
        
        -- FEATURE INSERT
        INSERT INTO node VALUES (NEW.node_id, NEW.elevation, NEW."depth", NEW.nodecat_id, NEW.epa_type, NEW.sector_id, NEW."state", NEW.annotation, NEW."observ", NEW."comment",
                                NEW.dma_id, NEW.soilcat_id, NEW.category_type, NEW.fluid_type, NEW.location_type, NEW.workcat_id, NEW.buildercat_id, NEW.builtdate, 
                                NEW.ownercat_id, NEW.adress_01, NEW.adress_02, NEW.adress_03, NEW.descript, 
                                NEW.rotation, NEW.link, NEW.verified, NEW.the_geom);

        -- EPA INSERT
        IF (NEW.epa_type = 'JUNCTION') THEN inp_table:= 'inp_junction';
        ELSIF (NEW.epa_type = 'TANK') THEN inp_table:= 'inp_tank';
        ELSIF (NEW.epa_type = 'RESERVOIR') THEN inp_table:= 'inp_reservoir';
        ELSIF (NEW.epa_type = 'PUMP') THEN inp_table:= 'inp_pump';
        ELSIF (NEW.epa_type = 'VALVE') THEN inp_table:= 'inp_valve';
        ELSIF (NEW.epa_type = 'SHORT_PIPE') THEN inp_table:= 'inp_shortpipe';
        END IF;
        v_sql:= 'INSERT INTO '||inp_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
        EXECUTE v_sql;

        -- MANAGEMENT INSERT
        man_table:= (SELECT node_type.man_table FROM node_type JOIN cat_node ON (((node_type.id)::text = (cat_node.nodetype_id)::text)) WHERE cat_node.id=NEW.nodecat_id);
        v_sql:= 'INSERT INTO '||man_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
        EXECUTE v_sql;
            
        RETURN NEW;


    ELSIF TG_OP = 'UPDATE' THEN

        IF (NEW.epa_type <> OLD.epa_type) THEN    
         
            IF (OLD.epa_type = 'JUNCTION') THEN
                inp_table:= 'inp_junction';            
            ELSIF (OLD.epa_type = 'TANK') THEN
                inp_table:= 'inp_tank';                
            ELSIF (OLD.epa_type = 'RESERVOIR') THEN
                inp_table:= 'inp_reservoir';    
            ELSIF (OLD.epa_type = 'SHORT_PIPE') THEN
                inp_table:= 'inp_shortpipe';    
            ELSIF (OLD.epa_type = 'VALVE') THEN
                inp_table:= 'inp_valve';    
            ELSIF (OLD.epa_type = 'PUMP') THEN
                inp_table:= 'inp_pump';  
            END IF;
            v_sql:= 'DELETE FROM '||inp_table||' WHERE node_id = '||quote_literal(OLD.node_id);
            EXECUTE v_sql;

            IF (NEW.epa_type = 'JUNCTION') THEN
                inp_table:= 'inp_junction';   
            ELSIF (NEW.epa_type = 'TANK') THEN
                inp_table:= 'inp_tank';     
            ELSIF (NEW.epa_type = 'RESERVOIR') THEN
                inp_table:= 'inp_reservoir';  
            ELSIF (NEW.epa_type = 'SHORT_PIPE') THEN
                inp_table:= 'inp_shortpipe';    
            ELSIF (NEW.epa_type = 'VALVE') THEN
                inp_table:= 'inp_valve';    
            ELSIF (NEW.epa_type = 'PUMP') THEN
                inp_table:= 'inp_pump';  
            END IF;
            v_sql:= 'INSERT INTO '||inp_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
            EXECUTE v_sql;

        END IF;

        IF (NEW.nodecat_id <> OLD.nodecat_id) THEN  
            old_nodetype:= (SELECT node_type.type FROM node_type JOIN cat_node ON (((node_type.id)::text = (cat_node.nodetype_id)::text)) WHERE cat_node.id=OLD.nodecat_id)::text;
            new_nodetype:= (SELECT node_type.type FROM node_type JOIN cat_node ON (((node_type.id)::text = (cat_node.nodetype_id)::text)) WHERE cat_node.id=NEW.nodecat_id)::text;
            IF (quote_literal(old_nodetype)::text <> quote_literal(new_nodetype)::text) THEN
                RAISE EXCEPTION 'Change node catalog is forbidden. The new node catalog is not included on the same type (node_type.type) of the old node catalog';
            END IF;
        END IF;

        UPDATE node 
        SET node_id=NEW.node_id, elevation=NEW.elevation, "depth"=NEW."depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW."state", annotation=NEW.annotation, "observ"=NEW."observ", 
            dma_id=NEW.dma_id, soilcat_id=NEW.soilcat_id, category_type=NEW.category_type, fluid_type=NEW.fluid_type, location_type=NEW.location_type, workcat_id=NEW.workcat_id, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate,
            ownercat_id=NEW.ownercat_id, adress_01=NEW.adress_01, adress_02=NEW.adress_02, adress_03=NEW.adress_03, descript=NEW.descript,
            rotation=NEW.rotation, link=NEW.link, verified=NEW.verified, the_geom=NEW.the_geom 
        WHERE node_id = OLD.node_id;
                
        RETURN NEW;
    

    ELSIF TG_OP = 'DELETE' THEN

        DELETE FROM node WHERE node_id = OLD.node_id;
        RETURN NULL;
   
    END IF;

END;
$$;



CREATE OR REPLACE FUNCTION SCHEMA_NAME.v_edit_arc() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    inp_table varchar;
    man_table varchar;
    v_sql varchar;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
    IF TG_OP = 'INSERT' THEN
    
        -- Arc ID
        IF (NEW.arc_id IS NULL) THEN
            NEW.arc_id:= (SELECT nextval('arc_id_seq'));
        END IF;
        -- Arc catalog ID
        IF (NEW.arccat_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM cat_arc) = 0) THEN
                RAISE EXCEPTION 'There are no arc catalog defined in the model, define at least one.';
            END IF;
            NEW.arccat_id:= (SELECT id FROM cat_arc LIMIT 1);
            NEW.epa_type:= (SELECT epa_default FROM node_type LIMIT 1);                           
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
        
        NEW.epa_type:= (SELECT epa_default FROM arc_type JOIN cat_arc ON (((arc_type.id)::text = (cat_arc.arctype_id)::text)) WHERE cat_arc.id=NEW.arccat_id);
    
        -- FEATURE INSERT
        INSERT INTO arc VALUES (NEW.arc_id, null, null, NEW.arccat_id, NEW.epa_type, NEW.sector_id, NEW."state", NEW.annotation, NEW."observ", NEW."comment", NEW.custom_length, 
                                NEW.dma_id, NEW.soilcat_id, NEW.category_type, NEW.fluid_type, NEW.location_type, NEW.workcat_id, NEW.buildercat_id, NEW.builtdate, 
                                NEW.ownercat_id, NEW.adress_01, NEW.adress_02, NEW.adress_03, NEW.descript, NEW.rotation, NEW.link, NEW.verified, NEW.the_geom);
        -- EPA INSERT
        IF (NEW.epa_type = 'PIPE') THEN 
            inp_table:= 'inp_pipe';
        END IF;
        v_sql:= 'INSERT INTO '||inp_table||' (arc_id) VALUES ('||NEW.arc_id||')';
        EXECUTE v_sql;
        
        -- MAN INSERT      
        man_table := (SELECT arc_type.man_table FROM arc_type JOIN cat_arc ON (((arc_type.id)::text = (cat_arc.arctype_id)::text)) WHERE cat_arc.id=NEW.arccat_id);
        v_sql:= 'INSERT INTO '||man_table||' (arc_id) VALUES ('||NEW.arc_id||')';    
        EXECUTE v_sql;
        
        RETURN NEW;
    
    ELSIF TG_OP = 'UPDATE' THEN
    
        IF (NEW.epa_type <> OLD.epa_type) THEN    
         
            IF (OLD.epa_type = 'PIPE') THEN
                inp_table:= 'inp_pipe';            
            END IF;
            v_sql:= 'DELETE FROM '||inp_table||' WHERE arc_id = '||quote_literal(OLD.arc_id);
            EXECUTE v_sql;

            IF (NEW.epa_type = 'PIPE') THEN
                inp_table:= 'inp_pipe';   
            END IF;
            v_sql:= 'INSERT INTO '||inp_table||' (arc_id) VALUES ('||quote_literal(NEW.arc_id)||')';
            EXECUTE v_sql;

        END IF;
    
        UPDATE arc 
        SET arc_id=NEW.arc_id, arccat_id=NEW.arccat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW."state", annotation= NEW.annotation, "observ"=NEW."observ", "comment"=NEW."comment", custom_length=NEW.custom_length, 
            dma_id=NEW.dma_id, soilcat_id=NEW.soilcat_id, category_type=NEW.category_type, fluid_type=NEW.fluid_type, location_type=NEW.location_type, workcat_id=NEW.workcat_id, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate,
            ownercat_id=NEW.ownercat_id, adress_01=NEW.adress_01, adress_02=NEW.adress_02, adress_03=NEW.adress_03, descript=NEW.descript,
            rotation=NEW.rotation, link=NEW.link, verified=NEW.verified, the_geom=NEW.the_geom 
        WHERE arc_id=OLD.arc_id;
        RETURN NEW;

     ELSIF TG_OP = 'DELETE' THEN
     
        DELETE FROM arc WHERE arc_id = OLD.arc_id;
        RETURN NULL;
     
     END IF;

END;
$$;



CREATE TRIGGER v_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_node 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".v_edit_node();

CREATE TRIGGER v_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_arc 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".v_edit_arc();

      