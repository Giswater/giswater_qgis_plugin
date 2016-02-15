/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- Views structure
-- ----------------------------


CREATE VIEW "SCHEMA_NAME".v_edit_node AS
 SELECT node.node_id, 
    node.top_elev, 
    node.ymax, 
	node.nodecat_id,
	cat_node.nodetype_id
	cat_node.matcat_id
	node.epa_type,
	node.sector_id, 
    node."state", 
    node.annotation, 
    node.observ, 
    node."comment",
	node.rotation,
	node.function_type,
	node.dma_id,
	node.soilcat_id,
	node.category_type,
	node.fluid_type,
	node.location_type,
	node.workcat_id,
	node.buildercat_id,
	node.builtdate,
	node.text,
	node.adress_01,
	node.adress_02,
	node.adress_03,
	node.descript,
	node.link,
	node.verified,
	node.the_geom
   FROM ("SCHEMA_NAME".node
   JOIN "SCHEMA_NAME".cat_node ON (((node.nodecat_id)::text = (cat_node.id)::text)));


   
 CREATE VIEW "SCHEMA_NAME".v_edit_arc AS
 SELECT arc.arc_id, 
    arc.y1, 
    arc.y2,
    arc.arccat_id, 
	cat_arc.arctype_id,
    cat_arc.matcat_id,
	cat_arc.shape,
	st_length2d(arc.the_geom)::numeric(12,2) AS gis_length,
	arc.epa_type,
	arc.sector_id, 
    arc."state", 
    arc.annotation, 
    arc.observ, 
    arc."comment",
	arc.rotation,
	arc.direction,
	arc.custom_length
	arc.function_type,
	arc.dma_id,
	arc.soilcat_id,
	arc.category_type,
	arc.fluid_type,
	arc.location_type,
	arc.workcat_id,
	arc.buildercat_id,
	arc.builtdate,
	arc.text,
	arc.adress_01,
	arc.adress_02,
	arc.adress_03,
	arc.descript,
	arc.link,
	arc.verified,
	arc.the_geom
   FROM ("SCHEMA_NAME".arc
   JOIN "SCHEMA_NAME".cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text)));

   
   

-- ----------------------------
-- Function trigger definition
-- ----------------------------

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".update_v_edit_node() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
	numNodes numeric;
	sectorRecord record;
	auxNode_ID varchar;
BEGIN
	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    --	Control insertions ID	
	IF TG_OP = 'INSERT' THEN

--		Existing nodes
		numNodes := (SELECT COUNT(*) FROM node nodeOld WHERE nodeOld.the_geom && ST_Expand(NEW.the_geom, 0.1));

--		If there is an existing node closer than 0.1 meters --> error
		IF (numNodes = 0) THEN

--			Node ID
			IF (NEW.node_id IS NULL) THEN
				NEW.node_id := (SELECT nextval('inp_node_id_seq'));
			END IF;
			
--			top_elev, ymax
			IF (NEW.top_elev IS NULL) THEN 
			    NEW.top_elev = 0;
			END IF;
			IF (NEW.ymax IS NULL) THEN 
			    NEW.ymax = 0;
			END IF;
			
--			Sector ID
			IF (NEW.sector_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM sector) = 0) THEN
					RAISE EXCEPTION 'There are no sectors defined in the model, define at least one.';
				END IF;
				NEW.sector_id := (SELECT sector_id FROM sector LIMIT 1);
			END IF;

