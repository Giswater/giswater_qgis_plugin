/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


----------------------------
--    GIS EDITING VIEWS
----------------------------

CREATE VIEW "SCHEMA_NAME".v_edit_node AS
 SELECT node.node_id, 
	node.elevation, 
	node."depth", 
	node.nodecat_id,
	cat_node.nodetype_id AS "cat.nodetype",
	cat_node.matcat_id AS "cat.material",
	cat_node.pnom AS "cat.pnom",
	cat_node.dnom AS "cat.dnom",
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
	node.text,
	node.adress_01,
	node.adress_02,
	node.adress_03,
	node.descript,
	cat_node.svg AS "cat.svg",
	node.rotation,
	node.link,
	node.verified,
	node.the_geom
   FROM ("SCHEMA_NAME".node
   JOIN "SCHEMA_NAME".cat_node ON (((node.nodecat_id)::text = (cat_node.id)::text)));



 CREATE VIEW "SCHEMA_NAME".v_edit_arc AS
 SELECT arc.arc_id, 
	arc.arccat_id, 
	cat_arc.arctype_id AS "cat.arctype",
	cat_arc.matcat_id AS "cat.material",
	cat_arc.pnom AS "cat.pnom",
	cat_arc.dnom AS "cat.dnom",
	st_length2d(arc.the_geom)::numeric(12,2) AS gis_length,
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
	arc.text,
	arc.adress_01,
	arc.adress_02,
	arc.adress_03,
	arc.descript,
	cat_arc.svg AS "cat.svg",
	arc.rotation,
	arc.link,
	arc.verified,
	arc.the_geom
   FROM ("SCHEMA_NAME".arc
   JOIN "SCHEMA_NAME".cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text)));


-- ----------------------------
-- Function trigger definition
-- ----------------------------
   
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".v_edit_node() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE querystring Varchar; 
BEGIN
	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    --	Control insertions ID	
	IF TG_OP = 'INSERT' THEN
--			Node ID
			IF (NEW.node_id IS NULL) THEN
				NEW.node_id := (SELECT nextval('node_id_seq'));
			END IF;
--			elevation, depth
			IF (NEW.elevation IS NULL) THEN 
			    NEW.elevation = 0;
			END IF;
			IF (NEW.depth IS NULL) THEN 
			    NEW.depth = 0;
			END IF;
--			Node Catalog ID
			IF (NEW.nodecat_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM cat_node) = 0) THEN
					RAISE EXCEPTION 'There are no nodes catalog defined in the model, define at least one.';
				END IF;			
				NEW.nodecat_id := (SELECT id FROM cat_node LIMIT 1);
				NEW.epa_type := (SELECT epa_default FROM node_type LIMIT 1);
			END IF;
--			Sector ID
			IF (NEW.sector_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM sector) = 0) THEN
					RAISE EXCEPTION 'There are no sectors defined in the model, define at least one.';
				END IF;
				NEW.sector_id := (SELECT sector_id FROM sector LIMIT 1);
			END IF;
--			State
			IF (NEW.state IS NULL) THEN
				NEW.state := (SELECT id FROM value_state LIMIT 1);
			END IF;
--			Verified
			IF (NEW.verified IS NULL) THEN
				NEW.verified := (SELECT id FROM value_verified LIMIT 1);
			END IF;
			
			NEW.epa_type := (SELECT epa_default FROM node_type JOIN cat_node ON (((node_type.id)::text = (cat_node.nodetype_id)::text)) WHERE cat_node.id=NEW.nodecat_id);
			
-- FEATURE INSERT
			INSERT INTO node  VALUES (NEW.node_id, NEW.elevation, NEW."depth", NEW.nodecat_id, NEW.epa_type, NEW.sector_id, NEW."state", NEW.annotation, NEW."observ", NEW."comment", NEW.rotation, 
									NEW.dma_id, NEW.soilcat_id, NEW.category_type, NEW.fluid_type, NEW.location_type, NEW.workcat_id, NEW.buildercat_id, NEW.builtdate, 
									NEW.text, NEW.adress_01, NEW.adress_02, NEW.adress_03, NEW.descript, 
									NEW.link, NEW.verified, NEW.the_geom);
-- EPA INSERT	
			IF (NEW.epa_type='JUNCTION') THEN INSERT INTO  inp_junction VALUES(NEW.node_id,null,null);
			ELSIF (NEW.epa_type = 'TANK') THEN INSERT INTO  inp_tank VALUES(NEW.node_id,null,null,null,null,null,null);
			ELSIF (NEW.epa_type = 'RESERVOIR') THEN INSERT INTO  inp_reservoir VALUES(NEW.node_id,null,null);	
			END IF;

