/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- View structure for v_inp_edit
-- ----------------------------
CREATE VIEW "SCHEMA_NAME"."v_inp_edit_junction" AS 
SELECT node.node_id, node.elevation, node."depth", inp_junction.demand, inp_junction.pattern_id, node.sector_id, node.dma_id, node.the_geom 
, node.node_type, node."state", node.observ, node.event,node_dat.soilcat_id,node_dat.pavcat_id
FROM ("SCHEMA_NAME".node
JOIN "SCHEMA_NAME".inp_junction ON (((inp_junction.node_id)::text = (node.node_id)::text))
JOIN "SCHEMA_NAME".node_dat ON (((node.node_id)::text = (node_dat.node_id)::text)));



CREATE VIEW "SCHEMA_NAME"."v_inp_edit_pipe" AS 
SELECT arc.arc_id, cat_arc.id AS arccat_id, inp_pipe.minorloss, inp_pipe.status, arc.sector_id, arc.dma_id, arc.the_geom 
, arc.arc_type, arc."state", arc.observ, arc.event,	arc_dat.soilcat_id,	arc_dat.pavcat_id
FROM ((SCHEMA_NAME.arc 
JOIN SCHEMA_NAME.inp_pipe ON (((inp_pipe.arc_id)::text = (arc.arc_id)::text)))
JOIN SCHEMA_NAME.cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text))
JOIN "SCHEMA_NAME".arc_dat ON (((arc.arc_id)::text = (arc_dat.arc_id)::text)));





CREATE VIEW "SCHEMA_NAME"."v_inp_edit_pump" AS 
SELECT inp_pump.arc_id, cat_arc.id AS arccat_id, inp_pump.power, inp_pump.curve_id, inp_pump.speed, inp_pump.pattern, inp_pump.status, arc.sector_id, arc.dma_id, arc.the_geom 
, arc.arc_type, arc."state", arc.observ, arc.event, arc_dat.soilcat_id,	arc_dat.pavcat_id
FROM ((SCHEMA_NAME.arc 
JOIN SCHEMA_NAME.inp_pump ON (((arc.arc_id)::text = (inp_pump.arc_id)::text)))
JOIN SCHEMA_NAME.cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text))   
JOIN "SCHEMA_NAME".arc_dat ON (((arc.arc_id)::text = (arc_dat.arc_id)::text)));





CREATE VIEW "SCHEMA_NAME"."v_inp_edit_reservoir" AS 
SELECT inp_reservoir.node_id, node.elevation, node."depth", inp_reservoir.head, inp_reservoir.pattern_id, node.sector_id, node.dma_id, node.the_geom 
, node.node_type, node."state", node.observ, node.event, node_dat.soilcat_id, node_dat.pavcat_id
FROM (SCHEMA_NAME.node 
JOIN SCHEMA_NAME.inp_reservoir ON (((inp_reservoir.node_id)::text = (node.node_id)::text))
JOIN "SCHEMA_NAME".node_dat ON (((node.node_id)::text = (node_dat.node_id)::text)));




CREATE VIEW "SCHEMA_NAME"."v_inp_edit_tank" AS 
SELECT node.node_id, node.elevation, node."depth", inp_tank.initlevel, inp_tank.minlevel, inp_tank.maxlevel, inp_tank.diameter, inp_tank.minvol, inp_tank.curve_id, node.sector_id, node.dma_id, node.the_geom 
, node.node_type ,node."state", node.observ, node.event,node_dat.soilcat_id,node_dat.pavcat_id
FROM (SCHEMA_NAME.inp_tank 
JOIN SCHEMA_NAME.node ON (((inp_tank.node_id)::text = (node.node_id)::text))
JOIN "SCHEMA_NAME".node_dat ON (((node.node_id)::text = (node_dat.node_id)::text)));





CREATE VIEW "SCHEMA_NAME"."v_inp_edit_valve" AS 
SELECT inp_valve.arc_id, cat_arc.id AS arccat_id, inp_valve.valv_type, inp_valve.pressure, inp_valve.flow, inp_valve.coef_loss, inp_valve.curve_id, inp_valve.minorloss, inp_valve.status, arc.sector_id, arc.dma_id, arc.the_geom 
, arc.arc_type, arc."state", arc.observ, arc.event, arc_dat.soilcat_id,	arc_dat.pavcat_id
FROM ((SCHEMA_NAME.arc 
JOIN SCHEMA_NAME.inp_valve ON (((arc.arc_id)::text = (inp_valve.arc_id)::text)))
JOIN SCHEMA_NAME.cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text))
JOIN "SCHEMA_NAME".arc_dat ON (((arc.arc_id)::text = (arc_dat.arc_id)::text)));






