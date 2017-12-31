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
				RAISE EXCEPTION 'Si us plau, assigna un node_id al que poder vincular aquesta geometria poligon';
			END IF;
		END IF;
		
		IF man_table='man_register_pol' THEN
			IF (SELECT node_id FROM man_register WHERE node_id=NEW.node_id) IS NULL THEN
				RAISE EXCEPTION 'No es possible de vincular aquesta geometria poligon a cap node. El node a assignar ha de ser un node tipus registre!';
			END  IF;
			sys_type_var='REGISTER';
		
		ELSIF man_table='man_tank_pol' THEN
			IF (SELECT node_id FROM man_tank WHERE node_id=NEW.node_id) IS NULL THEN
				RAISE EXCEPTION 'No es possible de vincular aquesta geometria poligon a cap node. El node a assignar ha de ser un node tipus tank!';
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
				IF (SELECT node_id FROM man_register WHERE node_id=NEW.node_id)=NULL THEN
					RAISE EXCEPTION 'El node_id subministrat no existeix com a registre. Cerca un altre node';
				END  IF;
				UPDATE man_register SET pol_id=NULL WHERE node_id=OLD.node_id;
				UPDATE man_register SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;
			
			ELSIF man_table ='man_tank_pol' THEN
				IF (SELECT node_id FROM man_tank WHERE node_id=NEW.node_id)=NULL THEN
					RAISE EXCEPTION 'El node_id subministrat no existeix com a tank. Cerca un altre node';
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


DROP TRIGGER IF EXISTS gw_trg_edit_man_tank_pol ON "SCHEMA_NAME".v_edit_man_tank_pol;
CREATE TRIGGER gw_trg_edit_man_tank_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_tank_pol FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_tank_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_register_pol ON "SCHEMA_NAME".v_edit_man_register_pol;
CREATE TRIGGER gw_trg_edit_man_register_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_register_pol FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node_pol('man_register_pol');

