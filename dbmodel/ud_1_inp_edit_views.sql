/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- View structure for v_inp_edit
-- ----------------------------
CREATE VIEW "SCHEMA_NAME".v_inp_edit_conduit AS
 SELECT arc.arc_id, 
    arc.y1, 
    arc.y2,
    arc.arccat_id, 
    arc.matcat_id, 
    inp_conduit.barrels, 
    inp_conduit.culvert, 
    inp_conduit.kentry, 
    inp_conduit.kexit, 
    inp_conduit.kavg, 
    inp_conduit.flap, 
    inp_conduit.q0, 
    inp_conduit.qmax, 
    inp_conduit.seepage,
    arc.sector_id, 
    arc.the_geom, 
    arc.arc_type, 
    arc.direction, 
    arc."state", 
    arc.observ, 
    arc.event,
	arc_dat.soilcat_id,
	arc_dat.pavcat_id
	
   FROM ("SCHEMA_NAME".arc
   JOIN "SCHEMA_NAME".inp_conduit ON (((arc.arc_id)::text = (inp_conduit.arc_id)::text))
   JOIN "SCHEMA_NAME".arc_dat ON (((arc.arc_id)::text = (arc_dat.arc_id)::text)));


CREATE VIEW "SCHEMA_NAME".v_inp_edit_divider AS
 SELECT node.node_id, 
    node.top_elev, 
    node.ymax, 
    inp_divider.divider_type, 
    inp_divider.arc_id, 
    inp_divider.curve_id, 
    inp_divider.qmin, 
    inp_divider.ht, 
    inp_divider.cd, 
    inp_divider.y0, 
    inp_divider.ysur, 
    inp_divider.apond, 
    node.sector_id, 
    node.the_geom, 
    node.node_type, 
    node."state", 
    node.observ, 
    node.event,
	node_dat.soilcat_id,
	node_dat.pavcat_id
	
   FROM ("SCHEMA_NAME".node
   JOIN "SCHEMA_NAME".inp_divider ON (((node.node_id)::text = (inp_divider.node_id)::text))
   JOIN "SCHEMA_NAME".node_dat ON (((node.node_id)::text = (node_dat.node_id)::text)));


CREATE VIEW "SCHEMA_NAME".v_inp_edit_junction AS
 SELECT node.node_id, 
    node.top_elev, 
    node.ymax, 
    inp_junction.y0, 
    inp_junction.ysur, 
    inp_junction.apond, 
    node.sector_id, 
    node.the_geom, 
    node.node_type, 
    node."state", 
    node.observ, 
    node.event,
	node_dat.soilcat_id,
	node_dat.pavcat_id
	
   FROM ("SCHEMA_NAME".node
   JOIN "SCHEMA_NAME".inp_junction ON (((inp_junction.node_id)::text = (node.node_id)::text))
   JOIN "SCHEMA_NAME".node_dat ON (((node.node_id)::text = (node_dat.node_id)::text)));



CREATE VIEW "SCHEMA_NAME".v_inp_edit_orifice AS
 SELECT arc.arc_id, 
    arc.y1, 
    arc.y2,
    arc.arccat_id, 
    arc.matcat_id, 
    inp_orifice.ori_type, 
    inp_orifice."offset", 
    inp_orifice.cd, 
    inp_orifice.orate, 
    inp_orifice.flap, 
    inp_orifice.shape, 
    inp_orifice.geom1, 
    inp_orifice.geom2, 
    inp_orifice.geom3, 
    inp_orifice.geom4, 
    arc.sector_id, 
    arc.the_geom, 
    arc.arc_type, 
    arc."state", 
    arc.observ, 
    arc.event,
	arc_dat.soilcat_id,
	arc_dat.pavcat_id

   FROM ("SCHEMA_NAME".arc
   JOIN "SCHEMA_NAME".inp_orifice ON (((arc.arc_id)::text = (inp_orifice.arc_id)::text))
   JOIN "SCHEMA_NAME".arc_dat ON (((arc.arc_id)::text = (arc_dat.arc_id)::text)));



