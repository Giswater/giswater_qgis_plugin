/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION NODE: 1310


-----------------------------
-- TRIGGERS EDITING VIEWS FOR NODE
-----------------------------

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_inp_node() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    node_table varchar;
    man_table varchar;
    epa_type varchar;
    v_sql varchar;
    old_nodetype varchar;
    new_nodetype varchar;
    v_tablename varchar;
    v_pol_id varchar;
    v_node_id varchar;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    node_table:= TG_ARGV[0];
    epa_type:= TG_ARGV[1];

   
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN
        PERFORM audit_function(1030,1310); 
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
	
	-- State
	IF (NEW.state != OLD.state) THEN
		UPDATE node SET state=NEW.state WHERE node_id = OLD.node_id;
	END IF;

	-- The geom
	IF st_equals( NEW.the_geom, OLD.the_geom) IS FALSE THEN
		
		--the_geom
		UPDATE node SET the_geom=NEW.the_geom WHERE node_id = OLD.node_id;
			
		-- Parent id
		SELECT substring (tablename from 8 for 30), pol_id INTO v_tablename, v_pol_id FROM polygon JOIN sys_feature_cat ON sys_feature_cat.id=polygon.sys_type
		WHERE ST_DWithin(NEW.the_geom, polygon.the_geom, 0.001) LIMIT 1;
	
		IF v_pol_id IS NOT NULL THEN
			v_sql:= 'SELECT node_id FROM '||v_tablename||' WHERE pol_id::integer='||v_pol_id||' LIMIT 1';
			EXECUTE v_sql INTO v_node_id;
			NEW.parent_id=v_node_id;
		END IF;
			
		--update elevation from raster
		IF (SELECT upper(value) FROM config_param_system WHERE parameter='sys_raster_dem') = 'TRUE' AND (NEW.elevation IS NULL) AND 
		(SELECT upper(value)  FROM config_param_user WHERE parameter = 'edit_upsert_elevation_from_dem' and cur_user = current_user) = 'TRUE' THEN
			NEW.elevation = (SELECT ST_Value(rast,1,NEW.the_geom,false) FROM ext_raster_dem WHERE id =
				(SELECT id FROM ext_raster_dem WHERE
				st_dwithin (ST_MakeEnvelope(
				ST_UpperLeftX(rast), 
				ST_UpperLeftY(rast),
				ST_UpperLeftX(rast) + ST_ScaleX(rast)*ST_width(rast),	
				ST_UpperLeftY(rast) + ST_ScaleY(rast)*ST_height(rast), st_srid(rast)), NEW.the_geom, 1) LIMIT 1));
		END IF;
	END IF;
	
	-- catalog
        IF (NEW.nodecat_id <> OLD.nodecat_id) THEN  
            old_nodetype:= (SELECT node_type.type FROM node_type JOIN cat_node ON (((node_type.id)::text = (cat_node.nodetype_id)::text)) WHERE cat_node.id=OLD.nodecat_id)::text;
            new_nodetype:= (SELECT node_type.type FROM node_type JOIN cat_node ON (((node_type.id)::text = (cat_node.nodetype_id)::text)) WHERE cat_node.id=NEW.nodecat_id)::text;
            IF (quote_literal(old_nodetype)::text <> quote_literal(new_nodetype)::text) THEN
                PERFORM audit_function(1016,1310); 
                RETURN NULL;
            END IF;
        END IF;

        IF node_table = 'inp_junction' THEN
            UPDATE inp_junction SET demand=NEW.demand, pattern_id=NEW.pattern_id WHERE node_id=OLD.node_id;
        ELSIF node_table = 'inp_reservoir' THEN
            UPDATE inp_reservoir SET pattern_id=NEW.pattern_id WHERE node_id=OLD.node_id;  
        ELSIF node_table = 'inp_tank' THEN
            UPDATE inp_tank SET initlevel=NEW.initlevel, minlevel=NEW.minlevel, maxlevel=NEW.maxlevel, diameter=NEW.diameter, minvol=NEW.minvol, curve_id=NEW.curve_id WHERE node_id=OLD.node_id;
        ELSIF node_table = 'inp_pump' THEN          
            UPDATE inp_pump SET power=NEW.power, curve_id=NEW.curve_id, speed=NEW.speed, pattern=NEW.pattern, to_arc=NEW.to_arc, status=NEW.status , pump_type=NEW.pump_type WHERE node_id=OLD.node_id;
        ELSIF node_table = 'inp_valve' THEN     
            UPDATE inp_valve SET valv_type=NEW.valv_type, pressure=NEW.pressure, flow=NEW.flow, coef_loss=NEW.coef_loss, curve_id=NEW.curve_id,
            minorloss=NEW.minorloss, to_arc=NEW.to_arc, status=NEW.status WHERE node_id=OLD.node_id;
        ELSIF node_table = 'inp_shortpipe' THEN     
            UPDATE inp_shortpipe SET minorloss=NEW.minorloss, to_arc=NEW.to_arc, status=NEW.status WHERE node_id=OLD.node_id;  
        ELSIF node_table = 'inp_inlet' THEN     
            UPDATE inp_inlet SET initlevel=NEW.initlevel, minlevel=NEW.minlevel, maxlevel=NEW.maxlevel, diameter=NEW.diameter, minvol=NEW.minvol, curve_id=NEW.curve_id,
            pattern_id=NEW.pattern_id WHERE node_id=OLD.node_id;
        END IF;


        UPDATE node 
        SET elevation=NEW.elevation, "depth"=NEW."depth", nodecat_id=NEW.nodecat_id, sector_id=NEW.sector_id, "state"=NEW."state", 
            annotation=NEW.annotation, the_geom=NEW.the_geom 
        WHERE node_id=OLD.node_id;

        PERFORM audit_function(2,1310); 
        RETURN NEW;
        
    ELSIF TG_OP = 'DELETE' THEN
        PERFORM audit_function(1032,1310); 
        RETURN NEW;
    
    END IF;
       
END;
$$;
  