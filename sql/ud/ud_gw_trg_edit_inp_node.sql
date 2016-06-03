/*
This file is part of Giswater 2.0
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
    RAISE EXCEPTION 'Insert features is forbidden. To insert new features use the GIS FEATURES layers agrupation of TOC';
	RETURN NEW;
/*
--	To disable the insert option
    RAISE EXCEPTION 'Insert features is forbidden. To insert new features use the GIS FEATURES layers agrupation of TOC';
	  RETURN NULL;


        -- Node ID
        IF (NEW.node_id IS NULL) THEN
            NEW.node_id := (SELECT nextval('node_id_seq'));
        END IF;
		
		 -- elev
        IF (NEW.elev IS NOT NULL) THEN   	
			RAISE EXCEPTION 'Please, review your data: elev is not an updatable field.';
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
        INSERT INTO node VALUES (NEW.node_id, NEW.top_elev, NEW.ymax, NEW.sander, NEW.node_type, NEW.nodecat_id, epa_type::text, NEW.sector_id, NEW."state", NEW.annotation, NEW."observ", NEW."comment", NEW.dma_id, 
								null, null, null, null, null ,null, null,
                                null, null, null, null, null,
                                NEW.est_top_elev, NEW.est_ymax, NEW.rotation, NEW.link,  NEW.verified, NEW.the_geom);

        -- EPA INSERT
        IF node_table = 'inp_junction' THEN        
			INSERT INTO  inp_junction VALUES(NEW.node_id,NEW.y0,NEW.ysur,NEW.apond);
        ELSIF node_table = 'inp_divider' THEN        
			INSERT INTO  inp_divider VALUES(NEW.node_id,NEW.divider_type,NEW.arc_id,NEW.curve_id,NEW.qmin,NEW.ht,NEW.cd,NEW.y0,NEW.ysur,NEW.apond);           
        ELSIF node_table = 'inp_storage' THEN
			INSERT INTO  inp_storage VALUES(NEW.node_id,NEW.storage_type,NEW.curve_id,NEW.a1,NEW.a2,NEW.a0,NEW.fevap,NEW.sh,NEW.hc,NEW.imd,NEW.y0,NEW.ysur,NEW.apond);
        ELSIF node_table = 'inp_outfall' THEN            
			INSERT INTO  inp_outfall VALUES(NEW.node_id,NEW.outfall_type,NEW.stage,NEW.curve_id,NEW.timser_id,NEW.gate);
        END IF;

        -- MANAGEMENT INSERT
        man_table:= (SELECT node_type.man_table FROM node_type WHERE node_type.id=NEW.node_type);
        IF man_table IS NOT NULL THEN        
            v_sql:= 'INSERT INTO '||man_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
            EXECUTE v_sql;
        END IF;
        RETURN NEW;

		RETURN NULL;
*/

    ELSIF TG_OP = 'UPDATE' THEN

        -- UPDATE position 
        IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom)THEN   
            NEW.sector_id:= (SELECT sector_id FROM sector WHERE (NEW.the_geom @ sector.the_geom) LIMIT 1);           
            NEW.dma_id := (SELECT dma_id FROM dma WHERE (NEW.the_geom @ dma.the_geom) LIMIT 1);         
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
        SET node_id=NEW.node_id, top_elev=NEW.top_elev, ymax=NEW.ymax, sander=NEW.sander, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, sector_id=NEW.sector_id, "state"=NEW."state", 
            annotation=NEW.annotation, "observ"=NEW."observ", "comment"=NEW."comment", est_top_elev=NEW.est_top_elev, est_ymax=NEW.est_ymax, rotation=NEW.rotation, link=NEW.link, verified=NEW.verified, the_geom=NEW.the_geom 
        WHERE node_id=OLD.node_id;

        IF node_table = 'inp_junction' THEN
            UPDATE inp_junction SET node_id=NEW.node_id, y0=NEW.y0, ysur=NEW.ysur, apond=NEW.apond WHERE node_id=OLD.node_id;
        ELSIF node_table = 'inp_divider' THEN
            UPDATE inp_divider SET node_id=NEW.node_id, divider_type=NEW.divider_type, arc_id=NEW.arc_id, curve_id=NEW.curve_id,qmin=NEW.qmin,ht=NEW.ht,cd=NEW.cd,y0=NEW.y0, ysur=NEW.ysur, apond=NEW.apond WHERE node_id=OLD.node_id; 
        ELSIF node_table = 'inp_storage' THEN
            UPDATE inp_storage SET node_id=NEW.node_id, storage_type=NEW.storage_type,curve_id=NEW.curve_id,a1=NEW.a1,a2=NEW.a2,a0=NEW.a0,fevap=NEW.fevap,sh=NEW.sh,hc=NEW.hc,imd=NEW.imd,y0=NEW.y0, ysur=NEW.ysur, apond=NEW.apond WHERE node_id=OLD.node_id;
        ELSIF node_table = 'inp_outlfall' THEN          
            UPDATE inp_outfall SET node_id=NEW.node_id,outfall_type=NEW.outfall_type,stage=NEW.stage,curve_id=NEW.curve_id,timser_id=NEW.timser_id,gate=NEW.gate WHERE node_id=OLD.node_id;
        END IF;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM node WHERE node_id = OLD.node_id;
        EXECUTE 'DELETE FROM '||node_table||' WHERE node_id = '||quote_literal(OLD.node_id);
        RETURN NULL;
    
    END IF;
       
END;
$$;



CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_junction 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_junction', 'JUNCTION');
 
CREATE TRIGGER gw_trg_edit_inp_node_divider INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_divider
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_divider', 'DIVIDER');

CREATE TRIGGER gw_trg_edit_inp_node_outfall INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_outfall
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_outfall', 'OUTFALL');

CREATE TRIGGER gw_trg_edit_inp_node_storage INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_storage 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_storage', 'STORAGE');


  
  