CREATE VIEW "SCHEMA_NAME".v_inp_edit_outfall AS
 SELECT node.node_id, 
    node.top_elev, 
    node.ymax, 
    inp_outfall.outfall_type, 
    inp_outfall.stage, 
    inp_outfall.curve_id, 
    inp_outfall.timser_id, 
    inp_outfall.gate, 
    node.sector_id, 
    node.the_geom, 
    node.node_type, 
    node."state", 
    node.observ, 
    node.event,
	node_dat.soilcat_id,
	node_dat.pavcat_id
	
   FROM ("SCHEMA_NAME".node
   JOIN "SCHEMA_NAME".inp_outfall ON (((node.node_id)::text = (inp_outfall.node_id)::text))
   JOIN "SCHEMA_NAME".node_dat ON (((node.node_id)::text = (node_dat.node_id)::text)));



CREATE VIEW "SCHEMA_NAME".v_inp_edit_outlet AS
 SELECT arc.arc_id, 
    arc.y1, 
    arc.y2, 
    inp_outlet.outlet_type, 
    inp_outlet."offset", 
    inp_outlet.curve_id, 
    inp_outlet.cd1, 
    inp_outlet.cd2, 
    inp_outlet.flap, 
    arc.sector_id, 
    arc.the_geom, 
    arc.arc_type, 
    arc.direction, 
    arc."state", 
    arc.observ, 
    arc.event,
	arc_dat.soilcat_id,
	arc_dat.pavcat_id
	
   FROM ("SCHEMA_NAME".arc
   JOIN "SCHEMA_NAME".inp_outlet ON (((arc.arc_id)::text = (inp_outlet.arc_id)::text))
   JOIN "SCHEMA_NAME".arc_dat ON (((arc.arc_id)::text = (arc_dat.arc_id)::text)));



CREATE VIEW "SCHEMA_NAME".v_inp_edit_pump AS
 SELECT arc.arc_id, 
    arc.y1, 
    arc.y2,
    arc.arccat_id, 
    arc.matcat_id, 
    inp_pump.curve_id, 
    inp_pump.status, 
    inp_pump.startup, 
    inp_pump.shutoff, 
    arc.sector_id, 
    arc.the_geom, 
    arc.arc_type, 
    arc.direction, 
    arc."state", 
    arc.observ, 
    arc.event,
	arc_dat.soilcat_id,
	arc_dat.pavcat_id
	
   FROM ("SCHEMA_NAME".arc
   JOIN "SCHEMA_NAME".inp_pump ON (((arc.arc_id)::text = (inp_pump.arc_id)::text))
   JOIN "SCHEMA_NAME".arc_dat ON (((arc.arc_id)::text = (arc_dat.arc_id)::text)));



CREATE VIEW "SCHEMA_NAME".v_inp_edit_storage AS
 SELECT node.node_id, 
    node.top_elev, 
    node.ymax, 
    inp_storage.storage_type, 
    inp_storage.curve_id, 
    inp_storage.a1, 
    inp_storage.a2, 
    inp_storage.a0, 
    inp_storage.fevap, 
    inp_storage.sh, 
    inp_storage.hc, 
    inp_storage.imd, 
    inp_storage.y0, 
    inp_storage.ysur, 
    inp_storage.apond, 
    node.sector_id, 
    node.the_geom, 
    node.node_type, 
    node."state", 
    node.observ, 
    node.event,
	node_dat.soilcat_id,
	node_dat.pavcat_id

   FROM ("SCHEMA_NAME".node
   JOIN "SCHEMA_NAME".inp_storage ON (((node.node_id)::text = (inp_storage.node_id)::text))
   JOIN "SCHEMA_NAME".node_dat ON (((node.node_id)::text = (node_dat.node_id)::text)));



