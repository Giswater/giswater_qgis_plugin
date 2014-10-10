/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-----------------------------
-- TOPOLOGY ARC-NODE
-----------------------------

-- Function: SCHEMA_NAME.update_t_inp_arc_insert()

CREATE FUNCTION "SCHEMA_NAME".update_t_inp_arc_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
	nodeRecord1 Record; 
	nodeRecord2 Record; 

 BEGIN 

	 SELECT * INTO nodeRecord1 FROM "SCHEMA_NAME".node node WHERE node.the_geom && ST_Expand(ST_startpoint(NEW.the_geom), 0.5)
		ORDER BY ST_Distance(node.the_geom, ST_startpoint(NEW.the_geom)) LIMIT 1;

	 SELECT * INTO nodeRecord2 FROM "SCHEMA_NAME".node node WHERE node.the_geom && ST_Expand(ST_endpoint(NEW.the_geom), 0.5)
		ORDER BY ST_Distance(node.the_geom, ST_endpoint(NEW.the_geom)) LIMIT 1;


--	Control de lineas de longitud 0
	IF (nodeRecord1.node_id IS NOT NULL) AND (nodeRecord2.node_id IS NOT NULL) THEN

			NEW.node_1 := nodeRecord1.node_id; 
			NEW.node_2 := nodeRecord2.node_id;

		RETURN NEW;

	ELSE
		RETURN NULL;
	END IF;

END; 
$$;

CREATE TRIGGER update_t_inp_insert_arc BEFORE INSERT OR UPDATE ON "SCHEMA_NAME"."arc"
FOR EACH ROW 
EXECUTE PROCEDURE "SCHEMA_NAME"."update_t_inp_arc_insert"();


-- Function: SCHEMA_NAME.update_t_inp_node_update()

CREATE FUNCTION "SCHEMA_NAME".update_t_inp_node_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$DECLARE 
	querystring Varchar; 
	arcrec Record; 
	nodeRecord1 Record; 
	nodeRecord2 Record; 

BEGIN 

--	Select arcs with start-end on the updated node
	querystring := 'SELECT * FROM "SCHEMA_NAME"."arc" WHERE arc.node_1 = ' || quote_literal(NEW.node_id) || ' OR arc.node_2 = ' || quote_literal(NEW.node_id); 

	FOR arcrec IN EXECUTE querystring
	LOOP


--		Initial and final node of the arc
		SELECT * INTO nodeRecord1 FROM "SCHEMA_NAME"."node" node WHERE node.node_id = arcrec.node_1;
		SELECT * INTO nodeRecord2 FROM "SCHEMA_NAME"."node" node WHERE node.node_id = arcrec.node_2;


--		Control de lineas de longitud 0
		IF (nodeRecord1.node_id IS NOT NULL) AND (nodeRecord2.node_id IS NOT NULL) THEN


--			Update arc node coordinates, node_id and direction
			IF (nodeRecord1.node_id = NEW.node_id) THEN


--				Coordinates
				EXECUTE 'UPDATE "SCHEMA_NAME".arc SET the_geom = ST_SetPoint($1, 0, $2) WHERE arc_id = ' || quote_literal(arcrec."arc_id") USING arcrec.the_geom, NEW.the_geom; 

			ELSE

--				Coordinates
				EXECUTE 'UPDATE "SCHEMA_NAME".arc SET the_geom = ST_SetPoint($1, ST_NumPoints($1) - 1, $2) WHERE arc_id = ' || quote_literal(arcrec."arc_id") USING arcrec.the_geom, NEW.the_geom; 

			END IF;

		END IF;

	END LOOP; 

	RETURN NEW;


END; $_$;


CREATE TRIGGER update_t_inp_update_node AFTER UPDATE ON "SCHEMA_NAME"."node"
FOR EACH ROW 
EXECUTE PROCEDURE "SCHEMA_NAME"."update_t_inp_node_update"();



-- Function: "SCHEMA_NAME".update_t_inp_node_delete()
-- Function created modifying "tgg_functionborralinea" developed by Jose C. Martinez Llario in "PostGIS 2 Analisis Espacial Avanzado" 

CREATE FUNCTION "SCHEMA_NAME".update_t_inp_node_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	
DECLARE 
	querystring Varchar; 
	arcrec Record; 
	nodosactualizados Integer; 