-- MANAGEMENT INSERT
			querystring := (SELECT man_table FROM node_type JOIN cat_node ON (((node_type.id)::text = (cat_node.nodetype_id)::text)) WHERE cat_node.id=NEW.nodecat_id);
			IF (querystring='man_node_junction') THEN INSERT INTO  man_node_junction VALUES(NEW.node_id,null);
			ELSIF (querystring='man_node_tank') THEN INSERT INTO  man_node_tank VALUES(NEW.node_id,null,null,null);
			ELSIF (querystring='man_node_hdyrant') THEN INSERT INTO  man_node_hdyrant VALUES(NEW.node_id,null);
			ELSIF (querystring='man_node_valve') THEN INSERT INTO  man_node_valve VALUES(NEW.node_id,null);
			END IF;
	RETURN NEW;

		
    ELSIF TG_OP = 'UPDATE' THEN
			IF ((NEW.epa_type > OLD.epa_type) OR (NEW.epa_type < OLD.epa_type)) THEN
										
				IF (OLD.epa_type='JUNCTION') THEN
					DELETE FROM inp_junction WHERE node_id=OLD.node_id;
					
					ELSIF (OLD.epa_type='TANK') THEN
					DELETE FROM inp_tank WHERE node_id=OLD.node_id;
					
					ELSIF (OLD.epa_type='RESERVOIR') THEN
					DELETE FROM inp_reservoir WHERE node_id=OLD.node_id;
				END IF;
			END IF;
			
			IF ((NEW.epa_type > OLD.epa_type) OR (NEW.epa_type < OLD.epa_type)) THEN			
				IF (NEW.epa_type='JUNCTION') THEN
					INSERT INTO  inp_junction VALUES(NEW.node_id,null,null);
							
					ELSIF (NEW.epa_type = 'TANK') THEN
					INSERT INTO  inp_tank VALUES(NEW.node_id,null,null,null,null,null,null);
						
					ELSIF (NEW.epa_type = 'RESERVOIR') THEN
					INSERT INTO  inp_reservoir VALUES(NEW.node_id,null,null);

					
				END IF;
			END IF;
		
			UPDATE 	node SET node_id=NEW.node_id, elevation=NEW.elevation, "depth"=NEW."depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW."state", annotation=NEW.annotation, "observ"=NEW."observ", rotation=NEW.rotation, 
					dma_id=NEW.dma_id, soilcat_id=NEW.soilcat_id, category_type=NEW.category_type, fluid_type=NEW.fluid_type, location_type=NEW.location_type, workcat_id=NEW.workcat_id, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate,
					text=NEW.text, adress_01=NEW.adress_01, adress_02=NEW.adress_02, adress_03=NEW.adress_03, descript=NEW.descript,
					link=NEW.link, verified=NEW.verified, the_geom=NEW.the_geom WHERE node_id=OLD.node_id;
			RETURN NEW;
    
	ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM node WHERE node_id=OLD.node_id;
		
	    RETURN NULL;
   
	END IF;
    RETURN NEW;
END;
$$;



CREATE OR REPLACE FUNCTION SCHEMA_NAME.v_edit_arc() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE querystring Varchar; 
BEGIN
	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	IF TG_OP = 'INSERT' THEN
--			Arc ID
			IF (NEW.arc_id IS NULL) THEN
				NEW.arc_id := (SELECT nextval('arc_id_seq'));
			END IF;
--			Arc catalog ID
			IF (NEW.arccat_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM cat_arc) = 0) THEN
					RAISE EXCEPTION 'There are no arc catalog defined in the model, define at least one.';
				END IF;
				NEW.arccat_id := (SELECT id FROM cat_arc LIMIT 1);
				NEW.epa_type := (SELECT epa_default FROM node_type LIMIT 1);
								
			END IF;
--			Sector ID
			IF (NEW.sector_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM sector) = 0) THEN
					RAISE EXCEPTION 'There are no sectors defined in the model, define at least one.';
				END IF;
				NEW.sector_id := (SELECT sector_id FROM sector LIMIT 1);
			END IF;
--			State
			IF (NEW.state IS NULL) THEN
				NEW.state := (SELECT id FROM value_state LIMIT 1);
			END IF;
--			Verified
			IF (NEW.verified IS NULL) THEN
				NEW.verified := (SELECT id FROM value_verified LIMIT 1);
			END IF;
			
			NEW.epa_type := (SELECT epa_default FROM arc_type JOIN cat_arc ON (((arc_type.id)::text = (cat_arc.arctype_id)::text)) WHERE cat_arc.id=NEW.arccat_id);
		