CREATE VIEW "SCHEMA_NAME".v_inp_edit_weir AS
 SELECT arc.arc_id, 
    arc.y1, 
    arc.y2,
    arc.arccat_id, 
    arc.matcat_id, 
    inp_weir.weir_type, 
    inp_weir."offset", 
    inp_weir.cd, 
    inp_weir.ec, 
    inp_weir.cd2, 
    inp_weir.flap, 
    inp_weir.geom1, 
    inp_weir.geom2, 
    inp_weir.geom3, 
    inp_weir.geom4,
    inp_weir.surcharge,	
    arc.sector_id, 
    arc.the_geom, 
    arc.arc_type, 
    arc.direction,  
    arc."state",  
    arc.observ, 
    arc.event,
	arc_dat.soilcat_id,
	arc_dat.pavcat_id

   FROM ("SCHEMA_NAME".arc
   JOIN "SCHEMA_NAME".inp_weir ON (((arc.arc_id)::text = (inp_weir.arc_id)::text))
   JOIN "SCHEMA_NAME".arc_dat ON (((arc.arc_id)::text = (arc_dat.arc_id)::text)));






-----------------------------
-- TRIGGERS EDITING VIEWS
-----------------------------

CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_conduit() RETURNS trigger LANGUAGE plpgsql AS $$
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
			
-- 			barrels
			IF (NEW.barrels IS NULL) THEN 
			    NEW.barrels = 1;
			END IF;
			
--			kentry, kexit, kavg		
			IF (NEW.kentry IS NULL) THEN 
			    NEW.kentry = 0;
			END IF;
			IF (NEW.kexit IS NULL) THEN 
			    NEW.kexit = 0;
			END IF;
			IF (NEW.kavg IS NULL) THEN 
			    NEW.kavg = 0;
			END IF;
			
--			q0, qmax
			IF (NEW.q0 IS NULL) THEN 
			    NEW.q0 = 0;
			END IF;
			IF (NEW.qmax IS NULL) THEN 
			    NEW.qmax = 0;
			END IF;

--			flap_gate
			IF (NEW.flap IS NULL) THEN 
			    NEW.flap = 'NO';
			END IF;

--			seepage
			IF (NEW.seepage IS NULL) THEN 
			    NEW.seepage = 0;
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
	
		INSERT INTO  arc VALUES(NEW.arc_id,'','',NEW.y1,NEW.y2,NEW.arccat_id,NEW.matcat_id,'CONDUIT'::TEXT,NEW.sector_id,NEW.the_geom, NEW.arc_type, NEW.direction, NEW."state", NEW."observ", NEW.event);
		INSERT INTO  inp_conduit VALUES(NEW.arc_id,NEW.barrels,NEW.culvert,NEW.kentry,NEW.kexit,NEW.kavg,NEW.flap,NEW.q0,NEW.qmax, NEW.seepage);
		INSERT INTO arc_dat VALUES(NEW.arc_id, NEW.soilcat_id, NEW.pavcat_id,'','','','','','','','','', null, null,'','','','');
		RETURN NEW;
    
	ELSIF TG_OP = 'UPDATE' THEN
		UPDATE arc SET arc_id=NEW.arc_id,node_1='',node_2='',y1=NEW.y1,y2=NEW.y2,arccat_id=NEW.arccat_id,matcat_id=NEW.matcat_id,sector_id=NEW.sector_id,the_geom=NEW.the_geom,arc_type=NEW.arc_type, direction=NEW.direction, "state"=NEW."state", "observ"=NEW."observ", event=NEW.event WHERE arc_id=OLD.arc_id;
		UPDATE inp_conduit SET arc_id=NEW.arc_id,barrels=NEW.barrels,culvert=NEW.culvert,kentry=NEW.kentry,kexit=NEW.kexit,kavg=NEW.kavg,flap=NEW.flap,q0=NEW.q0,qmax=NEW.qmax, seepage=NEW.seepage WHERE arc_id=OLD.arc_id;
		UPDATE arc_dat SET arc_id=NEW.arc_id, soilcat_id=NEW.soilcat_id, pavcat_id=NEW.pavcat_id WHERE arc_id=OLD.arc_id;
		RETURN NEW;
    
	ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM arc WHERE arc_id=OLD.arc_id;
		DELETE FROM inp_conduit WHERE arc_id=OLD.arc_id;
		DELETE FROM arc_dat WHERE arc_id=OLD.arc_id;
	    RETURN NULL;
     
	 END IF;
     RETURN NEW;
