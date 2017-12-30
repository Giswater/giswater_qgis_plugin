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
	poltype_aux text;
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
		
		IF man_table='man_netgully_pol' THEN
			IF (SELECT node_id FROM man_netgully WHERE node_id=NEW.node_id) IS NULL THEN
				RAISE EXCEPTION 'No es possible de vincular aquesta geometria poligon a cap node. El node a assignar ha de ser un node tipus netgully!';
			END  IF;
			poltype_aux='NETGULLY';
			
		ELSIF man_table='man_storage_pol' THEN
			IF (SELECT node_id FROM man_storage WHERE node_id=NEW.node_id) IS NULL THEN
				RAISE EXCEPTION 'No es possible de vincular aquesta geometria poligon a cap node. El node a assignar ha de ser un node tipus storage!';
			END  IF;
			poltype_aux='STORAGE';
			
		ELSIF man_table='man_chamber_pol' THEN
			IF (SELECT node_id FROM man_chamber WHERE node_id=NEW.node_id) IS NULL THEN
				RAISE EXCEPTION 'No es possible de vincular aquesta geometria poligon a cap node. El node a assignar ha de ser un node tipus chamber!';
			END  IF;
			poltype_aux='CHAMBER';
			
		ELSIF man_table='man_wwtp_pol' THEN
			IF (SELECT node_id FROM man_wwtp WHERE node_id=NEW.node_id) IS NULL THEN
				RAISE EXCEPTION 'No es possible de vincular aquesta geometria poligon a cap node. El node a assignar ha de ser un node tipus wwtp!';
			END  IF;
			poltype_aux='WWTP';

		END IF;
		
		-- Insert into polygon table
		INSERT INTO polygon (pol_id, pol_type, the_geom) VALUES (NEW.pol_id, poltype_aux, NEW.the_geom);
		
		
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
					RAISE EXCEPTION 'El node_id subministrat no existeix com a netgully. Cerca un altre node';
				END  IF;
				UPDATE man_netgully SET pol_id=NULL WHERE node_id=OLD.node_id;
				UPDATE man_netgully SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;
			
			ELSIF man_table ='man_storage_pol' THEN
				IF (SELECT node_id FROM man_storage WHERE node_id=NEW.node_id)=NULL THEN
					RAISE EXCEPTION 'El node_id subministrat no existeix com a storage. Cerca un altre node';
				END  IF;
				UPDATE man_storage SET pol_id=NULL WHERE node_id=OLD.node_id;
				UPDATE man_storage SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;

			ELSIF man_table ='man_chamber_pol' THEN
				IF (SELECT node_id FROM man_chamber WHERE node_id=NEW.node_id)=NULL THEN
					RAISE EXCEPTION 'El node_id subministrat no existeix com a chamber. Cerca un altre node';
				END  IF;
				UPDATE man_chamber SET pol_id=NULL WHERE node_id=OLD.node_id;
				UPDATE man_chamber SET pol_id=NEW.pol_id WHERE node_id=NEW.node_id;

			ELSIF man_table ='man_wwtp_pol' THEN
				IF (SELECT node_id FROM man_wwtp WHERE node_id=NEW.node_id)=NULL THEN
					RAISE EXCEPTION 'El node_id subministrat no existeix com a wwtp. Cerca un altre node';
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
