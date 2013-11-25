/*
This file is part of Giswater

﻿Copyright (C) 2013 by GRUPO DE INVESTIGACION EN TRANSPORTE DE SEDIMENTOS (GITS) de la UNIVERSITAT POLITECNICA DE CATALUNYA (UPC)
and TECNICSASSOCIATS, TALLER D'ARQUITECTURA I ENGINYERIA, SL.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/

-- Function: SCHEMA_NAME.update_v_inp_edit_conduit()

-- DROP FUNCTION SCHEMA_NAME.update_v_inp_edit_conduit();

CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_conduit()
  RETURNS trigger AS
$BODY$
BEGIN
    IF TG_OP = 'INSERT' THEN
    INSERT INTO  SCHEMA_NAME.arc VALUES(NEW.arc_id,NEW.z1,NEW.z2,NEW.arccat_id,NEW.matcat_id,'CONDUIT'::TEXT,NEW.sector_id,NEW.the_geom);
		INSERT INTO  SCHEMA_NAME.inp_conduit VALUES(NEW.arc_id,NEW.barrels,NEW.culvert,NEW.kentry,NEW.kexit,NEW.kavg,NEW.flap,NEW.q0,NEW.qmax);
		RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
     UPDATE SCHEMA_NAME.arc SET arc_id=NEW.arc_id,z1=NEW.z1,z2=NEW.z2,arccat_id=NEW.arccat_id,matcat_id=NEW.matcat_id,sector_id=NEW.sector_id,the_geom=NEW.the_geom WHERE arc_id=OLD.arc_id;
	   UPDATE SCHEMA_NAME.inp_conduit SET arc_id=NEW.arc_id,barrels=NEW.barrels,culvert=NEW.culvert,kentry=NEW.kentry,kexit=NEW.kexit,kavg=NEW.kavg,flap=NEW.flap,q0=NEW.q0,qmax=NEW.qmax WHERE arc_id=OLD.arc_id;
       RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
     DELETE FROM SCHEMA_NAME.arc WHERE arc_id=OLD.arc_id;
	   DELETE FROM SCHEMA_NAME.inp_conduit WHERE arc_id=OLD.arc_id;
	    RETURN NULL;
      END IF;
      RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.update_v_inp_edit_conduit()
  OWNER TO tecnics;
  
CREATE TRIGGER "update_v_inp_edit_conduit" INSTEAD OF INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME"."v_inp_edit_conduit"
FOR EACH ROW
EXECUTE PROCEDURE "SCHEMA_NAME"."update_v_inp_edit_conduit"();



  
-- Function: SCHEMA_NAME.update_v_inp_edit_divider()

-- DROP FUNCTION SCHEMA_NAME.update_v_inp_edit_divider();

CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_divider()
  RETURNS trigger AS
$BODY$
BEGIN
    IF TG_OP = 'INSERT' THEN
    INSERT INTO  SCHEMA_NAME.node VALUES(NEW.node_id,NEW.top_elev,NEW.ymax,'DIVIDER'::TEXT,NEW.sector_id,NEW.the_geom);
		INSERT INTO  SCHEMA_NAME.inp_divider VALUES(NEW.node_id,NEW.divider_type,NEW.arc_id,NEW.curve_id,NEW.qmin,NEW.ht,NEW.cd,NEW.y0,NEW.ysur,NEW.apond);
		RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
     UPDATE SCHEMA_NAME.node SET node_id=NEW.node_id,top_elev=NEW.top_elev,elev=NEW.elev,ymax=NEW.ymax,sector_id=NEW.sector_id,the_geom=NEW.the_geom WHERE node_id=OLD.node_id;
	   UPDATE SCHEMA_NAME.inp_divider SET node_id=NEW.node_id, divider_type=NEW.divider_type, arc_id=NEW.arc_id, curve_id=NEW.curve_id,qmin=NEW.qmin,ht=NEW.ht,cd=NEW.cd,y0=NEW.y0, ysur=NEW.ysur, apond=NEW.apond WHERE node_id=OLD.node_id;
       RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
     DELETE FROM SCHEMA_NAME.node WHERE node_id=OLD.node_id;
	   DELETE FROM SCHEMA_NAME.inp_divider WHERE node_id=OLD.node_id;
	    RETURN NULL;
      END IF;
      RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.update_v_inp_edit_divider()
  OWNER TO tecnics;

CREATE TRIGGER "update_v_inp_edit_divider" INSTEAD OF INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME"."v_inp_edit_divider"
FOR EACH ROW
EXECUTE PROCEDURE "SCHEMA_NAME"."update_v_inp_edit_divider"();



  
  -- Function: SCHEMA_NAME.update_v_inp_edit_junction()

-- DROP FUNCTION SCHEMA_NAME.update_v_inp_edit_junction();

CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_junction()
  RETURNS trigger AS
$BODY$
BEGIN
    IF TG_OP = 'INSERT' THEN
    INSERT INTO  SCHEMA_NAME.node VALUES(NEW.node_id,NEW.top_elev,NEW.ymax,'JUNCTION'::TEXT,NEW.sector_id,NEW.the_geom);
		INSERT INTO  SCHEMA_NAME.inp_junction VALUES(NEW.node_id,NEW.y0,NEW.ysur,NEW.apond);
		RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
     UPDATE SCHEMA_NAME.node SET node_id=NEW.node_id,top_elev=NEW.top_elev,elev=NEW.elev,ymax=NEW.ymax,sector_id=NEW.sector_id,the_geom=NEW.the_geom WHERE node_id=OLD.node_id;
	   UPDATE SCHEMA_NAME.inp_junction SET node_id=NEW.node_id,y0=NEW.y0,ysur=NEW.ysur,apond=NEW.apond WHERE node_id=OLD.node_id;
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
ALTER FUNCTION SCHEMA_NAME.update_v_inp_edit_junction()
  OWNER TO tecnics;


CREATE TRIGGER "update_v_inp_edit_junction" INSTEAD OF INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME"."v_inp_edit_junction"
FOR EACH ROW
EXECUTE PROCEDURE "SCHEMA_NAME"."update_v_inp_edit_junction"();



  
  -- Function: SCHEMA_NAME.update_v_inp_edit_orifice()

-- DROP FUNCTION SCHEMA_NAME.update_v_inp_edit_orifice();

CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_orifice()
  RETURNS trigger AS
$BODY$
BEGIN
    IF TG_OP = 'INSERT' THEN
    INSERT INTO  SCHEMA_NAME.arc VALUES(NEW.arc_id,NEW.z1,NEW.z2,DEFAULT,DEFAULT,'ORIFICE'::TEXT,NEW.sector_id,NEW.the_geom);
		INSERT INTO  SCHEMA_NAME.inp_orifice VALUES(NEW.arc_id,NEW.ori_type,NEW.offset,NEW.cd,NEW.orate,NEW.flap,NEW.shape,NEW.geom1,NEW.geom2,NEW.geom3,NEW.geom4);
		RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
     UPDATE SCHEMA_NAME.arc SET arc_id=NEW.arc_id,z1=NEW.z1,z2=NEW.z2,categ_type=NEW.categ_type,systm_type=NEW.systm_type,sector_id=NEW.sector_id,label=NEW.label,t=NEW.t,link=NEW.link,the_geom=NEW.the_geom WHERE arc_id=OLD.arc_id;
	   UPDATE SCHEMA_NAME.inp_orifice SET arc_id=NEW.arc_id,ori_type=NEW.ori_type,"offset"=NEW."offset",cd=NEW.cd,orate=NEW.orate,flap=NEW.flap,shape=NEW.shape,geom1=NEW.geom1,geom2=NEW.geom2,geom3=NEW.geom3,geom4=NEW.geom4 WHERE arc_id=OLD.arc_id;
       RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
     DELETE FROM SCHEMA_NAME.arc WHERE arc_id=OLD.arc_id;
	   DELETE FROM SCHEMA_NAME.inp_orifice WHERE arc_id=OLD.arc_id;
	    RETURN NULL;
      END IF;
      RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.update_v_inp_edit_orifice()
  OWNER TO tecnics;

CREATE TRIGGER "update_v_inp_edit_orifice" INSTEAD OF INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME"."v_inp_edit_orifice"
FOR EACH ROW
EXECUTE PROCEDURE "SCHEMA_NAME"."update_v_inp_edit_orifice"();


  
  -- Function: SCHEMA_NAME.update_v_inp_edit_outfall()

-- DROP FUNCTION SCHEMA_NAME.update_v_inp_edit_outfall();

CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_outfall()
  RETURNS trigger AS
$BODY$
BEGIN
    IF TG_OP = 'INSERT' THEN
    INSERT INTO  SCHEMA_NAME.node VALUES(NEW.node_id,NEW.top_elev,NEW.ymax,'OUTFALL'::TEXT,NEW.sector_id,NEW.the_geom);
		INSERT INTO  SCHEMA_NAME.inp_outfall VALUES(NEW.node_id,NEW.outfall_type,NEW.stage,NEW.curve_id,NEW.timser_id,NEW.gate);
		RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
     UPDATE SCHEMA_NAME.node SET node_id=NEW.node_id,top_elev=NEW.top_elev,elev=NEW.elev,ymax=NEW.ymax,sector_id=NEW.sector_id,the_geom=NEW.the_geom WHERE node_id=OLD.node_id;
	   UPDATE SCHEMA_NAME.inp_outfall SET node_id=NEW.node_id,outfall_type=NEW.outfall_type,stage=NEW.stage,curve_id=NEW.curve_id,timser_id=NEW.timser_id,gate=NEW.gate WHERE node_id=OLD.node_id;
       RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
     DELETE FROM SCHEMA_NAME.node WHERE node_id=OLD.node_id;
	   DELETE FROM SCHEMA_NAME.inp_outfall WHERE node_id=OLD.node_id;
	    RETURN NULL;
      END IF;
      RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.update_v_inp_edit_outfall()
  OWNER TO tecnics;

CREATE TRIGGER "update_v_inp_edit_outfall" INSTEAD OF INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME"."v_inp_edit_outfall"
FOR EACH ROW
EXECUTE PROCEDURE "SCHEMA_NAME"."update_v_inp_edit_outfall"();




  
  -- Function: SCHEMA_NAME.update_v_inp_edit_outlet()

-- DROP FUNCTION SCHEMA_NAME.update_v_inp_edit_outlet();

CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_outlet()
  RETURNS trigger AS
$BODY$
BEGIN
    IF TG_OP = 'INSERT' THEN
    INSERT INTO  SCHEMA_NAME.arc VALUES(NEW.arc_id,NEW.z1,NEW.z2,DEFAULT,DEFAULT,'OUTLET'::TEXT,NEW.sector_id,NEW.the_geom);
		INSERT INTO  SCHEMA_NAME.inp_outlet VALUES(NEW.arc_id,NEW.outlet_type,NEW."offset",NEW.curve_id,NEW.cd1,NEW.cd2,NEW.flap);
		RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
     UPDATE SCHEMA_NAME.arc SET arc_id=NEW.arc_id,z1=NEW.z1,z2=NEW.z2,sector_id=NEW.sector_id,the_geom=NEW.the_geom WHERE arc_id=OLD.arc_id;
	   UPDATE SCHEMA_NAME.inp_outlet SET arc_id=NEW.arc_id,outlet_type=NEW.outlet_type,"offset"=NEW."offset",curve_id=NEW.curve_id,cd1=NEW.cd1,cd2=NEW.cd2,flap=NEW.flap WHERE arc_id=OLD.arc_id;
       RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
     DELETE FROM SCHEMA_NAME.arc WHERE arc_id=OLD.arc_id;
	   DELETE FROM SCHEMA_NAME.inp_outlet WHERE arc_id=OLD.arc_id;
	    RETURN NULL;
      END IF;
      RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.update_v_inp_edit_outlet()
  OWNER TO tecnics;

CREATE TRIGGER "update_v_inp_edit_outlet" INSTEAD OF INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME"."v_inp_edit_outlet"
FOR EACH ROW
EXECUTE PROCEDURE "SCHEMA_NAME"."update_v_inp_edit_outlet"();




  
  -- Function: SCHEMA_NAME.update_v_inp_edit_pump()

-- DROP FUNCTION SCHEMA_NAME.update_v_inp_edit_pump();

CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_pump()
  RETURNS trigger AS
$BODY$
BEGIN
    IF TG_OP = 'INSERT' THEN
    INSERT INTO  SCHEMA_NAME.arc VALUES(NEW.arc_id,NEW.z1,NEW.z2,DEFAULT,DEFAULT,'PUMP'::TEXT,NEW.sector_id,NEW.the_geom);
		INSERT INTO  SCHEMA_NAME.inp_pump VALUES(NEW.arc_id,NEW.curve_id,NEW.status,NEW.startup,NEW.shutoff);
		RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
     UPDATE SCHEMA_NAME.arc SET arc_id=NEW.arc_id,z1=NEW.z1,z2=NEW.z2,sector_id=NEW.sector_id,the_geom=NEW.the_geom WHERE arc_id=OLD.arc_id;
	   UPDATE SCHEMA_NAME.inp_pump SET arc_id=NEW.arc_id,curve_id=NEW.curve_id,status=NEW.status,startup=NEW.startup,shutoff=NEW.shutoff WHERE arc_id=OLD.arc_id;
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
ALTER FUNCTION SCHEMA_NAME.update_v_inp_edit_pump()
  OWNER TO tecnics;


CREATE TRIGGER "update_v_inp_edit_pump" INSTEAD OF INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME"."v_inp_edit_pump"
FOR EACH ROW
EXECUTE PROCEDURE "SCHEMA_NAME"."update_v_inp_edit_pump"();
  


  
  -- Function: SCHEMA_NAME.update_v_inp_edit_storage()

-- DROP FUNCTION SCHEMA_NAME.update_v_inp_edit_storage();

CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_storage()
  RETURNS trigger AS
$BODY$
BEGIN
    IF TG_OP = 'INSERT' THEN
    INSERT INTO  SCHEMA_NAME.node VALUES(NEW.node_id,NEW.top_elev,NEW.ymax,'STORAGE'::TEXT,NEW.sector_id,NEW.the_geom);
		INSERT INTO  SCHEMA_NAME.inp_storage VALUES(NEW.node_id,NEW.storage_type,NEW.curve_id,NEW.a1,NEW.a2,NEW.a0,NEW.fevap,NEW.sh,NEW.hc,NEW.imd,NEW.y0,NEW.ysur,NEW.apond);
		RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
     UPDATE SCHEMA_NAME.node SET node_id=NEW.node_id,top_elev=NEW.top_elev,elev=NEW.elev,ymax=NEW.ymax,sector_id=NEW.sector_id,the_geom=NEW.the_geom WHERE node_id=OLD.node_id;
	   UPDATE SCHEMA_NAME.inp_storage SET node_id=NEW.node_id, storage_type=NEW.storage_type,curve_id=NEW.curve_id,a1=NEW.a1,a2=NEW.a2,a0=NEW.a0,fevap=NEW.fevap,sh=NEW.sh,hc=NEW.hc,imd=NEW.imd,y0=NEW.y0, ysur=NEW.ysur, apond=NEW.apond WHERE node_id=OLD.node_id;
       RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
     DELETE FROM SCHEMA_NAME.node WHERE node_id=OLD.node_id;
	   DELETE FROM SCHEMA_NAME.inp_storage WHERE node_id=OLD.node_id;
	    RETURN NULL;
      END IF;
      RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.update_v_inp_edit_storage()
  OWNER TO tecnics;

CREATE TRIGGER "update_v_inp_edit_storage" INSTEAD OF INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME"."v_inp_edit_storage"
FOR EACH ROW
EXECUTE PROCEDURE "SCHEMA_NAME"."update_v_inp_edit_storage"();


  
  -- Function: SCHEMA_NAME.update_v_inp_edit_weir()

-- DROP FUNCTION SCHEMA_NAME.update_v_inp_edit_weir();

CREATE OR REPLACE FUNCTION SCHEMA_NAME.update_v_inp_edit_weir()
  RETURNS trigger AS
$BODY$
BEGIN
    IF TG_OP = 'INSERT' THEN
    INSERT INTO  SCHEMA_NAME.arc VALUES(NEW.arc_id,NEW.z1,NEW.z2,DEFAULT,DEFAULT,'WEIR'::TEXT,NEW.sector_id,NEW.the_geom);
		INSERT INTO  SCHEMA_NAME.inp_weir VALUES(NEW.arc_id,NEW.weir_type,NEW."offset",NEW.cd,NEW.ec,NEW.cd2,NEW.flap,NEW.geom1,NEW.geom2,NEW.geom3,NEW.geom4);
		RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
     UPDATE SCHEMA_NAME.arc SET arc_id=NEW.arc_id,z1=NEW.z1,z2=NEW.z2,sector_id=NEW.sector_id,the_geom=NEW.the_geom WHERE arc_id=OLD.arc_id;
	   UPDATE SCHEMA_NAME.inp_weir SET arc_id=NEW.arc_id,weir_type=NEW.weir_type,"offset"=NEW."offset",cd=NEW.cd,ec=NEW.ec,cd2=NEW.cd2,flap=NEW.flap,geom1=NEW.geom1,geom2=NEW.geom2,geom3=NEW.geom3,geom4=NEW.geom4 WHERE arc_id=OLD.arc_id;
       RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
     DELETE FROM SCHEMA_NAME.arc WHERE arc_id=OLD.arc_id;
	   DELETE FROM SCHEMA_NAME.inp_weir WHERE arc_id=OLD.arc_id;
	    RETURN NULL;
      END IF;
      RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.update_v_inp_edit_weir()
  OWNER TO tecnics;

CREATE TRIGGER "update_v_inp_edit_weir" INSTEAD OF INSERT OR UPDATE OR DELETE ON "SCHEMA_NAME"."v_inp_edit_weir"
FOR EACH ROW
EXECUTE PROCEDURE "SCHEMA_NAME"."update_v_inp_edit_weir"();