END;
$$;






CREATE OR REPLACE FUNCTION "SCHEMA_NAME".update_v_inp_edit_divider() RETURNS trigger
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

--		If there is an existing node closer than 0.5 meters --> error
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
			RAISE EXCEPTION 'Existing node closer than 0.1 m, node_id = (%)', node_ID;
		END IF;


		INSERT INTO  node VALUES(NEW.node_id,NEW.top_elev,NEW.ymax,'DIVIDER'::TEXT,NEW.sector_id,NEW.the_geom,NEW.node_type,  NEW."state", NEW."observ", NEW.event);
		INSERT INTO  inp_divider VALUES(NEW.node_id,NEW.divider_type,NEW.arc_id,NEW.curve_id,NEW.qmin,NEW.ht,NEW.cd,NEW.y0,NEW.ysur,NEW.apond);
		INSERT INTO node_dat VALUES(NEW.node_id, NEW.soilcat_id, NEW.pavcat_id,'','','','','','','','','', null, null,'','','','');
		RETURN NEW;
		
    ELSIF TG_OP = 'UPDATE' THEN
		UPDATE node SET node_id=NEW.node_id,top_elev=NEW.top_elev,ymax=NEW.ymax,sector_id=NEW.sector_id,the_geom=NEW.the_geom,node_type=NEW.node_type, "state"=NEW."state", "observ"=NEW."observ", event=NEW.event WHERE node_id=OLD.node_id;
		UPDATE inp_divider SET node_id=NEW.node_id, divider_type=NEW.divider_type, arc_id=NEW.arc_id, curve_id=NEW.curve_id,qmin=NEW.qmin,ht=NEW.ht,cd=NEW.cd,y0=NEW.y0, ysur=NEW.ysur, apond=NEW.apond WHERE node_id=OLD.node_id;
		UPDATE node_dat SET node_id=NEW.node_id, soilcat_id=NEW.soilcat_id, pavcat_id=NEW.pavcat_id WHERE node_id=OLD.node_id;
		RETURN NEW;
    
	ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM node WHERE node_id=OLD.node_id;
		DELETE FROM inp_divider WHERE node_id=OLD.node_id;
		DELETE FROM node_dat WHERE node_id=OLD.node_id;
	    RETURN NULL;
    
	END IF;
      RETURN NEW;
END;
$$;






CREATE OR REPLACE FUNCTION "SCHEMA_NAME".update_v_inp_edit_junction() RETURNS trigger
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
			
