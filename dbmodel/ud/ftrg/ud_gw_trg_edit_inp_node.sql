/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1210

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_inp_node() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    v_node_table varchar;
    v_man_table varchar;
    v_epa_type varchar;
    v_sql varchar;
    v_old_nodetype varchar;
    v_new_nodetype varchar;    

	
	
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    v_node_table:= TG_ARGV[0];
    v_epa_type:= TG_ARGV[1];
    
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN
        RETURN gw_fct_audit_function(1030,1210, NULL);

    ELSIF TG_OP = 'UPDATE' THEN
	
	-- State
	IF (NEW.state != OLD.state) THEN
		UPDATE node SET state=NEW.state WHERE node_id = OLD.node_id;
	END IF;
			
	-- The geom
	IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom)  THEN
		UPDATE node SET the_geom=NEW.the_geom WHERE node_id = OLD.node_id;
	END IF;

	--update elevation from raster
	IF (SELECT upper(value) FROM config_param_system WHERE parameter='sys_raster_dem') = 'TRUE'  AND
		(SELECT upper(value)  FROM config_param_user WHERE parameter = 'edit_upsert_elevation_from_dem' and cur_user = current_user) = 'TRUE' THEN
		NEW.top_elev = (SELECT public.ST_Value(rast,1,NEW.the_geom,false) FROM ext_raster_dem order by st_value limit 1);
	END IF;  
	

        UPDATE node 
        SET custom_top_elev=NEW.custom_top_elev, custom_ymax=NEW.custom_ymax, custom_elev=NEW.custom_elev, nodecat_id=NEW.nodecat_id, sector_id=NEW.sector_id,  
            annotation=NEW.annotation
        WHERE node_id=OLD.node_id;

        IF v_node_table = 'inp_junction' THEN
            UPDATE inp_junction 
			SET y0=NEW.y0, ysur=NEW.ysur, apond=NEW.apond, outfallparam = NEW.outfallparam::json
			WHERE node_id=OLD.node_id;
			
        ELSIF v_node_table = 'inp_divider' THEN
            UPDATE inp_divider 
			SET divider_type=NEW.divider_type, arc_id=NEW.arc_id, curve_id=NEW.curve_id,qmin=NEW.qmin,ht=NEW.ht,cd=NEW.cd,y0=NEW.y0, ysur=NEW.ysur, apond=NEW.apond 
			WHERE node_id=OLD.node_id; 
			
        ELSIF v_node_table = 'inp_storage' THEN
            UPDATE inp_storage 
			SET storage_type=NEW.storage_type,curve_id=NEW.curve_id,a1=NEW.a1,a2=NEW.a2,a0=NEW.a0,fevap=NEW.fevap,sh=NEW.sh,hc=NEW.hc,imd=NEW.imd,y0=NEW.y0, ysur=NEW.ysur, apond=NEW.apond 
			WHERE node_id=OLD.node_id;
			
        ELSIF v_node_table = 'inp_outfall' THEN          
            UPDATE inp_outfall 
			SET outfall_type=NEW.outfall_type,stage=NEW.stage,curve_id=NEW.curve_id,timser_id=NEW.timser_id,gate=NEW.gate 
			WHERE node_id=OLD.node_id;
        END IF;

        RETURN NEW;


    ELSIF TG_OP = 'DELETE' THEN
        RETURN gw_fct_audit_function(1032,1210, NULL);
        
    END IF;
       
END;
$$;
 
  