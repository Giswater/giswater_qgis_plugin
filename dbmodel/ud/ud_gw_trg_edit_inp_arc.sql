/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

   
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_inp_arc() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    arc_table varchar;
    man_table varchar;
    epa_type varchar;
    v_sql varchar;
    old_arctype varchar;
    new_arctype varchar;   

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    arc_table:= TG_ARGV[0];
    epa_type:= TG_ARGV[1];
    
    IF TG_OP = 'INSERT' THEN
        RETURN audit_function(155,790); 
 

    ELSIF TG_OP = 'UPDATE' THEN


        UPDATE arc 
        SET arc_id=NEW.arc_id, y1=NEW.y1, y2=NEW.y2, arccat_id=NEW.arccat_id, sector_id=NEW.sector_id, "state"=NEW."state", annotation= NEW.annotation, 
            "observ"=NEW."observ", "comment"=NEW."comment", custom_length=NEW.custom_length, rotation=NEW.rotation, link=NEW.link, 
             est_y1=NEW.est_y1, est_y2=NEW.est_y2, verified=NEW.verified, the_geom=NEW.the_geom 
        WHERE arc_id = OLD.arc_id;

        IF (epa_type = 'CONDUIT') THEN 
            UPDATE inp_conduit SET arc_id=NEW.arc_id,barrels=NEW.barrels,culvert=NEW.culvert,kentry=NEW.kentry,kexit=NEW.kexit,kavg=NEW.kavg,flap=NEW.flap,q0=NEW.q0,qmax=NEW.qmax, seepage=NEW.seepage WHERE arc_id=OLD.arc_id;
        ELSIF (epa_type = 'PUMP') THEN 
            UPDATE inp_pump SET arc_id=NEW.arc_id,curve_id=NEW.curve_id,status=NEW.status,startup=NEW.startup,shutoff=NEW.shutoff WHERE arc_id=OLD.arc_id;
        ELSIF (epa_type = 'ORIFICE') THEN 
            UPDATE inp_orifice SET arc_id=NEW.arc_id,ori_type=NEW.ori_type,"offset"=NEW."offset",cd=NEW.cd,orate=NEW.orate,flap=NEW.flap,shape=NEW.shape,geom1=NEW.geom1,geom2=NEW.geom2,geom3=NEW.geom3,geom4=NEW.geom4 WHERE arc_id=OLD.arc_id;
        ELSIF (epa_type = 'WEIR') THEN 
            UPDATE inp_weir SET arc_id=NEW.arc_id,weir_type=NEW.weir_type,"offset"=NEW."offset",cd=NEW.cd,ec=NEW.ec,cd2=NEW.cd2,flap=NEW.flap,geom1=NEW.geom1,geom2=NEW.geom2,geom3=NEW.geom3,geom4=NEW.geom4,surcharge=NEW.surcharge WHERE arc_id=OLD.arc_id;
        ELSIF (epa_type = 'OUTLET') THEN 
            UPDATE inp_outlet SET arc_id=NEW.arc_id, outlet_type=NEW.outlet_type, "offset"=NEW."offset", curve_id=NEW.curve_id, cd1=NEW.cd1,cd2=NEW.cd2,flap=NEW.flap WHERE arc_id=OLD.arc_id;
        END IF;

        PERFORM audit_function (2,790);
        RETURN NEW;


    ELSIF TG_OP = 'DELETE' THEN
        RETURN audit_function(157,790); 
    
    END IF;
    
END;
$$;


DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_conduit ON "SCHEMA_NAME".v_edit_inp_conduit;
CREATE TRIGGER gw_trg_edit_inp_arc_conduit INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_conduit
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_conduit', 'CONDUIT');   

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_pump ON "SCHEMA_NAME".v_edit_inp_pump;
CREATE TRIGGER gw_trg_edit_inp_arc_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_pump
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_pump', 'PUMP');   

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_orifice ON "SCHEMA_NAME".v_edit_inp_orifice;
CREATE TRIGGER gw_trg_edit_inp_arc_orifice INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_orifice
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_orifice', 'ORIFICE');   

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_outlet ON "SCHEMA_NAME".v_edit_inp_outlet;
CREATE TRIGGER gw_trg_edit_inp_arc_outlet INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_outlet
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_outlet', 'OUTLET');   

DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_weir ON "SCHEMA_NAME".v_edit_inp_weir;
CREATE TRIGGER gw_trg_edit_inp_arc_weir INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_weir
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_arc('inp_weir', 'WEIR');   

   