/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1210

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_inp_node() RETURNS trigger LANGUAGE plpgsql AS $$
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
        RETURN audit_function(1030,1210); 


    ELSIF TG_OP = 'UPDATE' THEN
	
		-- State
		IF (NEW.state != OLD.state) THEN
			UPDATE node SET state=NEW.state WHERE node_id = OLD.node_id;
		END IF;
			
		-- The geom
		IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom)  THEN
			UPDATE node SET the_geom=NEW.the_geom WHERE node_id = OLD.node_id;
		END IF;
	

        UPDATE node 
        SET custom_top_elev=NEW.custom_top_elev, custom_ymax=NEW.custom_ymax, custom_elev=NEW.custom_elev, nodecat_id=NEW.nodecat_id, sector_id=NEW.sector_id,  
            annotation=NEW.annotation
        WHERE node_id=OLD.node_id;

        IF node_table = 'inp_junction' THEN
            UPDATE inp_junction 
			SET y0=NEW.y0, ysur=NEW.ysur, apond=NEW.apond 
			WHERE node_id=OLD.node_id;
			
        ELSIF node_table = 'inp_divider' THEN
            UPDATE inp_divider 
			SET divider_type=NEW.divider_type, arc_id=NEW.arc_id, curve_id=NEW.curve_id,qmin=NEW.qmin,ht=NEW.ht,cd=NEW.cd,y0=NEW.y0, ysur=NEW.ysur, apond=NEW.apond 
			WHERE node_id=OLD.node_id; 
			
        ELSIF node_table = 'inp_storage' THEN
            UPDATE inp_storage 
			SET storage_type=NEW.storage_type,curve_id=NEW.curve_id,a1=NEW.a1,a2=NEW.a2,a0=NEW.a0,fevap=NEW.fevap,sh=NEW.sh,hc=NEW.hc,imd=NEW.imd,y0=NEW.y0, ysur=NEW.ysur, apond=NEW.apond 
			WHERE node_id=OLD.node_id;
			
        ELSIF node_table = 'inp_outlfall' THEN          
            UPDATE inp_outfall 
			SET outfall_type=NEW.outfall_type,stage=NEW.stage,curve_id=NEW.curve_id,timser_id=NEW.timser_id,gate=NEW.gate 
			WHERE node_id=OLD.node_id;
        END IF;

        RETURN NEW;


    ELSIF TG_OP = 'DELETE' THEN
        RETURN audit_function(1032,1210);
    
    END IF;
       
END;
$$;


DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_junction ON "SCHEMA_NAME".v_edit_inp_junction;
CREATE TRIGGER gw_trg_edit_inp_node_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_junction 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_junction', 'JUNCTION');
 
DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_divider ON "SCHEMA_NAME".v_edit_inp_divider;
CREATE TRIGGER gw_trg_edit_inp_node_divider INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_divider
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_divider', 'DIVIDER');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_outfall ON "SCHEMA_NAME".v_edit_inp_outfall;
CREATE TRIGGER gw_trg_edit_inp_node_outfall INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_outfall
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_outfall', 'OUTFALL');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_node_storage ON "SCHEMA_NAME".v_edit_inp_storage;
CREATE TRIGGER gw_trg_edit_inp_node_storage INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_inp_storage 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_inp_node('inp_storage', 'STORAGE');
  
  