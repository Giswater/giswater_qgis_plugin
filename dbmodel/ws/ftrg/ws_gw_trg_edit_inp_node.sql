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
		IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom)  THEN
			UPDATE node SET the_geom=NEW.the_geom WHERE node_id = OLD.node_id;
		END IF;

		
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
            UPDATE inp_pump SET power=NEW.power, curve_id=NEW.curve_id, speed=NEW.speed, pattern=NEW.pattern, to_arc=NEW.to_arc, status=NEW.status WHERE node_id=OLD.node_id;
        ELSIF node_table = 'inp_valve' THEN     
            UPDATE inp_valve SET valv_type=NEW.valv_type, pressure=NEW.pressure, flow=NEW.flow, coef_loss=NEW.coef_loss, curve_id=NEW.curve_id, minorloss=NEW.minorloss, to_arc=NEW.to_arc, status=NEW.status WHERE node_id=OLD.node_id;
        ELSIF node_table = 'inp_shortpipe' THEN     
            UPDATE inp_shortpipe SET minorloss=NEW.minorloss, to_arc=NEW.to_arc, status=NEW.status WHERE node_id=OLD.node_id;  
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
  