BEGIN 
	nodosactualizados := 0; 
 
	querystring := 'SELECT arc.arc_id AS arc_id FROM "SCHEMA_NAME".arc WHERE arc.node_1 = ' || quote_literal(OLD.node_id) || ' OR arc.node_2 = ' || quote_literal(OLD.node_id); 

	FOR arcrec IN EXECUTE querystring
	LOOP
		EXECUTE 'DELETE FROM "SCHEMA_NAME".arc WHERE arc_id = ' || quote_literal(arcrec."arc_id"); 

	END LOOP; 

	RETURN OLD; 
END; 
$$;

CREATE TRIGGER update_t_inp_delete_node BEFORE DELETE ON "SCHEMA_NAME"."node"
FOR EACH ROW 
EXECUTE PROCEDURE "SCHEMA_NAME"."update_t_inp_node_delete"();


------------------------------------
--  EDITING VIEWS
------------------------------------


-- Function: SCHEMA_NAME.update_v_inp_edit_junction()

CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_junction()
  RETURNS trigger AS
$BODY$

DECLARE 
	numNodes numeric;
	sectorRecord record;
	auxNode_ID varchar;
	
BEGIN
    
--	Control insertions ID	
	IF TG_OP = 'INSERT' THEN

--		Existing nodes
		numNodes := (SELECT COUNT(*) FROM "SCHEMA_NAME".node nodeOld WHERE nodeOld.the_geom && ST_Expand(NEW.the_geom, 0.1));

--		If there is an existing node closer than 0.5 meters --> error
		IF (numNodes = 0) THEN

--			Node ID
			IF (NEW.node_id IS NULL) THEN
				NEW.node_id := (SELECT nextval('"SCHEMA_NAME".inp_node_id_seq'));
			END IF;

--			Sector ID
			IF (NEW.sector_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM "SCHEMA_NAME".sector) = 0) THEN
					RAISE EXCEPTION 'There are no sectors defined in the model, define at least one.';
				END IF;
				NEW.sector_id := (SELECT sector_id FROM "SCHEMA_NAME".sector LIMIT 1);
			END IF;

--		Trigger error				
		ELSE
			SELECT node_id INTO auxNode_ID FROM "SCHEMA_NAME".node nodeOld WHERE nodeOld.the_geom && ST_Expand(NEW.the_geom, 0.1) LIMIT 1;
			RAISE EXCEPTION 'Existing node closer than 0.1 m, node_id = (%)', node_ID;
		END IF;

		INSERT INTO  SCHEMA_NAME.node VALUES(NEW.node_id,NEW.elevation,'JUNCTION'::text,NEW.sector_id,NEW.the_geom);
		INSERT INTO  SCHEMA_NAME.inp_junction VALUES(NEW.node_id,NEW.demand,NEW.pattern_id);
		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN
		UPDATE SCHEMA_NAME.node SET node_id=NEW.node_id, elevation=NEW.elevation, sector_id=NEW.sector_id, the_geom=NEW.the_geom WHERE node_id=OLD.node_id;
		UPDATE SCHEMA_NAME.inp_junction SET node_id=NEW.node_id, demand=NEW.demand, pattern_id=NEW.pattern_id WHERE node_id=OLD.node_id;
       RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM SCHEMA_NAME.node WHERE node_id=OLD.node_id;
		DELETE FROM SCHEMA_NAME.inp_junction WHERE node_id=OLD.node_id;
	    RETURN NULL;
    
	END IF;
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

CREATE TRIGGER "update_v_inp_edit_juction" INSTEAD OF INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME"."v_inp_edit_junction"
FOR EACH ROW
EXECUTE PROCEDURE "SCHEMA_NAME"."update_v_inp_edit_junction"();

  
  
-- Function: SCHEMA_NAME.update_v_inp_edit_pipe()

CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_pipe()
  RETURNS trigger AS
$BODY$

DECLARE 
	numNodes numeric;
	sectorRecord record;
	auxNode_ID varchar;

BEGIN
	IF TG_OP = 'INSERT' THEN
--			Arc ID
			IF (NEW.arc_id IS NULL) THEN
				NEW.arc_id := (SELECT nextval('"SCHEMA_NAME".inp_arc_id_seq'));
			END IF;

--			Sector ID
			IF (NEW.sector_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM "SCHEMA_NAME".sector) = 0) THEN
					RAISE EXCEPTION 'There are no sectors defined in the model, define at least one.';
				END IF;
				NEW.sector_id := (SELECT sector_id FROM "SCHEMA_NAME".sector LIMIT 1);
			END IF;