--			y0, ysur, apond
			IF (NEW.y0 IS NULL) THEN 
			    NEW.y0 = 0;
			END IF;
			IF (NEW.ysur IS NULL) THEN 
			    NEW.ysur = 0;
			END IF;
			IF (NEW.apond IS NULL) THEN 
			    NEW.apond = 0;
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
		
		INSERT INTO  node VALUES(NEW.node_id,NEW.top_elev,NEW.ymax,'JUNCTION'::TEXT,NEW.sector_id,NEW.the_geom,NEW.node_type,  NEW."state", NEW."observ", NEW.event);
		INSERT INTO  inp_junction VALUES(NEW.node_id,NEW.y0,NEW.ysur,NEW.apond);
		INSERT INTO node_dat VALUES(NEW.node_id, NEW.soilcat_id, NEW.pavcat_id,'','','','','','','','','', null, null,'','','','');
		RETURN NEW;
		
    ELSIF TG_OP = 'UPDATE' THEN
		UPDATE node SET node_id=NEW.node_id,top_elev=NEW.top_elev,ymax=NEW.ymax,sector_id=NEW.sector_id,the_geom=NEW.the_geom,node_type=NEW.node_type, "state"=NEW."state", "observ"=NEW."observ", event=NEW.event WHERE node_id=OLD.node_id;
		UPDATE inp_junction SET node_id=NEW.node_id,y0=NEW.y0,ysur=NEW.ysur,apond=NEW.apond WHERE node_id=OLD.node_id;
		UPDATE node_dat SET node_id=NEW.node_id, soilcat_id=NEW.soilcat_id, pavcat_id=NEW.pavcat_id WHERE node_id=OLD.node_id;
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





CREATE OR REPLACE FUNCTION "SCHEMA_NAME".update_v_inp_edit_orifice() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

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
			
--			geom2, geom3, geom4
			IF (NEW.geom2 IS NULL) THEN 
			    NEW.geom2 = 0;
			END IF;
			
			NEW.geom3 = 0;
			NEW.geom4 = 0;
			

--			Sector ID
			IF (NEW.sector_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM sector) = 0) THEN
					RAISE EXCEPTION 'There are no sectors defined in the model, define at least one.';
				END IF;
				NEW.sector_id := (SELECT sector_id FROM sector LIMIT 1);
			END IF;
			
		INSERT INTO  arc VALUES(NEW.arc_id,'','',NEW.y1,NEW.y2,NEW.arccat_id,NEW.matcat_id,'ORIFICE'::TEXT,NEW.sector_id,NEW.the_geom,NEW.arc_type, NEW.direction,  NEW."state", NEW."observ", NEW.event);
		INSERT INTO  inp_orifice VALUES(NEW.arc_id,NEW.ori_type,NEW.offset,NEW.cd,NEW.orate,NEW.flap,NEW.shape,NEW.geom1,NEW.geom2,NEW.geom3,NEW.geom4);
		INSERT INTO arc_dat VALUES(NEW.arc_id, NEW.soilcat_id, NEW.pavcat_id,'','','','','','','','','', null, null,'','','','');
		RETURN NEW;
   
	ELSIF TG_OP = 'UPDATE' THEN
		UPDATE arc SET arc_id=NEW.arc_id,node_1='',node_2='',y1=NEW.y1,y2=NEW.y2,arccat_id=NEW.arccat_id,matcat_id=NEW.matcat_id,sector_id=NEW.sector_id,the_geom=NEW.the_geom,arc_type=NEW.arc_type, direction=NEW.direction, "state"=NEW."state", "observ"=NEW."observ", event=NEW.event WHERE arc_id=OLD.arc_id;
		UPDATE inp_orifice SET arc_id=NEW.arc_id,ori_type=NEW.ori_type,"offset"=NEW."offset",cd=NEW.cd,orate=NEW.orate,flap=NEW.flap,shape=NEW.shape,geom1=NEW.geom1,geom2=NEW.geom2,geom3=NEW.geom3,geom4=NEW.geom4 WHERE arc_id=OLD.arc_id;
		UPDATE arc_dat SET arc_id=NEW.arc_id, soilcat_id=NEW.soilcat_id, pavcat_id=NEW.pavcat_id WHERE arc_id=OLD.arc_id;
		RETURN NEW;
    
	ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM arc WHERE arc_id=OLD.arc_id;
		DELETE FROM inp_orifice WHERE arc_id=OLD.arc_id;
		DELETE FROM arc_dat WHERE arc_id=OLD.arc_id;
	    RETURN NULL;
     
	END IF;
    RETURN NEW;
END;
$$;






