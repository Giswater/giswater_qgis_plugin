/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/

--FUNCTION CODE: XXXX

-- Function: "SCHEMA_NAME".gw_trg_edit_man_node_pol()

-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_man_node_pol();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_man_node_pol()  RETURNS trigger AS
$BODY$

DECLARE 
    man_table varchar;
	sys_type_var text;
	rec record;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	man_table:= TG_ARGV[0];
		
	--Get data from config table
	SELECT * INTO rec FROM config;	
	
	-- INSERT
	IF TG_OP = 'INSERT' THEN
	
		-- Pol ID	
		IF (NEW.pol_id IS NULL) THEN
			NEW.pol_id:= (SELECT nextval('urn_id_seq'));
		END IF;
		
		-- Node ID	
		IF (NEW.node_id IS NULL) THEN
			NEW.node_id:= (SELECT node_id FROM node WHERE ST_DWithin(NEW.the_geom, node.the_geom,0.001) 
			ORDER BY ST_distance(ST_centroid(NEW.the_geom),node.the_geom) ASC LIMIT 1);
			IF (NEW.node_id IS NULL) THEN
				RAISE EXCEPTION 'Please, assign one node to relate this polygon geometry';
			END IF;
		END IF;
		
		IF man_table='man_netgully_pol' THEN
			IF (SELECT node_id FROM man_netgully WHERE node_id=NEW.node_id) IS NULL THEN
				RAISE EXCEPTION 'It is not possible to relate this geometry to any node. The connec must be type ''NETGULLY'' (system type).!!';
			END  IF;
			sys_type_var='NETGULLY';
			
		ELSIF man_table='man_storage_pol' THEN
			IF (SELECT node_id FROM man_storage WHERE node_id=NEW.node_id) IS NULL THEN
				RAISE EXCEPTION 'It is not possible to relate this geometry to any connec. The connec must be type ''STORAGE'' (system type).!';
			END  IF;
			sys_type_var='STORAGE';
			
		ELSIF man_table='man_chamber_pol' THEN
			IF (SELECT node_id FROM man_chamber WHERE node_id=NEW.node_id) IS NULL THEN
				RAISE EXCEPTION 'It is not possible to relate this geometry to any connec. The connec must be type ''CHAMBER'' (system type).!';
			END  IF;
			sys_type_var='CHAMBER';
			
		ELSIF man_table='man_wwtp_pol' THEN
			IF (SELECT node_id FROM man_wwtp WHERE node_id=NEW.node_id) IS NULL THEN
				RAISE EXCEPTION 'It is not possible to relate this geometry to any connec. The connec must be type ''WWTP'' (system type).!';
			END  IF;
			sys_type_var='WWTP';

		END IF;
		
		-- Insert into polygon table
		INSERT INTO polygon (pol_id, sys_type, the_geom) VALUES (NEW.pol_id, sys_type_var, NEW.the_geom);
		
		
		-- Update man table
		IF man_table='man_netgully_pol' THEN
			UPDATE man_netgully SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;
	
		ELSIF man_table='man_storage_pol' THEN
			UPDATE man_storage SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;
		
		ELSIF man_table='man_chamber_pol' THEN
			UPDATE man_chamber SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;
		
		ELSIF man_table='man_wwtp_pol' THEN
			UPDATE man_wwtp SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;
		
		END IF;

		RETURN NEW;
		
    
	-- UPDATE
    ELSIF TG_OP = 'UPDATE' THEN
	
		UPDATE polygon SET pol_id=NEW.pol_id, the_geom=NEW.the_geom WHERE pol_id=OLD.pol_id;
		
		IF (NEW.node_id != OLD.node_id) THEN
			IF man_table ='man_netgully_pol' THEN
				IF (SELECT node_id FROM man_netgully WHERE node_id=NEW.node_id)=NULL THEN
					RAISE EXCEPTION 'The provided node_id don''t exists as a ''NETGULLY'' (system type). Please look for another node!';
				END  IF;
				UPDATE man_netgully SET pol_id=NULL WHERE node_id=OLD.node_id;
				UPDATE man_netgully SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;
			
			ELSIF man_table ='man_storage_pol' THEN
				IF (SELECT node_id FROM man_storage WHERE node_id=NEW.node_id)=NULL THEN
					RAISE EXCEPTION 'The provided node_id don''t exists as a ''STORAGE'' (system type). Please look for another node!';
				END  IF;
				UPDATE man_storage SET pol_id=NULL WHERE node_id=OLD.node_id;
				UPDATE man_storage SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;

			ELSIF man_table ='man_chamber_pol' THEN
				IF (SELECT node_id FROM man_chamber WHERE node_id=NEW.node_id)=NULL THEN
					RAISE EXCEPTION 'The provided node_id don''t exists as a ''CHAMBER'' (system type). Please look for another node!';
				END  IF;
				UPDATE man_chamber SET pol_id=NULL WHERE node_id=OLD.node_id;
				UPDATE man_chamber SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;

			ELSIF man_table ='man_wwtp_pol' THEN
				IF (SELECT node_id FROM man_wwtp WHERE node_id=NEW.node_id)=NULL THEN
					RAISE EXCEPTION 'The provided node_id don''t exists as a ''WWTP'' (system type). Please look for another node!';
				END  IF;
				UPDATE man_wwtp SET pol_id=NULL WHERE node_id=OLD.node_id;
				UPDATE man_wwtp SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;	
				
			END IF;
			
		END IF;
		
		RETURN NEW;
    
	-- DELETE
    ELSIF TG_OP = 'DELETE' THEN
	
		IF man_table ='man_netgully_pol' THEN
			UPDATE man_netgully SET pol_id=NULL WHERE node_id=OLD.node_id;
					
		ELSIF man_table ='man_storage_pol' THEN
			UPDATE man_storage SET pol_id=NULL WHERE node_id=OLD.node_id;

		ELSIF man_table ='man_chamber_pol' THEN
			UPDATE man_chamber SET pol_id=NULL WHERE node_id=OLD.node_id;
			
		ELSIF man_table ='man_wwtp_pol' THEN
			UPDATE man_wwtp SET pol_id=NULL WHERE node_id=OLD.node_id;
						
		END IF;

		DELETE FROM polygon WHERE pol_id=OLD.pol_id;
				
		RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


DROP TRIGGER IF EXISTS gw_trg_edit_man_storage_pol ON "SCHEMA_NAME".v_edit_man_storage_pol;
CREATE TRIGGER gw_trg_edit_man_storage_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_storage_pol FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_storage_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_netgully_pol ON "SCHEMA_NAME".v_edit_man_netgully_pol;
CREATE TRIGGER gw_trg_edit_man_netgully_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netgully_pol FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_netgully_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_chamber_pol ON "SCHEMA_NAME".v_edit_man_chamber_pol;
CREATE TRIGGER gw_trg_edit_man_chamber_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_chamber_pol FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_chamber_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_wwtp_pol ON "SCHEMA_NAME".v_edit_man_wwtp_pol;
CREATE TRIGGER gw_trg_edit_man_wwtp_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wwtp_pol FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_wwtp_pol');