--			Material catalog ID
			IF (NEW.matcat_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM "SCHEMA_NAME".cat_mat) = 0) THEN
					RAISE EXCEPTION 'There are no materials catalog defined in the model, define at least one.';
				END IF;			
				NEW.matcat_id := (SELECT id FROM "SCHEMA_NAME".cat_mat LIMIT 1);
			END IF;
	
		INSERT INTO  SCHEMA_NAME.arc VALUES(NEW.arc_id,'','',NEW.diameter,NEW.matcat_id,'PIPE'::TEXT,NEW.sector_id,NEW.the_geom);
		INSERT INTO  SCHEMA_NAME.inp_pipe VALUES(NEW.arc_id,NEW.minorloss,NEW.status);
		RETURN NEW;
    
	ELSIF TG_OP = 'UPDATE' THEN
		UPDATE SCHEMA_NAME.arc SET arc_id=NEW.arc_id, diameter=NEW.diameter, matcat_id=NEW.matcat_id, enet_type='PIPE'::TEXT,sector_id=NEW.sector_id,the_geom=NEW.the_geom WHERE arc_id=OLD.arc_id;
		UPDATE SCHEMA_NAME.inp_pipe SET arc_id=NEW.arc_id, minorloss=NEW.minorloss, status=NEW.status WHERE arc_id=OLD.arc_id;
		RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM SCHEMA_NAME.arc WHERE arc_id=OLD.arc_id;
		DELETE FROM SCHEMA_NAME.inp_pipe WHERE arc_id=OLD.arc_id;
	    RETURN NULL;
    
	END IF;
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

CREATE TRIGGER "update_v_inp_edit_pipe" INSTEAD OF INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME"."v_inp_edit_pipe"
FOR EACH ROW
EXECUTE PROCEDURE "SCHEMA_NAME"."update_v_inp_edit_pipe"();


  
  
-- Function: SCHEMA_NAME.update_v_inp_edit_pump()

CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_pump()
  RETURNS trigger AS
$BODY$

DECLARE 
	numNodes numeric;
	sectorRecord record;
	auxNode_ID varchar;
	
BEGIN

	IF TG_OP = 'INSERT' THEN
--			Arc ID
			IF (NEW.arc_id IS NULL) THEN
				NEW.arc_id := (SELECT nextval('"SCHEMA_NAME".inp_arc_id_seq'));
			END IF;

--			Sector ID
			IF (NEW.sector_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM "SCHEMA_NAME".sector) = 0) THEN
					RAISE EXCEPTION 'There are no sectors defined in the model, define at least one.';
				END IF;
				NEW.sector_id := (SELECT sector_id FROM "SCHEMA_NAME".sector LIMIT 1);
			END IF;
			
--			Material catalog ID
			IF (NEW.matcat_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM "SCHEMA_NAME".cat_mat) = 0) THEN
					RAISE EXCEPTION 'There are no materials catalog defined in the model, define at least one.';
				END IF;			
				NEW.matcat_id := (SELECT id FROM "SCHEMA_NAME".cat_mat LIMIT 1);
			END IF;
			
		INSERT INTO  SCHEMA_NAME.arc VALUES(NEW.arc_id,'','',NEW.diameter,NEW.matcat_id,'PUMP'::TEXT,NEW.sector_id,NEW.the_geom);
		INSERT INTO  SCHEMA_NAME.inp_pump VALUES(NEW.arc_id,NEW.power,NEW.curve_id,NEW.speed,NEW.pattern);
		RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
		UPDATE SCHEMA_NAME.arc SET arc_id=NEW.arc_id, diameter=NEW.diameter, matcat_id=NEW.matcat_id, enet_type='PUMP'::TEXT,sector_id=NEW.sector_id,the_geom=NEW.the_geom WHERE arc_id=OLD.arc_id;
		UPDATE SCHEMA_NAME.inp_pump SET arc_id=NEW.arc_id, power=NEW.power,curve_id=NEW.curve_id,speed=NEW.speed,pattern=NEW.pattern WHERE arc_id=OLD.arc_id;
		RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM SCHEMA_NAME.arc WHERE arc_id=OLD.arc_id;
		DELETE FROM SCHEMA_NAME.inp_pump WHERE arc_id=OLD.arc_id;
	    RETURN NULL;
		
    END IF;
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

CREATE TRIGGER "update_v_inp_edit_pump" INSTEAD OF INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME"."v_inp_edit_pump"
FOR EACH ROW
EXECUTE PROCEDURE "SCHEMA_NAME"."update_v_inp_edit_pump"();

  
  
  
-- Function: SCHEMA_NAME.update_v_inp_edit_reservoir()

CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_reservoir()
  RETURNS trigger AS
$BODY$

DECLARE 
	numNodes numeric;
	sectorRecord record;
	auxNode_ID varchar;
	
BEGIN
--	Control insertions ID	
	IF TG_OP = 'INSERT' THEN

--		Existing nodes
		numNodes := (SELECT COUNT(*) FROM "SCHEMA_NAME".node nodeOld WHERE nodeOld.the_geom && ST_Expand(NEW.the_geom, 0.1));

--		If there is an existing node closer than 0.5 meters --> error
		IF (numNodes = 0) THEN

--			Node ID
			IF (NEW.node_id IS NULL) THEN
				NEW.node_id := (SELECT nextval('"SCHEMA_NAME".inp_node_id_seq'));
			END IF;

--			Sector ID
			IF (NEW.sector_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM "SCHEMA_NAME".sector) = 0) THEN
					RAISE EXCEPTION 'There are no sectors defined in the model, define at least one.';
				END IF;
				NEW.sector_id := (SELECT sector_id FROM "SCHEMA_NAME".sector LIMIT 1);
			END IF;

--		Trigger error				
		ELSE
			SELECT node_id INTO auxNode_ID FROM "SCHEMA_NAME".node nodeOld WHERE nodeOld.the_geom && ST_Expand(NEW.the_geom, 0.1) LIMIT 1;
			RAISE EXCEPTION 'Existing node closer than 0.1 m, node_id = (%)', node_ID;
		END IF;
		
		INSERT INTO  SCHEMA_NAME.node VALUES(NEW.node_id,NEW.elevation,'RESERVOIR'::text,NEW.sector_id,NEW.the_geom);
		INSERT INTO  SCHEMA_NAME.inp_reservoir VALUES(NEW.node_id,NEW.head,NEW.pattern_id);
		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN
		UPDATE SCHEMA_NAME.node SET node_id=NEW.node_id,elevation=NEW.elevation,sector_id=NEW.sector_id,the_geom=NEW.the_geom WHERE node_id=OLD.node_id;
		UPDATE SCHEMA_NAME.inp_reservoir SET node_id=NEW.node_id, head=NEW.head, pattern_id=NEW.pattern_id WHERE node_id=OLD.node_id;
		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM SCHEMA_NAME.node WHERE node_id=OLD.node_id;
		DELETE FROM SCHEMA_NAME.inp_reservoir WHERE node_id=OLD.node_id;
	    RETURN NULL;
     
	END IF;
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

CREATE TRIGGER "update_v_inp_edit_reservoir" INSTEAD OF INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME"."v_inp_edit_reservoir"
FOR EACH ROW
EXECUTE PROCEDURE "SCHEMA_NAME"."update_v_inp_edit_reservoir"();


  
  
-- Function: SCHEMA_NAME.update_v_inp_edit_tank()

CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_tank()
  RETURNS trigger AS
$BODY$

DECLARE 
	numNodes numeric;
	sectorRecord record;
	auxNode_ID varchar;
	
BEGIN

--	Control insertions ID	
	IF TG_OP = 'INSERT' THEN

--		Existing nodes
		numNodes := (SELECT COUNT(*) FROM "SCHEMA_NAME".node nodeOld WHERE nodeOld.the_geom && ST_Expand(NEW.the_geom, 0.1));

--		If there is an existing node closer than 0.5 meters --> error
		IF (numNodes = 0) THEN

--			Node ID
			IF (NEW.node_id IS NULL) THEN
				NEW.node_id := (SELECT nextval('"SCHEMA_NAME".inp_node_id_seq'));
			END IF;

--			Sector ID
			IF (NEW.sector_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM "SCHEMA_NAME".sector) = 0) THEN
					RAISE EXCEPTION 'There are no sectors defined in the model, define at least one.';
				END IF;
				NEW.sector_id := (SELECT sector_id FROM "SCHEMA_NAME".sector LIMIT 1);
			END IF;