CREATE OR REPLACE FUNCTION "SCHEMA_NAME".update_v_inp_edit_outfall() RETURNS trigger
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
		
		INSERT INTO  node VALUES(NEW.node_id,NEW.top_elev,NEW.ymax,'OUTFALL'::TEXT,NEW.sector_id,NEW.the_geom,NEW.node_type,  NEW."state", NEW."observ", NEW.event);
		INSERT INTO  inp_outfall VALUES(NEW.node_id,NEW.outfall_type,NEW.stage,NEW.curve_id,NEW.timser_id,NEW.gate);
		INSERT INTO node_dat VALUES(NEW.node_id, NEW.soilcat_id, NEW.pavcat_id,'','','','','','','','','', null, null,'','','','');
		RETURN NEW;
    
	ELSIF TG_OP = 'UPDATE' THEN
		UPDATE node SET node_id=NEW.node_id,top_elev=NEW.top_elev,ymax=NEW.ymax,sector_id=NEW.sector_id,the_geom=NEW.the_geom,node_type=NEW.node_type, "state"=NEW."state", "observ"=NEW."observ", event=NEW.event WHERE node_id=OLD.node_id;
		UPDATE inp_outfall SET node_id=NEW.node_id,outfall_type=NEW.outfall_type,stage=NEW.stage,curve_id=NEW.curve_id,timser_id=NEW.timser_id,gate=NEW.gate WHERE node_id=OLD.node_id;
		UPDATE node_dat SET node_id=NEW.node_id, soilcat_id=NEW.soilcat_id, pavcat_id=NEW.pavcat_id WHERE node_id=OLD.node_id;
		RETURN NEW;
    
	ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM node WHERE node_id=OLD.node_id;
		DELETE FROM inp_outfall WHERE node_id=OLD.node_id;
		DELETE FROM node_dat WHERE node_id=OLD.node_id;
	    RETURN NULL;
    
	END IF;
    RETURN NEW;
END;
$$;






CREATE OR REPLACE FUNCTION "SCHEMA_NAME".update_v_inp_edit_outlet() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	
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
			
		INSERT INTO  arc VALUES(NEW.arc_id,'','',NEW.y1,NEW.y2,DEFAULT,DEFAULT,'OUTLET'::TEXT,NEW.sector_id,NEW.the_geom,NEW.arc_type, NEW.direction,  NEW."state", NEW."observ", NEW.event);
		INSERT INTO  inp_outlet VALUES(NEW.arc_id,NEW.outlet_type,NEW."offset",NEW.curve_id,NEW.cd1,NEW.cd2,NEW.flap);
		INSERT INTO arc_dat VALUES(NEW.arc_id, NEW.soilcat_id, NEW.pavcat_id,'','','','','','','','','', null, null,'','','','');
		RETURN NEW;
 
	ELSIF TG_OP = 'UPDATE' THEN
		UPDATE arc SET arc_id=NEW.arc_id,node_1='',node_2='',y1=NEW.y1,y2=NEW.y2,arccat_id=DEFAULT,matcat_id=DEFAULT,sector_id=NEW.sector_id,the_geom=NEW.the_geom ,arc_type=NEW.arc_type, direction=NEW.direction, "state"=NEW."state", "observ"=NEW."observ", event=NEW.event WHERE arc_id=OLD.arc_id;
		UPDATE inp_outlet SET arc_id=NEW.arc_id,outlet_type=NEW.outlet_type,"offset"=NEW."offset",curve_id=NEW.curve_id,cd1=NEW.cd1,cd2=NEW.cd2,flap=NEW.flap WHERE arc_id=OLD.arc_id;
		UPDATE arc_dat SET arc_id=NEW.arc_id, soilcat_id=NEW.soilcat_id, pavcat_id=NEW.pavcat_id WHERE arc_id=OLD.arc_id;
		RETURN NEW;
    
	ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM arc WHERE arc_id=OLD.arc_id;
		DELETE FROM inp_outlet WHERE arc_id=OLD.arc_id;
		DELETE FROM arc_dat WHERE arc_id=OLD.arc_id;
	    RETURN NULL;
	
	END IF;
    RETURN NEW;
