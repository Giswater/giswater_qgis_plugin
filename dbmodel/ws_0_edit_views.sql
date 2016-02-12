/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/





----------------------------
--    GIS EDITING VIEWS
----------------------------

CREATE VIEW "SCHEMA_NAME".v_edit_arc AS
 SELECT arc.arc_id, 
    arc.arccat_id, 
	st_length2d(arc.the_geom)::numeric(12,2) AS auto_length,
    arc.sector_id, 
	arc.dma_id,
    arc.the_geom,
	arc.arc_type,
	arc.enet_type, 
    arc.link, 
    arc."state", 
    arc.annotation, 
    arc.observ, 
    arc.event,
	arc_dat.soilcat_id,
	arc_dat.pavcat_id
   FROM ("SCHEMA_NAME".arc
JOIN "SCHEMA_NAME".arc_dat ON (((arc.arc_id)::text = (arc_dat.arc_id)::text)));



CREATE VIEW "SCHEMA_NAME".v_edit_node AS
 SELECT node.node_id, 
    node.elevation, 
    node.depth, 
	node.sector_id,
	node.dma_id,	
    node.the_geom,
	node.node_type, 
    node.enet_type,
	node.link, 
    node."state", 
    node.annotation, 
    node.observ, 
    node.event,
	node_dat.soilcat_id,
	node_dat.pavcat_id
   FROM ("SCHEMA_NAME".node
   JOIN "SCHEMA_NAME".node_dat ON (((node.node_id)::text = (node_dat.node_id)::text)));


   
   
   
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
			
--			elevation, depth
			IF (NEW.elevation IS NULL) THEN 
			    NEW.elevation = 0;
			END IF;
			IF (NEW.depth IS NULL) THEN 
			    NEW.depth = 0;
			END IF;
			
--			Sector ID
			IF (NEW.sector_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM sector) = 0) THEN
					RAISE EXCEPTION 'There are no sectors defined in the model, define at least one.';
				END IF;
				NEW.sector_id := (SELECT sector_id FROM sector LIMIT 1);
			END IF;
			
--			DMA  ID
			IF (NEW.dma_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM dma) = 0) THEN
					RAISE EXCEPTION 'There are no dma defined in the model, define at least one.';
				END IF;
				NEW.dma := (SELECT dma_id FROM dma LIMIT 1);
			END IF;
			

--		Trigger error				
		ELSE
			SELECT node_id INTO auxNode_ID FROM node nodeOld WHERE nodeOld.the_geom && ST_Expand(NEW.the_geom, 0.1) LIMIT 1;
			RAISE EXCEPTION 'Existing node closer than 0.1 m, node_id = (%)', node_ID;
		END IF;    
		
		INSERT INTO  node VALUES(NEW.node_id,NEW.elevation,NEW.depth, NEW.enet_type, NEW.sector_id, NEW.dma_id, NEW.the_geom, NEW.node_type, NEW.link, NEW."state", NEW.annotation, NEW."observ", NEW.event);
		INSERT INTO node_dat VALUES(NEW.node_id, New.soilcat_id,New.pavcat_id,null,null,null,null,null,null,null,null,null, null, null,null,null,null,null);
		IF (NEW.enet_type='JUNCTION') THEN
			INSERT INTO  inp_junction VALUES(NEW.node_id,null,null);
								
			ELSIF (NEW.enet_type = 'TANK') THEN
			INSERT INTO  inp_tank VALUES(NEW.node_id,null,null,null,null,null,null);
				
			ELSIF (NEW.enet_type = 'RESERVOIR') THEN
			INSERT INTO  inp_reservoir VALUES(NEW.node_id,null,null);
			
		END IF;
		
		RETURN NEW;
		
    ELSIF TG_OP = 'UPDATE' THEN
	
			IF ((NEW.enet_type > OLD.enet_type) OR (NEW.enet_type < OLD.enet_type)) THEN
										
				IF (OLD.enet_type='JUNCTION') THEN
					DELETE FROM inp_junction WHERE node_id=OLD.node_id;
					
					ELSIF (OLD.enet_type='TANK') THEN
					DELETE FROM inp_tank WHERE node_id=OLD.node_id;
					
					ELSIF (OLD.enet_type='RESERVOIR') THEN
					DELETE FROM inp_reservoir WHERE node_id=OLD.node_id;

				END IF;

			END IF;
				
			
			IF ((NEW.enet_type > OLD.enet_type) OR (NEW.enet_type < OLD.enet_type)) THEN
								
				IF (NEW.enet_type='JUNCTION') THEN
					INSERT INTO  inp_junction VALUES(NEW.node_id,null,null);
							
					ELSIF (NEW.enet_type = 'TANK') THEN
					INSERT INTO  inp_tank VALUES(NEW.node_id,null,null,null,null,null,null);
						
					ELSIF (NEW.enet_type = 'RESERVOIR') THEN
					INSERT INTO  inp_reservoir VALUES(NEW.node_id,null,null);
					
				END IF;
				
			END IF;
		UPDATE node SET node_id=NEW.node_id,elevation=NEW.elevation,depth=NEW.depth, enet_type=NEW.enet_type, sector_id=NEW.sector_id, dma_id=NEW.dma_id, the_geom=NEW.the_geom,node_type=NEW.node_type, link=NEW.link, "state"=NEW."state", annotation=NEW.annotation,"observ"=NEW."observ", event=NEW.event WHERE node_id=OLD.node_id;
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
		
