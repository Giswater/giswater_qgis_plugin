/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3072
   
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_inp_gully() 
RETURNS trigger AS 
$BODY$
DECLARE 
    v_epa_table varchar;
    v_man_table varchar;
    v_sql varchar;
    v_old_arctype varchar;
    v_new_arctype varchar;  

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    v_epa_table:= TG_ARGV[0];
    
    IF TG_OP = 'INSERT' THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"1030", "function":"3072","debug_msg":null}}$$);';
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

        -- The geom
        IF (ST_equals (NEW.the_geom, OLD.the_geom)) IS FALSE THEN
            UPDATE gully SET the_geom=NEW.the_geom WHERE gully_id = NEW.gully_id;
            
            --update top_elev from raster
            IF (SELECT upper(value) FROM config_param_system WHERE parameter='admin_raster_dem') = 'TRUE' AND (NEW.top_elev IS NULL) AND
            (SELECT upper(value)  FROM config_param_user WHERE parameter = 'edit_update_elevation_from_dem' and cur_user = current_user) = 'TRUE' THEN
                NEW.top_elev = (SELECT ST_Value(rast,1,NEW.the_geom,false) FROM v_ext_raster_dem WHERE id =
                    (SELECT id FROM v_ext_raster_dem WHERE
                    st_dwithin (ST_MakeEnvelope(
                    ST_UpperLeftX(rast), 
                    ST_UpperLeftY(rast),
                    ST_UpperLeftX(rast) + ST_ScaleX(rast)*ST_width(rast),   
                    ST_UpperLeftY(rast) + ST_ScaleY(rast)*ST_height(rast), st_srid(rast)), NEW.the_geom, 1) LIMIT 1));
            END IF;
        END IF; 

        UPDATE inp_gully 
        SET custom_length=NEW.custom_length, custom_n=NEW.custom_n, efficiency=NEW.efficiency,
        y0=NEW.y0, ysur=NEW.ysur, q0=NEW.q0, qmax=NEW.qmax, flap=NEW.flap, isepa=NEW.isepa
        WHERE gully_id=NEW.gully_id;

        UPDATE gully
        SET top_elev=NEW.top_elev, ymax=NEW.ymax, sandbox=NEW.sandbox, connec_matcat_id=NEW.connec_matcat_id,
        gully_type=NEW.gully_type, gratecat_id=NEW.gratecat_id, units=NEW.units, groove=NEW.groove, state_type=NEW.state_type,
        annotation=NEW.annotation,connec_length=NEW.connec_length, connec_arccat_id=NEW.connec_arccat_id, connec_y2=NEW.connec_y2
        WHERE gully_id=NEW.gully_id, the_geom=NEW.the_geom;
        RETURN NEW;

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"1032", "function":"3072","debug_msg":null}}$$);';
        RETURN NEW;

    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
   