END;
$$;





CREATE OR REPLACE FUNCTION "SCHEMA_NAME".update_v_inp_edit_pump() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

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
			
		INSERT INTO  arc VALUES(NEW.arc_id,'','',NEW.y1,NEW.y2,NEW.arccat_id,NEW.matcat_id,'PUMP'::TEXT,NEW.sector_id,NEW.the_geom,NEW.arc_type, NEW.direction,  NEW."state", NEW."observ", NEW.event);
		INSERT INTO  inp_pump VALUES(NEW.arc_id,NEW.curve_id,NEW.status,NEW.startup,NEW.shutoff);
		INSERT INTO arc_dat VALUES(NEW.arc_id, NEW.soilcat_id, NEW.pavcat_id,'','','','','','','','','', null, null,'','','','');
		RETURN NEW;
    
	ELSIF TG_OP = 'UPDATE' THEN
		UPDATE arc SET arc_id=NEW.arc_id,node_1='',node_2='',y1=NEW.y1,y2=NEW.y2,arccat_id=NEW.arccat_id,matcat_id=NEW.matcat_id,sector_id=NEW.sector_id,the_geom=NEW.the_geom ,arc_type=NEW.arc_type, direction=NEW.direction, "state"=NEW."state", "observ"=NEW."observ", event=NEW.event WHERE arc_id=OLD.arc_id;
		UPDATE inp_pump SET arc_id=NEW.arc_id,curve_id=NEW.curve_id,status=NEW.status,startup=NEW.startup,shutoff=NEW.shutoff WHERE arc_id=OLD.arc_id;
		UPDATE arc_dat SET arc_id=NEW.arc_id, soilcat_id=NEW.soilcat_id, pavcat_id=NEW.pavcat_id WHERE arc_id=OLD.arc_id;
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






CREATE OR REPLACE FUNCTION "SCHEMA_NAME".update_v_inp_edit_storage() RETURNS trigger
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
		
		INSERT INTO  node VALUES(NEW.node_id,NEW.top_elev,NEW.ymax,'STORAGE'::TEXT,NEW.sector_id,NEW.the_geom,NEW.node_type,  NEW."state", NEW."observ", NEW.event);
		INSERT INTO  inp_storage VALUES(NEW.node_id,NEW.storage_type,NEW.curve_id,NEW.a1,NEW.a2,NEW.a0,NEW.fevap,NEW.sh,NEW.hc,NEW.imd,NEW.y0,NEW.ysur,NEW.apond);
		INSERT INTO node_dat VALUES(NEW.node_id, NEW.soilcat_id, NEW.pavcat_id,'','','','','','','','','', null, null,'','','','');
		RETURN NEW;
    
	ELSIF TG_OP = 'UPDATE' THEN
		UPDATE node SET node_id=NEW.node_id,top_elev=NEW.top_elev,ymax=NEW.ymax,sector_id=NEW.sector_id,the_geom=NEW.the_geom,node_type=NEW.node_type, "state"=NEW."state", "observ"=NEW."observ", event=NEW.event WHERE node_id=OLD.node_id;
		UPDATE inp_storage SET node_id=NEW.node_id, storage_type=NEW.storage_type,curve_id=NEW.curve_id,a1=NEW.a1,a2=NEW.a2,a0=NEW.a0,fevap=NEW.fevap,sh=NEW.sh,hc=NEW.hc,imd=NEW.imd,y0=NEW.y0, ysur=NEW.ysur, apond=NEW.apond WHERE node_id=OLD.node_id;
		UPDATE node_dat SET node_id=NEW.node_id, soilcat_id=NEW.soilcat_id, pavcat_id=NEW.pavcat_id WHERE node_id=OLD.node_id;
		RETURN NEW;
    
	ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM node WHERE node_id=OLD.node_id;
		DELETE FROM inp_storage WHERE node_id=OLD.node_id;
		DELETE FROM node_dat WHERE node_id=OLD.node_id;
	    RETURN NULL;
    
	END IF;
    RETURN NEW;