-----------------------------
-- TRIGGERS EDITING VIEWS
-----------------------------

CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_junction() RETURNS trigger LANGUAGE plpgsql AS $$

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
--		numNodes = 0;
		
--		If there is an existing node closer than 0.1 meters --> error
		IF (numNodes = 0) THEN

--			Node ID
			IF (NEW.node_id IS NULL) THEN
				NEW.node_id := (SELECT nextval('inp_node_id_seq'));
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
			RAISE EXCEPTION 'Existing node closer than 0.1 m, node_id = (%)', node_id;
		END IF;

		INSERT INTO node VALUES(NEW.node_id,NEW.elevation, NEW."depth", 'JUNCTION'::text,NEW.sector_id, NEW.dma_id,NEW.the_geom, NEW.node_type, NEW."state", NEW."observ", NEW.event);
		INSERT INTO inp_junction VALUES(NEW.node_id,NEW.demand,NEW.pattern_id);
		INSERT INTO node_dat VALUES(NEW.node_id, null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN
		UPDATE node SET node_id=NEW.node_id, elevation=NEW.elevation, "depth"=NEW."depth", sector_id=NEW.sector_id, dma_id=NEW.dma_id, the_geom=NEW.the_geom, node_type=NEW.node_type, "state"=NEW."state", "observ"=NEW."observ", event=NEW.event WHERE node_id=OLD.node_id;
		UPDATE inp_junction SET node_id=NEW.node_id, demand=NEW.demand, pattern_id=NEW.pattern_id WHERE node_id=OLD.node_id;
       RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM node WHERE node_id=OLD.node_id;
		DELETE FROM inp_junction WHERE node_id=OLD.node_id;
		DELETE FROM node_dat WHERE node_id=OLD.node_id;
	    RETURN NULL;
    
	END IF;
    RETURN NEW;
END;
$$;



  
-- Function: SCHEMA_NAME.update_v_inp_edit_pipe()

CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_pipe() RETURNS trigger LANGUAGE plpgsql AS $$

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
					RAISE EXCEPTION 'There are no arcs catalog defined in the model, define at least one.';
				END IF;			
				NEW.arccat_id := (SELECT id FROM cat_arc LIMIT 1);
			END IF;
	
		INSERT INTO arc VALUES(NEW.arc_id, null, null, NEW.arccat_id, 'PIPE'::TEXT, NEW.sector_id, NEW.dma_id, NEW.the_geom, NEW.arc_type, NEW."state", NEW."observ", NEW.event);
		INSERT INTO inp_pipe VALUES(NEW.arc_id, NEW.minorloss, NEW.status);
		INSERT INTO arc_dat VALUES(NEW.arc_id, 'DEFAULT','DEFAULT',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
		RETURN NEW;
    
	ELSIF TG_OP = 'UPDATE' THEN
		UPDATE arc SET arc_id=NEW.arc_id, arccat_id=NEW.arccat_id, enet_type='PIPE'::TEXT, sector_id=NEW.sector_id, dma_id=NEW.dma_id, the_geom=NEW.the_geom, arc_type=NEW.arc_type, "state"=NEW."state", "observ"=NEW."observ", event=NEW.event WHERE arc_id=OLD.arc_id;
		UPDATE inp_pipe SET arc_id=NEW.arc_id, minorloss=NEW.minorloss, status=NEW.status WHERE arc_id=OLD.arc_id;
		RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM arc WHERE arc_id=OLD.arc_id;
		DELETE FROM inp_pipe WHERE arc_id=OLD.arc_id;
		DELETE FROM arc_dat WHERE arc_id=OLD.arc_id;
	    RETURN NULL;
    
	END IF;
    RETURN NEW;
END;
$$;
  
  
-- Function: SCHEMA_NAME.update_v_inp_edit_pump()

CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_pump() RETURNS trigger LANGUAGE plpgsql AS $$

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
					RAISE EXCEPTION 'There are no arcs catalog defined in the model, define at least one.';
				END IF;			
				NEW.arccat_id := (SELECT id FROM cat_arc LIMIT 1);
			END IF;
			
		INSERT INTO arc VALUES(NEW.arc_id, null, null, NEW.arccat_id, 'PUMP'::TEXT, NEW.sector_id, NEW.dma_id, NEW.the_geom, NEW.arc_type, NEW."state", NEW."observ", NEW.event);
		INSERT INTO inp_pump VALUES(NEW.arc_id, NEW.power, NEW.curve_id, NEW.speed, NEW.pattern, NEW.status);
		INSERT INTO arc_dat VALUES(NEW.arc_id, 'DEFAULT','DEFAULT',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
		RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
		UPDATE arc SET arc_id=NEW.arc_id, arccat_id=NEW.arccat_id, enet_type='PUMP'::TEXT, sector_id=NEW.sector_id, dma_id=NEW.dma_id, the_geom=NEW.the_geom, arc_type=NEW.arctype, "state"=NEW."state", "observ"=NEW."observ", event=NEW.event WHERE arc_id=OLD.arc_id;
		UPDATE inp_pump SET arc_id=NEW.arc_id, power=NEW.power, curve_id=NEW.curve_id, speed=NEW.speed, pattern=NEW.pattern, status=NEW.status WHERE arc_id=OLD.arc_id;
		RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM arc WHERE arc_id=OLD.arc_id;
		DELETE FROM inp_pump WHERE arc_id=OLD.arc_id;
		DELETE FROM arc_dat WHERE arc_id=OLD.arc_id;
	    RETURN NULL;
		
    END IF;
    RETURN NEW;
END;
$$;

 
  
  
-- Function: SCHEMA_NAME.update_v_inp_edit_reservoir()

CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_reservoir() RETURNS trigger LANGUAGE plpgsql AS $$

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
--		numNodes = 0;

--		If there is an existing node closer than 0.1 meters --> error
		IF (numNodes = 0) THEN

--			Node ID
			IF (NEW.node_id IS NULL) THEN
				NEW.node_id := (SELECT nextval('inp_node_id_seq'));
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
			RAISE EXCEPTION 'Existing node closer than 0.1 m, node_id = (%)', node_id;
		END IF;
		
		INSERT INTO node VALUES(NEW.node_id, NEW.elevation, NEW."depth", 'RESERVOIR'::text, NEW.sector_id, NEW.dma_id, NEW.the_geom, NEW.node_type, NEW."state", NEW."observ", NEW.event);
		INSERT INTO inp_reservoir VALUES(NEW.node_id, NEW.head, NEW.pattern_id);
		INSERT INTO node_dat VALUES(NEW.node_id, 'DEFAULT','DEFAULT',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN
		UPDATE node SET node_id=NEW.node_id, elevation=NEW.elevation, "depth"=NEW."depth", sector_id=NEW.sector_id, dma_id=NEW.dma_id,the_geom=NEW.the_geom, node_type=NEW.node_type, "state"=NEW."state", "observ"=NEW."observ", event=NEW.event WHERE node_id=OLD.node_id;
		UPDATE inp_reservoir SET node_id=NEW.node_id, head=NEW.head, pattern_id=NEW.pattern_id WHERE node_id=OLD.node_id;
		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM node WHERE node_id=OLD.node_id;
		DELETE FROM inp_reservoir WHERE node_id=OLD.node_id;
		DELETE FROM node_dat WHERE node_id=OLD.node_id;
	    RETURN NULL;
     
	END IF;
    RETURN NEW;
END;
$$;

  
  
-- Function: SCHEMA_NAME.update_v_inp_edit_tank()

CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_tank() RETURNS trigger LANGUAGE plpgsql AS $$

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
--		numNodes = 0;
		
--		If there is an existing node closer than 0.1 meters --> error
		IF (numNodes = 0) THEN

--			Node ID
			IF (NEW.node_id IS NULL) THEN
				NEW.node_id := (SELECT nextval('inp_node_id_seq'));
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
			RAISE EXCEPTION 'Existing node closer than 0.1 m, node_id = (%)', node_id;
		END IF;

		INSERT INTO node VALUES(NEW.node_id, NEW.elevation, NEW."depth", 'TANK'::text, NEW.sector_id, NEW.dma_id, NEW.the_geom, NEW.node_type, NEW."state", NEW."observ", NEW.event);
		INSERT INTO inp_tank VALUES(NEW.node_id,NEW.initlevel,NEW.minlevel,NEW.maxlevel,NEW.diameter,NEW.minvol,NEW.curve_id);
		INSERT INTO node_dat VALUES(NEW.node_id, 'DEFAULT','DEFAULT',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
		RETURN NEW;
   
	ELSIF TG_OP = 'UPDATE' THEN
		UPDATE node SET node_id=NEW.node_id, elevation=NEW.elevation, "depth"=NEW."depth", sector_id=NEW.sector_id, dma_id=NEW.dma_id, the_geom=NEW.the_geom, node_type=NEW.node_type, "state"=NEW."state", "observ"=NEW."observ", event=NEW.event WHERE node_id=OLD.node_id;
		UPDATE inp_tank SET node_id=NEW.node_id, initlevel=NEW.initlevel, minlevel=NEW.minlevel, maxlevel=NEW.maxlevel, diameter=NEW.diameter, minvol=NEW.minvol, curve_id=NEW.curve_id WHERE node_id=OLD.node_id;
		RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM node WHERE node_id=OLD.node_id;
		DELETE FROM inp_tank WHERE node_id=OLD.node_id;
		DELETE FROM node_dat WHERE node_id=OLD.node_id;
	    RETURN NULL;
		
	END IF;
    RETURN NEW;
END;
$$;



-- Function: SCHEMA_NAME.update_v_inp_edit_valve()
CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_valve() RETURNS trigger LANGUAGE plpgsql AS $$

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
					RAISE EXCEPTION 'There are no arcs catalog defined in the model, define at least one.';
				END IF;			
				NEW.arccat_id := (SELECT id FROM cat_arc LIMIT 1);
			END IF;
			
		INSERT INTO arc VALUES(NEW.arc_id, null, null, NEW.arccat_id, 'VALVE'::TEXT, NEW.sector_id, NEW.dma_id, NEW.the_geom, NEW.arc_type, NEW."state", NEW."observ", NEW.event);
		INSERT INTO inp_valve VALUES(NEW.arc_id, NEW.valv_type, NEW.pressure, NEW.flow, NEW.coef_loss, NEW.curve_id, NEW.minorloss, NEW.status);
		INSERT INTO arc_dat VALUES(NEW.arc_id, 'DEFAULT','DEFAULT',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
		RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
		UPDATE arc SET arc_id=NEW.arc_id, arccat_id=NEW.arccat_id, enet_type='VALVE'::TEXT, sector_id=NEW.sector_id, dma_id=NEW.dma_id, the_geom=NEW.the_geom, arc_type=NEW.arc_type, "state"=NEW."state", "observ"=NEW."observ", event=NEW.event WHERE arc_id=OLD.arc_id;
		UPDATE inp_valve SET arc_id=NEW.arc_id, valv_type=NEW.valv_type, pressure=NEW.pressure, flow=NEW.flow, coef_loss=NEW.coef_loss, curve_id=NEW.curve_id, minorloss=NEW.minorloss, status=NEW.status WHERE arc_id=OLD.arc_id;
		RETURN NEW;
    
	ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM arc WHERE arc_id=OLD.arc_id;
		DELETE FROM inp_valve WHERE arc_id=OLD.arc_id;
		DELETE FROM arc_dat WHERE arc_id=OLD.arc_id;
	    RETURN NULL;
    
	END IF;
    RETURN NEW;
END;
$$;


CREATE TRIGGER update_v_inp_edit_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_inp_edit_tank FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".update_v_inp_edit_tank();

CREATE TRIGGER update_v_inp_edit_reservoir INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_inp_edit_reservoir FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".update_v_inp_edit_reservoir();

CREATE TRIGGER update_v_inp_edit_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_inp_edit_junction FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".update_v_inp_edit_junction();

CREATE TRIGGER update_v_inp_edit_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_inp_edit_pipe FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".update_v_inp_edit_pipe();

CREATE TRIGGER update_v_inp_edit_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_inp_edit_valve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".update_v_inp_edit_valve();

CREATE TRIGGER update_v_inp_edit_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_inp_edit_pump FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".update_v_inp_edit_pump();

   
  
  
   
   
   