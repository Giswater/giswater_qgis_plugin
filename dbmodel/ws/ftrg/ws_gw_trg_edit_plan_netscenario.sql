/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_plan_netscenario()  RETURNS trigger AS
$BODY$

DECLARE 
v_newpattern json;
v_status boolean;
v_value text;
v_mapzone text;
BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	v_mapzone = TG_ARGV[0];

	IF TG_OP = 'INSERT' THEN
		
		IF v_mapzone = 'DMA' THEN

			-- dma_id
			IF NEW.dma_id is null THEN
				SELECT max(dma_id) +1 into NEW.dma_id FROM plan_netscenario_dma WHERE netscenario_id = NEW.netscenario_id;
			END IF;

			INSERT INTO plan_netscenario_dma (netscenario_id, dma_id, dma_name, pattern_id, graphconfig, the_geom)
			VALUES (NEW.netscenario_id, NEW.dma_id, NEW.dma_name, NEW.pattern_id, NEW.graphconfig, NEW.the_geom) ON CONFLICT (netscenario_id, dma_id) DO NOTHING;

		ELSIF v_mapzone = 'PRESSZONE' THEN

			-- presszone_id
			IF NEW.presszone_id is null THEN
				 SELECT max(presszone_id) +1 into NEW.presszone_id FROM plan_netscenario_presszone WHERE netscenario_id = NEW.netscenario_id;
			END IF;

			INSERT INTO plan_netscenario_presszone (netscenario_id, presszone_id, presszone_name, head, graphconfig, the_geom)
			VALUES (NEW.netscenario_id, NEW.presszone_id, NEW.presszone_name, NEW.head, NEW.graphconfig, NEW.the_geom) ON CONFLICT (netscenario_id, presszone_id) DO NOTHING;

		END IF;
		RETURN NEW;
		
	ELSIF TG_OP = 'UPDATE' THEN
   	IF v_mapzone = 'DMA' THEN
			UPDATE plan_netscenario_dma 
			SET dma_id=NEW.dma_id, dma_name=NEW.dma_name,  the_geom=NEW.the_geom, pattern_id=NEW.pattern_id, graphconfig=NEW.graphconfig::json
			WHERE dma_id=OLD.dma_id AND netscenario_id=NEW.netscenario_id;
		
		ELSIF v_mapzone = 'PRESSZONE' THEN
			UPDATE plan_netscenario_presszone 
			SET presszone_id=NEW.presszone_id, presszone_name=NEW.presszone_name,  the_geom=NEW.the_geom, head=NEW.head, graphconfig=NEW.graphconfig::json
			WHERE presszone_id=OLD.presszone_id AND netscenario_id=NEW.netscenario_id;
		END IF;

		RETURN NEW;
		
	ELSIF TG_OP = 'DELETE' THEN  
	 
	 	IF v_mapzone = 'DMA' THEN
			DELETE FROM plan_netscenario_dma WHERE dma_id = OLD.dma_id;
		ELSIF v_mapzone = 'PRESSZONE' THEN
			DELETE FROM plan_netscenario_presszone WHERE presszone_id = OLD.presszone_id;
		END IF;

		RETURN NULL;
     
	END IF;

END;
	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

