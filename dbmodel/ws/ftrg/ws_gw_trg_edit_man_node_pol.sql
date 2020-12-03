/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/

--FUNCTION CODE: 2462


-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_man_node_pol();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_man_node_pol()  RETURNS trigger AS
$BODY$

DECLARE 
    man_table varchar;
	sys_type_var text;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	man_table:= TG_ARGV[0];
		
	
	-- INSERT
	IF TG_OP = 'INSERT' THEN
	
		-- Pol ID	
		IF (NEW.pol_id IS NULL) THEN
			PERFORM setval('urn_id_seq', gw_fct_setvalurn(),true);
			NEW.pol_id:= (SELECT nextval('urn_id_seq'));
		END IF;
		
		-- Node ID	
		IF (NEW.node_id IS NULL) THEN
			NEW.node_id:= (SELECT node_id FROM v_edit_node WHERE ST_DWithin(NEW.the_geom, v_edit_node.the_geom,0.001) 
			ORDER BY ST_distance(ST_centroid(NEW.the_geom),v_edit_node.the_geom) ASC LIMIT 1);
			IF (NEW.node_id IS NULL) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        		"data":{"message":"2052", "function":"2462","debug_msg":null}}$$);';
			END IF;
		END IF;
		
		IF man_table='man_register_pol' THEN
			IF (SELECT node_id FROM man_register WHERE node_id=NEW.node_id) IS NULL THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        		"data":{"message":"2100", "function":"2462","debug_msg":null}}$$);';
			END  IF;
			sys_type_var='REGISTER';
		
		ELSIF man_table='man_tank_pol' THEN
			IF (SELECT node_id FROM man_tank WHERE node_id=NEW.node_id) IS NULL THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        		"data":{"message":"2102", "function":"2462","debug_msg":null}}$$);';
			END  IF;
			sys_type_var='TANK';
		
		END IF;
		
		-- Insert into polygon table
		INSERT INTO polygon (pol_id, sys_type, the_geom) VALUES (NEW.pol_id, sys_type_var, NEW.the_geom);
		
		
		-- Update man table
		IF man_table='man_register_pol' THEN
			UPDATE man_register SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;
		
		ELSIF man_table='man_tank_pol' THEN
			UPDATE man_tank SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;
		
		END IF;

		RETURN NEW;
		
    
	-- UPDATE
    ELSIF TG_OP = 'UPDATE' THEN
	
		UPDATE polygon SET pol_id=NEW.pol_id, the_geom=NEW.the_geom WHERE pol_id=OLD.pol_id;
		
		IF (NEW.node_id != OLD.node_id) THEN
			IF man_table ='man_register_pol' THEN
				IF (SELECT node_id FROM man_register WHERE node_id=NEW.node_id) IS NULL THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        			"data":{"message":"2104", "function":"2462","debug_msg":null}}$$);';
				END  IF;
				UPDATE man_register SET pol_id=NULL WHERE node_id=OLD.node_id;
				UPDATE man_register SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;
			
			ELSIF man_table ='man_tank_pol' THEN
				IF (SELECT node_id FROM man_tank WHERE node_id=NEW.node_id) IS NULL THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        			"data":{"message":"2106", "function":"2462","debug_msg":null}}$$);';
				END  IF;
				UPDATE man_tank SET pol_id=NULL WHERE node_id=OLD.node_id;
				UPDATE man_tank SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;
			END IF;
			
		END IF;
		
		RETURN NEW;
    
	-- DELETE
    ELSIF TG_OP = 'DELETE' THEN
	
		IF man_table ='man_register_pol' THEN
			UPDATE man_register SET pol_id=NULL WHERE node_id=OLD.node_id;
					
		ELSIF man_table ='man_tank_pol' THEN
			UPDATE man_tank SET pol_id=NULL WHERE node_id=OLD.node_id;
						
		END IF;

		DELETE FROM polygon WHERE pol_id=OLD.pol_id;
				
		RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