-- FEATURE INSERT
		INSERT INTO arc VALUES (NEW.arc_id, null, null, NEW.arccat_id, NEW.epa_type, NEW.sector_id, NEW."state", NEW.annotation, NEW."observ", NEW."comment", NEW.rotation, NEW.custom_length, 
								NEW.dma_id, NEW.soilcat_id, NEW.category_type, NEW.fluid_type, NEW.location_type, NEW.workcat_id, NEW.buildercat_id, NEW.builtdate, 
								NEW.text, NEW.adress_01, NEW.adress_02, NEW.adress_03, NEW.descript, 
								NEW.link, NEW.verified, NEW.the_geom);
-- EPA INSERT							
		IF (NEW.epa_type='PIPE') THEN INSERT INTO  inp_pipe VALUES(NEW.arc_id,null,null);
		ELSIF (NEW.epa_type = 'VALVE') THEN INSERT INTO  inp_valve VALUES(NEW.arc_id,null,null,null,null);
		ELSIF (NEW.epa_type = 'PUMP') THEN INSERT INTO  inp_pump VALUES(NEW.arc_id,null,null,null,null,null,null);	
		END IF;
-- MAN INSERT
		querystring := (SELECT man_table FROM arc_type JOIN cat_arc ON (((arc_type.id)::text = (cat_arc.arctype_id)::text)) WHERE cat_arc.id=NEW.arccat_id);
		IF (querystring='man_arc_pipe') THEN INSERT INTO  man_arc_pipe VALUES(NEW.arc_id,null);
		ELSIF (querystring='man_arc_valve') THEN INSERT INTO  man_arc_valve VALUES(NEW.arc_id,null);
		ELSIF (querystring='man_arc_pump') THEN INSERT INTO  man_arc_pump VALUES(NEW.arc_id,null);
		ELSIF (querystring='man_arc_filter') THEN INSERT INTO  man_arc_filter VALUES(NEW.arc_id,null);
		ELSIF (querystring='man_arc_meter') THEN INSERT INTO  man_arc_meter VALUES(NEW.arc_id,null);
		END IF;

		RETURN NEW;
    
	ELSIF TG_OP = 'UPDATE' THEN
			IF ((NEW.epa_type > OLD.epa_type) OR (NEW.epa_type < OLD.epa_type)) THEN							
				IF (OLD.epa_type='PIPE') THEN
					DELETE FROM inp_pipe WHERE arc_id=OLD.arc_id;
					
					ELSIF (OLD.epa_type='PUMP') THEN
					DELETE FROM inp_pump WHERE arc_id=OLD.arc_id;
					
					ELSIF (OLD.epa_type='VALVE') THEN
					DELETE FROM inp_valve WHERE arc_id=OLD.arc_id;
				END IF;
			END IF;
			
			IF ((NEW.epa_type > OLD.epa_type) OR (NEW.epa_type < OLD.epa_type)) THEN			
				IF (NEW.epa_type='PIPE') THEN
					INSERT INTO  inp_pipe VALUES(NEW.arc_id,null,null,null,null,null,null,null,null,null);	
		
					ELSIF (NEW.epa_type = 'PUMP') THEN
					INSERT INTO  inp_pump VALUES(NEW.arc_id,null,null,null,null);

					ELSIF (NEW.epa_type = 'VALVE') THEN
					INSERT INTO  inp_valve VALUES(NEW.arc_id,null,null,null,null,null,null);
				END IF;
			END IF;
		
		UPDATE arc 	SET arc_id=NEW.arc_id, arccat_id=NEW.arccat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW."state", annotation= NEW.annotation, "observ"=NEW."observ", "comment"=NEW."comment", rotation=NEW.rotation, custom_length=NEW.custom_length, 
						dma_id=NEW.dma_id, soilcat_id=NEW.soilcat_id, category_type=NEW.category_type, fluid_type=NEW.fluid_type, location_type=NEW.location_type, workcat_id=NEW.workcat_id, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate,
						text=NEW.text, adress_01=NEW.adress_01, adress_02=NEW.adress_02, adress_03=NEW.adress_03, descript=NEW.descript,
						link=NEW.link, verified=NEW.verified, the_geom=NEW.the_geom WHERE arc_id=OLD.arc_id;
		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM arc WHERE arc_id=OLD.arc_id;
	    RETURN NULL;
     
	END IF;
    
    RETURN NEW;
    
END;
$$;



CREATE TRIGGER v_edit_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_node FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".v_edit_node();

CREATE TRIGGER v_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_arc FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".v_edit_arc();
   
   