END;
$$;





CREATE OR REPLACE FUNCTION "SCHEMA_NAME".update_v_inp_edit_weir() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	
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

		INSERT INTO  arc VALUES(NEW.arc_id,'','',NEW.y1,NEW.y2,NEW.arccat_id,NEW.matcat_id,'WEIR'::TEXT,NEW.sector_id,NEW.the_geom,NEW.arc_type, NEW.direction,  NEW."state", NEW."observ", NEW.event);
		INSERT INTO  inp_weir VALUES(NEW.arc_id,NEW.weir_type,NEW."offset",NEW.cd,NEW.ec,NEW.cd2,NEW.flap,NEW.geom1,NEW.geom2,NEW.geom3,NEW.geom4, NEW.surcharge);
		INSERT INTO arc_dat VALUES(NEW.arc_id, NEW.soilcat_id, NEW.pavcat_id,'','','','','','','','','', null, null,'','','','');
		RETURN NEW;
    
	ELSIF TG_OP = 'UPDATE' THEN
		UPDATE arc SET arc_id=NEW.arc_id,node_1='',node_2='',y1=NEW.y1,y2=NEW.y2,arccat_id=NEW.arccat_id,matcat_id=NEW.matcat_id,sector_id=NEW.sector_id,the_geom=NEW.the_geom,arc_type=NEW.arc_type, direction=NEW.direction, "state"=NEW."state", "observ"=NEW."observ", event=NEW.event WHERE arc_id=OLD.arc_id;
		UPDATE inp_weir SET arc_id=NEW.arc_id,weir_type=NEW.weir_type,"offset"=NEW."offset",cd=NEW.cd,ec=NEW.ec,cd2=NEW.cd2,flap=NEW.flap,geom1=NEW.geom1,geom2=NEW.geom2,geom3=NEW.geom3,geom4=NEW.geom4, surcharge=NEW.surcharge WHERE arc_id=OLD.arc_id;
		UPDATE arc_dat SET arc_id=NEW.arc_id, soilcat_id=NEW.soilcat_id, pavcat_id=NEW.pavcat_id WHERE arc_id=OLD.arc_id;
		RETURN NEW;
    
	ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM arc WHERE arc_id=OLD.arc_id;
		DELETE FROM inp_weir WHERE arc_id=OLD.arc_id;
		DELETE FROM arc_dat WHERE arc_id=OLD.arc_id;
	    RETURN NULL;
    
	END IF;
    RETURN NEW;
END;
$$;



CREATE TRIGGER update_v_inp_edit_conduit INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_inp_edit_conduit FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".update_v_inp_edit_conduit();
CREATE TRIGGER update_v_inp_edit_divider INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_inp_edit_divider FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".update_v_inp_edit_divider();
CREATE TRIGGER update_v_inp_edit_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_inp_edit_junction FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".update_v_inp_edit_junction();
CREATE TRIGGER update_v_inp_edit_orifice INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_inp_edit_orifice FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".update_v_inp_edit_orifice();
CREATE TRIGGER update_v_inp_edit_outfall INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_inp_edit_outfall FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".update_v_inp_edit_outfall();
CREATE TRIGGER update_v_inp_edit_outlet INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_inp_edit_outlet FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".update_v_inp_edit_outlet();
CREATE TRIGGER update_v_inp_edit_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_inp_edit_pump FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".update_v_inp_edit_pump();
CREATE TRIGGER update_v_inp_edit_storage INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_inp_edit_storage FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".update_v_inp_edit_storage();
CREATE TRIGGER update_v_inp_edit_weir INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_inp_edit_weir FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".update_v_inp_edit_weir();



  
  
   
   
   