--		Trigger error				
		ELSE
			SELECT node_id INTO auxNode_ID FROM "SCHEMA_NAME".node nodeOld WHERE nodeOld.the_geom && ST_Expand(NEW.the_geom, 0.1) LIMIT 1;
			RAISE EXCEPTION 'Existing node closer than 0.1 m, node_id = (%)', node_ID;
		END IF;

		INSERT INTO  SCHEMA_NAME.node VALUES(NEW.node_id,NEW.elevation,'TANK'::text,NEW.sector_id,NEW.the_geom);
		INSERT INTO  SCHEMA_NAME.inp_tank VALUES(NEW.node_id,NEW.initlevel,NEW.minlevel,NEW.maxlevel,NEW.diameter,NEW.minvol,NEW.curve_id);
		RETURN NEW;
   
	ELSIF TG_OP = 'UPDATE' THEN
		UPDATE SCHEMA_NAME.node SET node_id=NEW.node_id, elevation=NEW.elevation, sector_id=NEW.sector_id, the_geom=NEW.the_geom WHERE node_id=OLD.node_id;
		UPDATE SCHEMA_NAME.inp_tank SET node_id=NEW.node_id, initlevel=NEW.initlevel, minlevel=NEW.minlevel, maxlevel=NEW.maxlevel, diameter=NEW.diameter, minvol=NEW.minvol, curve_id=NEW.curve_id WHERE node_id=OLD.node_id;
		RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM SCHEMA_NAME.node WHERE node_id=OLD.node_id;
		DELETE FROM SCHEMA_NAME.inp_tank WHERE node_id=OLD.node_id;
	    RETURN NULL;
		
	END IF;
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


CREATE TRIGGER "update_v_inp_edit_tank" INSTEAD OF INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME"."v_inp_edit_tank"
FOR EACH ROW
EXECUTE PROCEDURE "SCHEMA_NAME"."update_v_inp_edit_tank"();




-- Function: SCHEMA_NAME.update_v_inp_edit_valve()

CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_valve()
  RETURNS trigger AS
$BODY$

DECLARE 
	numNodes numeric;
	sectorRecord record;
	auxNode_ID varchar;
	
BEGIN
    IF TG_OP = 'INSERT' THEN
--			Arc ID
			IF (NEW.arc_id IS NULL) THEN
				NEW.arc_id := (SELECT nextval('"SCHEMA_NAME".inp_arc_id_seq'));
			END IF;

--			Sector ID
			IF (NEW.sector_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM "SCHEMA_NAME".sector) = 0) THEN
					RAISE EXCEPTION 'There are no sectors defined in the model, define at least one.';
				END IF;
				NEW.sector_id := (SELECT sector_id FROM "SCHEMA_NAME".sector LIMIT 1);
			END IF;

--			Material catalog ID
			IF (NEW.matcat_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM "SCHEMA_NAME".cat_mat) = 0) THEN
					RAISE EXCEPTION 'There are no materials catalog defined in the model, define at least one.';
				END IF;			
				NEW.matcat_id := (SELECT id FROM "SCHEMA_NAME".cat_mat LIMIT 1);
			END IF;
			
		INSERT INTO  SCHEMA_NAME.arc VALUES(NEW.arc_id,'','',NEW.diameter,NEW.matcat_id,'VALVE'::TEXT, NEW.sector_id,NEW.the_geom);
		INSERT INTO  SCHEMA_NAME.inp_valve VALUES(NEW.arc_id,NEW.valv_type,NEW.pressure,NEW.flow,NEW.coef_loss,NEW.curve_id,NEW.minorloss,NEW.status);
		RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
		UPDATE SCHEMA_NAME.arc SET arc_id=NEW.arc_id,diameter=NEW.diameter,matcat_id=NEW.matcat_id,enet_type='VALVE'::TEXT,sector_id=NEW.sector_id,the_geom=NEW.the_geom WHERE arc_id=OLD.arc_id;
		UPDATE SCHEMA_NAME.inp_valve SET arc_id=NEW.arc_id,valv_type=NEW.valv_type, pressure=NEW.pressure, flow=NEW.flow, coef_loss=NEW.coef_loss,curve_id=NEW.curve_id, minorloss=NEW.minorloss, status=NEW.status WHERE arc_id=OLD.arc_id;
		RETURN NEW;
    
	ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM SCHEMA_NAME.arc WHERE arc_id=OLD.arc_id;
		DELETE FROM SCHEMA_NAME.inp_valve WHERE arc_id=OLD.arc_id;
	    RETURN NULL;
    
	END IF;
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


CREATE TRIGGER "update_v_inp_edit_valve" INSTEAD OF INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME"."v_inp_edit_valve"
FOR EACH ROW
EXECUTE PROCEDURE "SCHEMA_NAME"."update_v_inp_edit_valve"();

  
  