--			DMA  ID
			IF (NEW.dma_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM dma) = 0) THEN
					RAISE EXCEPTION 'There are no dma defined in the model, define at least one.';
				END IF;
				NEW.dma := (SELECT dma_id FROM dma LIMIT 1);
			END IF;
				
		INSERT INTO  arc VALUES(NEW.arc_id,null,null, NEW.arccat_id, NEW.matcat_id, NEW.enet_type, NEW.sector_id, NEW.dma_id, NEW.the_geom, NEW.arc_type, NEW.link, NEW."state", NEW.annotation, NEW."observ", NEW.event);
		INSERT INTO arc_dat VALUES(NEW.arc_id, New.soilcat_id,New.pavcat_id,null,null,null,null,null,null,null,null,null, null, null,null,null,null,null);
		
		IF (NEW.enet_type='PIPE') THEN
			INSERT INTO  inp_pipe VALUES(NEW.arc_id,null,null,null,null,null,null,null,null,null);
								
			ELSIF (NEW.enet_type = 'VALVE') THEN
			INSERT INTO  inp_valve VALUES(NEW.arc_id,null,null,null,null);
				
			ELSIF (NEW.enet_type = 'PUMP') THEN
			INSERT INTO  inp_pump VALUES(NEW.arc_id,null,null,null,null,null,null);
				
		END IF;
		
		RETURN NEW;
    
	ELSIF TG_OP = 'UPDATE' THEN
				
			IF ((NEW.enet_type > OLD.enet_type) OR (NEW.enet_type < OLD.enet_type)) THEN
										
				IF (OLD.enet_type='PIPE') THEN
					DELETE FROM inp_pipe WHERE arc_id=OLD.arc_id;
					
					ELSIF (OLD.enet_type='PUMP') THEN
					DELETE FROM inp_pump WHERE arc_id=OLD.arc_id;
					
					ELSIF (OLD.enet_type='VALVE') THEN
					DELETE FROM inp_valve WHERE arc_id=OLD.arc_id;
					
				END IF;

			END IF;
				
			
			IF ((NEW.enet_type > OLD.enet_type) OR (NEW.enet_type < OLD.enet_type)) THEN
								
				IF (NEW.enet_type='PIPE') THEN
					INSERT INTO  inp_pipe VALUES(NEW.arc_id,null,null,null,null,null,null,null,null,null);
									
					ELSIF (NEW.enet_type = 'PUMP') THEN
					INSERT INTO  inp_pump VALUES(NEW.arc_id,null,null,null,null);
					
					ELSIF (NEW.enet_type = 'VALVE') THEN
					INSERT INTO  inp_valve VALUES(NEW.arc_id,null,null,null,null,null,null);
					
				END IF;
				
			END IF;
		
		UPDATE arc SET arc_id=NEW.arc_id,arccat_id=NEW.arccat_id,enet_type=NEW.enet_type, sector_id=NEW.sector_id, dma_id=NEW.dma_id, the_geom=NEW.the_geom,arc_type=NEW.arc_type, link=NEW.link, "state"=NEW."state", annotation=NEW.annotation, "observ"=NEW."observ", event=NEW.event WHERE arc_id=OLD.arc_id;
		UPDATE arc_dat SET arc_id=NEW.arc_id,soilcat_id=NEW.soilcat_id,pavcat_id=NEW.pavcat_id WHERE arc_id=OLD.arc_id;
		RETURN NEW;
    
	ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM arc WHERE arc_id=OLD.arc_id;
	    RETURN NULL;
     
	 END IF;
     RETURN NEW;
END;
$$;



CREATE TRIGGER update_v_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_arc FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".update_v_edit_arc();

CREATE TRIGGER update_v_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_node FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".update_v_edit_node();
   
   