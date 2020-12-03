/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/

--FUNCTION CODE: 2418


-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_man_node_pol();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_man_node_pol()  RETURNS trigger AS
$BODY$

DECLARE 
    v_man_table varchar;
	v_sys_type text;


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	v_man_table:= TG_ARGV[0];
		
	
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
      		 	"data":{"message":"2052", "function":"2418","debug_msg":null}}$$);';
			END IF;
		END IF;
		
		IF v_man_table='man_netgully_pol' THEN
			IF (SELECT node_id FROM man_netgully WHERE node_id=NEW.node_id) IS NULL THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
      		 	"data":{"message":"2054", "function":"2418","debug_msg":null}}$$);';
			END  IF;
			v_sys_type='NETGULLY';
			
		ELSIF v_man_table='man_storage_pol' THEN
			IF (SELECT node_id FROM man_storage WHERE node_id=NEW.node_id) IS NULL THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
      		 	"data":{"message":"2056", "function":"2418","debug_msg":null}}$$);';
			END  IF;
			v_sys_type='STORAGE';
			
		ELSIF v_man_table='man_chamber_pol' THEN
			IF (SELECT node_id FROM man_chamber WHERE node_id=NEW.node_id) IS NULL THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
      		 	"data":{"message":"2058", "function":"2418","debug_msg":null}}$$);';
			END  IF;
			v_sys_type='CHAMBER';
			
		ELSIF v_man_table='man_wwtp_pol' THEN
			IF (SELECT node_id FROM man_wwtp WHERE node_id=NEW.node_id) IS NULL THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
      		 	"data":{"message":"2060", "function":"2418","debug_msg":null}}$$);';
			END  IF;
			v_sys_type='WWTP';

		END IF;
		
		-- Insert into polygon table
		INSERT INTO polygon (pol_id, sys_type, the_geom) VALUES (NEW.pol_id, v_sys_type, NEW.the_geom);
		
		
		-- Update man table
		IF v_man_table='man_netgully_pol' THEN
			UPDATE man_netgully SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;
	
		ELSIF v_man_table='man_storage_pol' THEN
			UPDATE man_storage SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;
		
		ELSIF v_man_table='man_chamber_pol' THEN
			UPDATE man_chamber SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;
		
		ELSIF v_man_table='man_wwtp_pol' THEN
			UPDATE man_wwtp SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;
		
		END IF;

		RETURN NEW;
		
    
	-- UPDATE
    ELSIF TG_OP = 'UPDATE' THEN
	
		UPDATE polygon SET pol_id=NEW.pol_id, the_geom=NEW.the_geom WHERE pol_id=OLD.pol_id;
		
		IF (NEW.node_id != OLD.node_id) THEN
			IF v_man_table ='man_netgully_pol' THEN
				IF (SELECT node_id FROM man_netgully WHERE node_id=NEW.node_id) IS NULL THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
      		 		"data":{"message":"2062", "function":"2418","debug_msg":null}}$$);';
				END  IF;
				UPDATE man_netgully SET pol_id=NULL WHERE node_id=OLD.node_id;
				UPDATE man_netgully SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;
			
			ELSIF v_man_table ='man_storage_pol' THEN
				IF (SELECT node_id FROM man_storage WHERE node_id=NEW.node_id) IS NULL THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
      		 		"data":{"message":"2064", "function":"2418","debug_msg":null}}$$);';
				END  IF;
				UPDATE man_storage SET pol_id=NULL WHERE node_id=OLD.node_id;
				UPDATE man_storage SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;

			ELSIF v_man_table ='man_chamber_pol' THEN
				IF (SELECT node_id FROM man_chamber WHERE node_id=NEW.node_id) IS NULL THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
      		 		"data":{"message":"2066", "function":"2418","debug_msg":null}}$$);';
				END  IF;
				UPDATE man_chamber SET pol_id=NULL WHERE node_id=OLD.node_id;
				UPDATE man_chamber SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;

			ELSIF v_man_table ='man_wwtp_pol' THEN
				IF (SELECT node_id FROM man_wwtp WHERE node_id=NEW.node_id) IS NULL THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
      		 		"data":{"message":"2068", "function":"2418","debug_msg":null}}$$);';
				END  IF;
				UPDATE man_wwtp SET pol_id=NULL WHERE node_id=OLD.node_id;
				UPDATE man_wwtp SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;	
				
			END IF;
			
		END IF;
		
		RETURN NEW;
    
	-- DELETE
    ELSIF TG_OP = 'DELETE' THEN
	
		IF v_man_table ='man_netgully_pol' THEN
			UPDATE man_netgully SET pol_id=NULL WHERE node_id=OLD.node_id;
					
		ELSIF v_man_table ='man_storage_pol' THEN
			UPDATE man_storage SET pol_id=NULL WHERE node_id=OLD.node_id;

		ELSIF v_man_table ='man_chamber_pol' THEN
			UPDATE man_chamber SET pol_id=NULL WHERE node_id=OLD.node_id;
			
		ELSIF v_man_table ='man_wwtp_pol' THEN
			UPDATE man_wwtp SET pol_id=NULL WHERE node_id=OLD.node_id;
						
		END IF;

		DELETE FROM polygon WHERE pol_id=OLD.pol_id;
				
		RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;