--		Trigger error				
		ELSE
			SELECT node_id INTO auxNode_ID FROM node nodeOld WHERE nodeOld.the_geom && ST_Expand(NEW.the_geom, 0.1) LIMIT 1;
			RAISE EXCEPTION 'Existing node closer than 0.1 m, node_id = (%)', node_ID;
		END IF;    
		
		INSERT INTO  node VALUES(NEW.node_id,NEW.top_elev,NEW.ymax, NEW.swmm_type, NEW.sector_id,NEW.the_geom,NEW.node_type, NEW.link, NEW."state", NEW.annotation, NEW."observ", NEW.event);
		INSERT INTO node_dat VALUES(NEW.node_id, New.soilcat_id,New.pavcat_id,'','','','','','','','','', null, null,'','','','');
		IF (NEW.swmm_type='JUNCTION') THEN
			INSERT INTO  inp_junction VALUES(NEW.node_id,null,null,null);
								
			ELSIF (NEW.swmm_type = 'DIVIDER') THEN
			INSERT INTO  inp_divider VALUES(NEW.node_id,null,null,null,null,null,null,null,null,null);
				
			ELSIF (NEW.swmm_type = 'OUTFALL') THEN
			INSERT INTO  inp_outfall VALUES(NEW.node_id,null,null,null,null,null);
				
			ELSIF (NEW.swmm_type = 'STORAGE') THEN
			INSERT INTO  inp_storage VALUES(NEW.node_id,null,null,null,null,null,null,null,null,null,null,null,null);
		
		END IF;
		
		RETURN NEW;
		
    ELSIF TG_OP = 'UPDATE' THEN
	
			IF ((NEW.swmm_type > OLD.swmm_type) OR (NEW.swmm_type < OLD.swmm_type)) THEN
										
				IF (OLD.swmm_type='JUNCTION') THEN
					DELETE FROM inp_junction WHERE node_id=OLD.node_id;
					
					ELSIF (OLD.swmm_type='DIVIDER') THEN
					DELETE FROM inp_divider WHERE node_id=OLD.node_id;
					
					ELSIF (OLD.swmm_type='OUTFALL') THEN
					DELETE FROM inp_outfall WHERE node_id=OLD.node_id;
					
					ELSIF (OLD.swmm_type='STORAGE') THEN
					DELETE FROM inp_storage WHERE node_id=OLD.node_id;

				END IF;

			END IF;
				
			
			IF ((NEW.swmm_type > OLD.swmm_type) OR (NEW.swmm_type < OLD.swmm_type)) THEN
								
				IF (NEW.swmm_type='JUNCTION') THEN
					INSERT INTO  inp_junction VALUES(NEW.node_id,null,null,null);
							
					ELSIF (NEW.swmm_type = 'DIVIDER') THEN
					INSERT INTO  inp_divider VALUES(NEW.node_id,null,null,null,null,null,null,null,null,null);
						
					ELSIF (NEW.swmm_type = 'OUTFALL') THEN
					INSERT INTO  inp_outfall VALUES(NEW.node_id,null,null,null,null,null);
						
					ELSIF (NEW.swmm_type = 'STORAGE') THEN
					INSERT INTO  inp_storage VALUES(NEW.node_id,null,null,null,null,null,null,null,null,null,null,null,null);

				END IF;
				
			END IF;
		UPDATE node SET node_id=NEW.node_id,top_elev=NEW.top_elev,ymax=NEW.ymax, swmm_type=NEW.swmm_type, sector_id=NEW.sector_id, the_geom=NEW.the_geom, node_type=NEW.node_type, link=NEW.link, "state"=NEW."state", annotation=NEW.annotation, "observ"=NEW."observ", event=NEW.event WHERE node_id=OLD.node_id;
		UPDATE node_dat SET node_id=NEW.node_id,soilcat_id=NEW.soilcat_id,pavcat_id=NEW.pavcat_id WHERE node_id=OLD.node_id;
		RETURN NEW;
    
	ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM node WHERE node_id=OLD.node_id;
	    RETURN NULL;
   
	END IF;
    RETURN NEW;
END;
$$;







CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_edit_arc() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
	numNodes numeric;
	sectorRecord record;
	auxNode_ID varchar;
BEGIN
	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
    IF TG_OP = 'INSERT' THEN
--			Arc ID
			IF (NEW.arc_id IS NULL) THEN
				NEW.arc_id := (SELECT nextval('inp_arc_id_seq'));
			END IF;
			
--			y1, y2
			IF (NEW.y1 IS NULL) THEN 
			    NEW.y1 = 0;
			END IF;
			IF (NEW.y2 IS NULL) THEN 
			    NEW.y2 = 0;
			END IF;
			
--			Sector ID
			IF (NEW.sector_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM sector) = 0) THEN
					RAISE EXCEPTION 'There are no sectors defined in the model, define at least one.';
				END IF;
				NEW.sector_id := (SELECT sector_id FROM sector LIMIT 1);
			END IF;

--			Arc catalog ID
			IF (NEW.arccat_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM cat_arc) = 0) THEN
					RAISE EXCEPTION 'There are no arc catalog defined in the model, define at least one.';
				END IF;
				NEW.arccat_id := (SELECT id FROM cat_arc LIMIT 1);
			END IF;
		
--			Material catalog ID
			IF (NEW.matcat_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM cat_mat) = 0) THEN
					RAISE EXCEPTION 'There are no materials catalog defined in the model, define at least one.';
				END IF;			
				NEW.matcat_id := (SELECT id FROM cat_mat LIMIT 1);
			END IF;
			
