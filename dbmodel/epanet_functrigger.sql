/*
This file is part of Giswater

﻿Copyright (C) 2013 by GRUPO DE INVESTIGACION EN TRANSPORTE DE SEDIMENTOS (GITS) de la UNIVERSITAT POLITECNICA DE CATALUNYA (UPC)
and TECNICSASSOCIATS, TALLER D'ARQUITECTURA I ENGINYERIA, SL.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/



-- Function: SCHEMA_NAME.update_v_inp_edit_junction()

CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_junction()
  RETURNS trigger AS
$BODY$
BEGIN
    
IF TG_OP = 'INSERT' THEN
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
BEGIN
    IF TG_OP = 'INSERT' THEN
INSERT INTO  SCHEMA_NAME.arc VALUES(NEW.arc_id,NEW.diameter,NEW.matcat_id,'PIPE'::TEXT,NEW.sector_id,NEW.the_geom);
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
BEGIN

    IF TG_OP = 'INSERT' THEN
INSERT INTO  SCHEMA_NAME.arc VALUES(NEW.arc_id,NEW.diameter,NEW.matcat_id,'PUMP'::TEXT,NEW.sector_id,NEW.the_geom);
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
BEGIN
    IF TG_OP = 'INSERT' THEN
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
BEGIN

    IF TG_OP = 'INSERT' THEN
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
BEGIN
    IF TG_OP = 'INSERT' THEN
INSERT INTO  SCHEMA_NAME.arc VALUES(NEW.arc_id,NEW.diameter,NEW.matcat_id,'VALVE'::TEXT, NEW.sector_id,NEW.the_geom);
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

  
  