--			Arc ID
	
		INSERT INTO  arc VALUES(NEW.arc_id,'','', NEW.y1, NEW.y2, NEW.arccat_id, NEW.matcat_id, NEW.swmm_type, NEW.sector_id, NEW.the_geom, NEW.arc_type, NEW.direction, NEW.link, NEW."state", NEW.annotation, NEW."observ", NEW.event);
		INSERT INTO arc_dat VALUES(NEW.arc_id, New.soilcat_id,New.pavcat_id,'','','','','','','','','', null, null,'','','','');
		
		IF (NEW.swmm_type='CONDUIT') THEN
			INSERT INTO  inp_conduit VALUES(NEW.arc_id,null,null,null,null,null,null,null,null,null);
								
			ELSIF (NEW.swmm_type = 'PUMP') THEN
			INSERT INTO  inp_pump VALUES(NEW.arc_id,null,null,null,null);
				
			ELSIF (NEW.swmm_type = 'OUTLET') THEN
			INSERT INTO  inp_otulet VALUES(NEW.arc_id,null,null,null,null,null,null);
				
			ELSIF (NEW.swmm_type = 'ORIFICE') THEN
			INSERT INTO  inp_orifice VALUES(NEW.arc_id,null,null,null,null,null,null,null,null,null,null);
				
			ELSIF (NEW.swmm_type = 'WEIR') THEN
			INSERT INTO  inp_weir VALUES(NEW.arc_id,null,null,null,null,null,null,null,null,null,null,null);
				
		END IF;
		
		RETURN NEW;
    
	ELSIF TG_OP = 'UPDATE' THEN
				
			IF ((NEW.swmm_type > OLD.swmm_type) OR (NEW.swmm_type < OLD.swmm_type)) THEN
										
				IF (OLD.swmm_type='CONDUIT') THEN
					DELETE FROM inp_conduit WHERE arc_id=OLD.arc_id;
					
					ELSIF (OLD.swmm_type='PUMP') THEN
					DELETE FROM inp_pump WHERE arc_id=OLD.arc_id;
					
					ELSIF (OLD.swmm_type='WEIR') THEN
					DELETE FROM inp_weir WHERE arc_id=OLD.arc_id;
					
					ELSIF (OLD.swmm_type='ORIFICE') THEN
					DELETE FROM inp_orifice WHERE arc_id=OLD.arc_id;
					
					ELSIF (OLD.swmm_type='OUTLET') THEN
					DELETE FROM inp_outlet WHERE arc_id=OLD.arc_id;

				END IF;

			END IF;
				
			
			IF ((NEW.swmm_type > OLD.swmm_type) OR (NEW.swmm_type < OLD.swmm_type)) THEN
								
				IF (NEW.swmm_type='CONDUIT') THEN
					INSERT INTO  inp_conduit VALUES(NEW.arc_id,null,null,null,null,null,null,null,null,null);
									
					ELSIF (NEW.swmm_type = 'PUMP') THEN
					INSERT INTO  inp_pump VALUES(NEW.arc_id,null,null,null,null);
					
					ELSIF (NEW.swmm_type = 'OUTLET') THEN
					INSERT INTO  inp_outlet VALUES(NEW.arc_id,null,null,null,null,null,null);
					
					ELSIF (NEW.swmm_type = 'ORIFICE') THEN
					INSERT INTO  inp_orifice VALUES(NEW.arc_id,null,null,null,null,null,null,null,null,null,null);
					
					ELSIF (NEW.swmm_type = 'WEIR') THEN
					INSERT INTO  inp_weir VALUES(NEW.arc_id,null,null,null,null,null,null,null,null,null,null,null);

				END IF;
				
			END IF;
		
		UPDATE arc SET arc_id=NEW.arc_id,node_1='',node_2='',y1=NEW.y1,y2=NEW.y2,arccat_id=NEW.arccat_id,matcat_id=NEW.matcat_id,swmm_type=NEW.swmm_type, sector_id=NEW.sector_id,the_geom=NEW.the_geom,arc_type=NEW.arc_type, direction=NEW.direction, link=NEW.link, "state"=NEW."state", annotation=NEW.annotation, "observ"=NEW."observ", event=NEW.event WHERE arc_id=OLD.arc_id;
		UPDATE arc_dat SET arc_id=NEW.arc_id,soilcat_id=NEW.soilcat_id,pavcat_id=NEW.pavcat_id WHERE arc_id=OLD.arc_id;
		RETURN NEW;
    
	ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM arc WHERE arc_id=OLD.arc_id;
	    RETURN NULL;
     
	 END IF;
     RETURN NEW;
END;
$$;





-- ----------------------------
-- Trigger definition
-- ----------------------------


CREATE TRIGGER update_v_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_arc FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".update_v_edit_arc();
CREATE TRIGGER update_v_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_node FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".update_v_edit_node();
   